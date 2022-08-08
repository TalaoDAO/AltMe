import 'package:altme/app/shared/constants/urls.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:tezart/tezart.dart';

part 'confirm_withdrawal_cubit.g.dart';

part 'confirm_withdrawal_state.dart';

class ConfirmWithdrawalCubit extends Cubit<ConfirmWithdrawalState> {
  ConfirmWithdrawalCubit(ConfirmWithdrawalState initialState)
      : super(initialState);

  final logger = Logger('altme-wallet/Withdrawal/ConfirmWithdrawal');

  Future<void> withdrawTezos({
    required String secretKey,
    required String toAddress,
    required int amount,
  }) async {
    try {
      final sourceKeystore = Keystore.fromSecretKey(secretKey);

      final client = TezartClient(Urls.rpc);

      final operationsList = await client.transferOperation(
        source: sourceKeystore,
        destination: toAddress,
        amount: amount,
      );
      logger.info(
        'before execute: withdrawal from secretKey: ${sourceKeystore.secretKey} '
        ', publicKey: ${sourceKeystore.publicKey} '
        'address: ${sourceKeystore.address} =>To address: $toAddress',
      );
      await operationsList.executeAndMonitor();
      logger.info('after withdrawal execute');
    } catch (e, s) {
      logger.severe('error after withdrawal execute: e: $e, stack: $s', e, s);
    }
  }

  Future<List<Operation>> getContractOperation({
    required String tokenContractAddress,
    required String secretKey,
  }) async {
    try {
      final sourceKeystore = Keystore.fromSecretKey(secretKey);

      final rpcInterface = RpcInterface(Urls.rpc);
      final contract = Contract(
          contractAddress: tokenContractAddress, rpcInterface: rpcInterface);

      final operationsList = await contract.callOperation(
        source: sourceKeystore,
        amount: 1,
      );
      await operationsList.executeAndMonitor();
      logger.info('operation execute');
      return operationsList.operations;
    } catch (e, s) {
      logger.severe('error e: $e, stack: $s', e, s);
      return [];
    }
  }
}
