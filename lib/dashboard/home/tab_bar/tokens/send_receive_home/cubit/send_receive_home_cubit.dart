import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_receive_home_cubit.g.dart';

part 'send_receive_home_state.dart';

class SendReceiveHomeCubit extends Cubit<SendReceiveHomeState> {
  SendReceiveHomeCubit({
    required this.client,
    required this.walletCubit,
    required this.tokensCubit,
    required this.manageNetworkCubit,
    required TokenModel selectedToken,
  }) : super(
          SendReceiveHomeState(selectedToken: selectedToken),
        );

  final DioClient client;
  final WalletCubit walletCubit;
  final TokensCubit tokensCubit;
  final ManageNetworkCubit manageNetworkCubit;

  Future<void> init({String baseUrl = ''}) async {
    try {
      emit(state.loading());
      await tokensCubit.fetchFromZero();
      late TokenModel selectedToken;
      try {
        selectedToken = tokensCubit.state.data.firstWhere(
          (e) =>
              e.symbol == state.selectedToken.symbol &&
              e.contractAddress == state.selectedToken.contractAddress,
        );
      } catch (e, s) {
        selectedToken = state.selectedToken
            .copyWith(balance: '0', tokenUSDPrice: 0, balanceInUSD: 0);
        getLogger(runtimeType.toString())
            .e('did not found the token: e: $e, s: $s');
      }
      emit(state.success(selectedToken: selectedToken));
      await getOperations(
        baseUrl: baseUrl,
      );
    } catch (e, s) {
      getLogger(runtimeType.toString()).e('error in init() e: $e, $s', e, s);
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
    }
  }

  Future<void> getOperations({String baseUrl = ''}) async {
    try {
      emit(state.loading());

      final activeIndex = walletCubit.state.currentCryptoIndex;
      final walletAddress =
          walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;
      final blockchainType =
          walletCubit.state.cryptoAccount.data[activeIndex].blockchainType;

      late List<OperationModel> operations;
      if (blockchainType == BlockchainType.tezos) {
        operations = await _getTezosOperations(
          baseUrl: baseUrl,
          walletAddress: walletAddress,
          contractAddress: state.selectedToken.contractAddress,
        );
      } else {
        operations = await _getEthereumOperations(
          walletAddress: walletAddress,
          contractAddress: state.selectedToken.contractAddress,
          ehtereumNetwork: manageNetworkCubit.state.network as EthereumNetwork,
        );
      }

      emit(state.success(operations: operations));
    } catch (e, s) {
      getLogger(runtimeType.toString())
          .e('error in getOperations() e: $e, $s', e, s);
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
    }
  }

  Future<List<OperationModel>> _getFa2Transfers(String baseUrl) async {
    final activeIndex = walletCubit.state.currentCryptoIndex;
    final walletAddress =
        walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

    final params = <String, dynamic>{
      'anyof.from.to': walletAddress,
      'token.contract.eq': state.selectedToken.contractAddress,
    };
    final result = await client.get(
      '$baseUrl/v1/tokens/transfers',
      queryParameters: params,
    ) as List<dynamic>;

    final operations = result
        .map(
          (dynamic e) => OperationModel.fromFa2Json(e as Map<String, dynamic>),
        )
        .toList();
    operations.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );
    return operations;
  }

  Future<List<OperationModel>> _getTezosOperations({
    required String baseUrl,
    required String walletAddress,
    required String contractAddress,
  }) async {
    if (state.selectedToken.standard?.toLowerCase() == 'fa2') {
      return _getFa2Transfers(baseUrl);
    }

    late Map<String, dynamic> params;

    if (state.selectedToken.symbol == 'XTZ') {
      params = <String, dynamic>{
        'anyof.sender.target': walletAddress,
        'amount.gt': 0,
      };
    } else {
      params = <String, dynamic>{
        'anyof.sender.target': contractAddress,
        'entrypoint': 'transfer',
        'parameter.in': jsonEncode([
          {'to': walletAddress},
          {'from': walletAddress}
        ]),
      };
    }

    final result = await client.get(
      '$baseUrl/v1/operations/transactions',
      queryParameters: params,
    ) as List<dynamic>;

    final operations = result
        .map(
          (dynamic e) => OperationModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    operations.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );
    return operations;
  }

  Future<List<OperationModel>> _getEthereumOperations({
    required String walletAddress,
    required String contractAddress,
    required EthereumNetwork ehtereumNetwork,
  }) async {
    // https://deep-index.moralis.io/api/v2/0xd8da6bf26964af9d7eed9e03e53415d37aa96045?chain=eth

    await dotenv.load();
    final moralisApiKey = dotenv.get('MORALIS_API_KEY');

    final dynamic response = await client.get(
      '${ehtereumNetwork.apiUrl}/$walletAddress?chain=${ehtereumNetwork.chain}',
      headers: <String, dynamic>{
        'X-API-KEY': moralisApiKey,
      },
    );
    final result = response['result'] as List<dynamic>;

    final List<OperationModel> operations = result
        .map(
          (dynamic e) => OperationModel(
            type: '',
            id: -1,
            level: 0,
            timestamp: e['block_timestamp'] as String,
            block: e['block_hash'] as String,
            hash: e['hash'] as String,
            counter: int.parse(e['transaction_index'] as String),
            sender: OperationAddressModel(address: e['from_address'] as String),
            gasLimit: int.parse(e['gas'] as String),
            gasUsed: int.parse(e['receipt_gas_used'] as String),
            storageLimit: 0,
            storageUsed: 0,
            bakerFee: 0,
            storageFee: 0,
            allocationFee: 0,
            target: OperationAddressModel(address: e['to_address'] as String),
            amount: int.parse(e['value'] as String),
            status:
                (e['receipt_status'] as String) == '1' ? 'applied' : 'failed',
            hasInternals: false,
          ),
        )
        .toList();

    operations.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );
    return operations;
  }
}
