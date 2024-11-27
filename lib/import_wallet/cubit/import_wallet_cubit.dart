import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';

import 'package:secure_storage/secure_storage.dart';

part 'import_wallet_cubit.g.dart';
part 'import_wallet_state.dart';

class ImportWalletCubit extends Cubit<ImportWalletState> {
  ImportWalletCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.keyGenerator,
    required this.homeCubit,
    required this.qrCodeScanCubit,
    required this.splashCubit,
    required this.walletCubit,
    required this.credentialsCubit,
    required this.walletConnectCubit,
    required this.activityLogManager,
  }) : super(const ImportWalletState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final HomeCubit homeCubit;
  final QRCodeScanCubit qrCodeScanCubit;
  final WalletCubit walletCubit;
  final CredentialsCubit credentialsCubit;
  final SplashCubit splashCubit;
  final WalletConnectCubit walletConnectCubit;
  final ActivityLogManager activityLogManager;

  void isMnemonicsOrKeyValid(String value) {
    //different type of tezos private keys start with 'edsk' ,
    //'pspsk' and 'p2sk;
    final bool isSecretKey = isValidPrivateKey(value);

    emit(
      state.populating(
        isTextFieldEdited: value.isNotEmpty,
        isMnemonicOrKeyValid:
            (bip39.validateMnemonic(value) || isSecretKey) && value.isNotEmpty,
      ),
    );
  }

  Future<void> import({
    required String mnemonicOrKey,
    required RestoreType? restoreType,
    String? accountName,
  }) async {
    final log = getLogger('ImportWalletCubit - import');
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final isFromOnboarding = restoreType != null;

    try {
      log.i('isFromOnboarding: $isFromOnboarding');
      if (isFromOnboarding) {
        /// ssi creation

        late String mnemonic;
        final isSecretKey = mnemonicOrKey.startsWith('edsk') ||
            mnemonicOrKey.startsWith('spsk') ||
            mnemonicOrKey.startsWith('p2sk') ||
            mnemonicOrKey.startsWith('0x');

        if (isSecretKey) {
          if (!Parameters.walletHandlesCrypto) {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
          mnemonic = bip39.generateMnemonic();
        } else {
          mnemonic = mnemonicOrKey;
        }

        await secureStorageProvider.set(
          SecureStorageKeys.ssiMnemonic,
          mnemonic,
        );
        final ssiKey = await keyGenerator.jwkFromMnemonic(
          mnemonic: mnemonic,
          accountType: AccountType.ssi,
        );
        await secureStorageProvider.set(SecureStorageKeys.ssiKey, ssiKey);
        await activityLogManager.saveLog(LogData(type: LogType.walletInit));
      }

      /// crypto wallet with unknown blockchain type
      await walletCubit.createCryptoWallet(
        accountName: accountName,
        mnemonicOrKey: mnemonicOrKey,
        isImported: !isFromOnboarding,
        isFromOnboarding: isFromOnboarding,
        blockchainType: null,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
        onComplete: ({
          required CryptoAccount cryptoAccount,
          required MessageHandler messageHandler,
        }) async {
          emit(
            state.success(
              messageHandler: messageHandler,
            ),
          );
        },
      );

      if (isFromOnboarding) {
        await secureStorageProvider.set(
          SecureStorageKeys.hasVerifiedMnemonics,
          'yes',
        );
      }

      await activityLogManager.saveLog(LogData(type: LogType.importKey));

      await homeCubit.emitHasWallet();

      emit(state.success());
    } catch (e, s) {
      log.e(
        'something went wrong when generating a key',
        error: e,
        stackTrace: s,
      );
      emit(
        state.error(
          messageHandler: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY,
          ),
        ),
      );
    }
  }
}
