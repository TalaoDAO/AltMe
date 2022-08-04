import 'package:altme/app/shared/constants/urls.dart';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:tezart/tezart.dart';

class ConfirmWithdrawalCubit extends Cubit<void> {
  ConfirmWithdrawalCubit(super.initialState);

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
}
