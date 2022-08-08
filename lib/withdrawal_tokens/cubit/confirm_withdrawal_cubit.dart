import 'package:altme/app/shared/constants/urls.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:tezart/tezart.dart';

part 'confirm_withdrawal_cubit.g.dart';

part 'confirm_withdrawal_state.dart';

class ConfirmWithdrawalCubit extends Cubit<ConfirmWithdrawalState> {
  ConfirmWithdrawalCubit({
    required ConfirmWithdrawalState initialState,
    required this.selectedAccountSecretKey,
  }) : super(initialState);

  final String selectedAccountSecretKey;

  final logger = Logger('altme-wallet/Withdrawal/ConfirmWithdrawal');

  void setWithdrawalAddress({required String withdrawalAddress}) {
    emit(state.copyWith(withdrawalAddress: withdrawalAddress));
  }

  void setNetworkFee({required NetworkFeeModel networkFee}) {
    emit(state.copyWith(networkFee: networkFee));
  }

  bool canConfirmTheWithdrawal() {
    // TODO(Taleb): update minimum withdrawal later for every token
    return state.amount > 0.00001 &&
        state.withdrawalAddress.trim().isNotEmpty &&
        // TODO(Taleb): remove the last condition when added support to send other tokens like Tezos
        state.selectedToken.symbol == 'XTZ';
  }

  Future<bool> withdrawTezos() async {
    try {
      final sourceKeystore = Keystore.fromSecretKey(selectedAccountSecretKey);

      final client = TezartClient(Urls.rpc);

      final amount = int.parse(
        state.amount.toStringAsFixed(6).replaceAll(',', '').replaceAll('.', ''),
      );
      final customFee = int.parse(
        state.networkFee.fee
            .toStringAsFixed(6)
            .replaceAll('.', '')
            .replaceAll(',', ''),
      );

      await Future<void>.delayed(const Duration(seconds: 1));

      // final operationsList = await client.transferOperation(
      //   source: sourceKeystore,
      //   destination: state.withdrawalAddress,
      //   amount: amount,
      //   customFee: customFee,
      // );
      // logger.info(
      //   'before execute: withdrawal from secretKey: ${sourceKeystore.secretKey} '
      //   ', publicKey: ${sourceKeystore.publicKey} '
      //   'amount: $amount '
      //   'networkFee: $customFee '
      //   'address: ${sourceKeystore.address} =>To address: ${state.withdrawalAddress}',
      // );
      // await operationsList.executeAndMonitor();
      // logger.info('after withdrawal execute');
      return true;
    } catch (e, s) {
      logger.severe('error after withdrawal execute: e: $e, stack: $s', e, s);
      return false;
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
