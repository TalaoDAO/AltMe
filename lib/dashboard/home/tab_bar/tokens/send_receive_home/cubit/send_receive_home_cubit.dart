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
    required this.selectedToken,
  }) : super(const SendReceiveHomeState());

  final DioClient client;
  final WalletCubit walletCubit;
  final TokensCubit tokensCubit;
  final TokenModel selectedToken;

  Future<void> init({String baseUrl = ''}) async {
    try {
      emit(state.loading());
      final operations = await _getOperations(baseUrl);
      emit(state.success(operations: operations));
    } catch (e, s) {
      emit(state.error(messageHandler: MessageHandler()));
      getLogger(runtimeType.toString()).e('error in init() e: $e, $s', e, s);
    }
  }

  Future<void> getOperations({String baseUrl = ''}) async {
    try {
      emit(state.loading());

      final operations = await _getOperations(baseUrl);

      emit(state.success(operations: operations));
    } catch (e, s) {
      emit(state.error(messageHandler: MessageHandler()));
      getLogger(runtimeType.toString())
          .e('error in getOperations() e: $e, $s', e, s);
    }
  }

  Future<List<OperationModel>> _getFa2Transfers(String baseUrl) async {
    final activeIndex = walletCubit.state.currentCryptoIndex;
    final walletAddress =
        walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

    final params = <String, dynamic>{
      'anyof.from.to': walletAddress,
      'token.contract.eq': selectedToken.contractAddress,
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
    if (selectedToken.standard?.toLowerCase() == 'fa2') {
      return _getFa2Transfers(baseUrl);
    }

    final activeIndex = walletCubit.state.currentCryptoIndex;
    final walletAddress =
        walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

    late Map<String, dynamic> params;

    if (selectedToken.symbol == 'XTZ') {
      params = <String, dynamic>{
        'anyof.sender.target': walletAddress,
        'amount.gt': 0,
      };
    } else {
      params = <String, dynamic>{
        'anyof.sender.target': selectedToken.contractAddress,
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
