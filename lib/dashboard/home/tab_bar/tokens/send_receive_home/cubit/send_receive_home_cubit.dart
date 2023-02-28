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
      emit(state.copyWith(selectedToken: selectedToken));
      await getOperations(
        baseUrl: baseUrl,
      );
    } catch (e, s) {
      getLogger(runtimeType.toString()).e('error in init() e: $e, $s', e, s);
      if (isClosed) return;
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
      'limit': 1000,
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
        'limit': 1000
      };
    } else {
      params = <String, dynamic>{
        'anyof.sender.target': contractAddress,
        'entrypoint': 'transfer',
        'limit': 1000,
        'parameter.in': jsonEncode([
          {'to': walletAddress},
          {'from': walletAddress}
        ]),
      };
    }

    try {
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
    } catch (e, s) {
      getLogger(toString()).e('e: $e, s: $s');
      return [];
    }
  }

  Future<List<OperationModel>> _getEthereumOperations({
    required String walletAddress,
    required String contractAddress,
    required EthereumNetwork ehtereumNetwork,
  }) async {

    await dotenv.load();
    final moralisApiKey = dotenv.get('MORALIS_API_KEY');

    List<dynamic> result;
    List<OperationModel> operations = [];
    if (contractAddress != '') {
      try {
        final dynamic response = await client.get(
          '${ehtereumNetwork.apiUrl}/$walletAddress/erc20/transfers?chain=${ehtereumNetwork.chain}',
          headers: <String, dynamic>{
            'X-API-KEY': moralisApiKey,
          },
        );

        result = response['result'] as List<dynamic>;
        result.removeWhere(
          (dynamic element) => element['address'] != contractAddress,
        );
        operations = result.map(
          (dynamic e) {
            final amount = (e['value'] is String)
                ? e['value'] as String
                : (e['amount'] is String)
                    ? e['amount'] as String
                    : (e['amount'] is List<String>)
                        ? (e['amount'] as List<String>)[0]
                        : (e['amount'] is int)
                            ? (e['amount'] as int).toString()
                            : 0.toString();
            return OperationModel(
              type: '',
              id: -1,
              level: 0,
              timestamp: e['block_timestamp'] as String,
              block: e['block_hash'] as String,
              hash: e['transaction_hash'] as String,
              counter: 0,
              sender:
                  OperationAddressModel(address: e['from_address'] as String),
              gasLimit: 0,
              gasUsed: 0,
              storageLimit: 0,
              storageUsed: 0,
              bakerFee: 0,
              storageFee: 0,
              allocationFee: 0,
              target: OperationAddressModel(address: e['to_address'] as String),
              amount: amount,
              status: 'applied',
              hasInternals: false,
            );
          },
        ).toList();
      } catch (e, s) {
        getLogger(toString()).e('having issue: $e, stack: $s');
      }
    } else {
      try {
        final dynamic response = await client.get(
          '${ehtereumNetwork.apiUrl}/$walletAddress?chain=${ehtereumNetwork.chain}',
          headers: <String, dynamic>{
            'X-API-KEY': moralisApiKey,
          },
        );
        final result = response['result'] as List<dynamic>;
        operations = result
            .map(
              (dynamic e) => OperationModel(
                type: '',
                id: -1,
                level: 0,
                timestamp: e['block_timestamp'] as String,
                block: e['block_hash'] as String,
                hash: e['hash'] as String,
                counter: int.parse(e['transaction_index'] as String),
                sender:
                    OperationAddressModel(address: e['from_address'] as String),
                gasLimit: int.parse(e['gas'] as String),
                gasUsed: int.parse(e['receipt_gas_used'] as String),
                storageLimit: 0,
                storageUsed: 0,
                bakerFee: 0,
                storageFee: 0,
                allocationFee: 0,
                target:
                    OperationAddressModel(address: e['to_address'] as String),
                amount: e['value'] as String,
                status: (e['receipt_status'] as String) == '1'
                    ? 'applied'
                    : 'failed',
                hasInternals: false,
              ),
            )
            .toList();
      } catch (e) {
        getLogger(toString()).e('having issue: $e');
      }
    }

    operations.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );
    return operations;
  }
}
