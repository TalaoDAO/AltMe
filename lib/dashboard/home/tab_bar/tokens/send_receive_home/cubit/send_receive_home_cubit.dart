import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_receive_home_cubit.g.dart';

part 'send_receive_home_state.dart';

class SendReceiveHomeCubit extends Cubit<SendReceiveHomeState> {
  SendReceiveHomeCubit({
    required this.client,
    required this.walletCubit,
    required this.tokensCubit,
    required TokenModel selectedToken,
  }) : super(
          SendReceiveHomeState(selectedToken: selectedToken),
        );

  final DioClient client;
  final WalletCubit walletCubit;
  final TokensCubit tokensCubit;

  Future<void> init({String baseUrl = ''}) async {
    try {
      emit(state.loading());
      final operations = await _getOperations(baseUrl);
      await tokensCubit.getTokens();
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
      emit(state.success(operations: operations, selectedToken: selectedToken));
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

      final operations = await _getOperations(baseUrl);

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

  Future<List<OperationModel>> _getOperations(String baseUrl) async {
    if (state.selectedToken.standard?.toLowerCase() == 'fa2') {
      return _getFa2Transfers(baseUrl);
    }

    final activeIndex = walletCubit.state.currentCryptoIndex;
    final walletAddress =
        walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

    late Map<String, dynamic> params;

    if (state.selectedToken.symbol == 'XTZ') {
      params = <String, dynamic>{
        'anyof.sender.target': walletAddress,
        'amount.gt': 0,
      };
    } else {
      params = <String, dynamic>{
        'anyof.sender.target': state.selectedToken.contractAddress,
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
}
