import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:secure_storage/secure_storage.dart';

part 'import_account_cubit.g.dart';
part 'import_account_state.dart';

class ImportAccountCubit extends Cubit<ImportAccountState> {
  ImportAccountCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.keyGenerator,
    required this.homeCubit,
    required this.qrCodeScanCubit,
    required this.walletCubit,
    required this.credentialsCubit,
    required this.walletConnectCubit,
  }) : super(const ImportAccountState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final HomeCubit homeCubit;
  final QRCodeScanCubit qrCodeScanCubit;
  final WalletCubit walletCubit;
  final CredentialsCubit credentialsCubit;
  final WalletConnectCubit walletConnectCubit;

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

  void setAccountType(AccountType accountType) {
    emit(state.populating(accountType: accountType));
  }

  Future<void> import({String? accountName}) async {
    final log = getLogger('ImportAccountCubit - import');
    emit(state.loading());
    try {
      /// crypto wallet
      final BlockchainType blockchainType = getBlockchainType(
        state.accountType,
      );

      final String? mnemonicOrKey = await getSecureStorage.get(
        SecureStorageKeys.importAccountStep2Mnemonics,
      );

      if (mnemonicOrKey == null) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'Please provide the mnemonics or private key.',
          },
        );
      }

      await walletCubit.createCryptoWallet(
        accountName: accountName,
        mnemonicOrKey: mnemonicOrKey,
        isImported: true,
        blockchainType: blockchainType,
        isFromOnboarding: false,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
        onComplete:
            ({
              required CryptoAccount cryptoAccount,
              required MessageHandler messageHandler,
            }) async {
              emit(state.success(messageHandler: messageHandler));
            },
      );

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
