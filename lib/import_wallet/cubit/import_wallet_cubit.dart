import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:logging/logging.dart';
import 'package:secure_storage/secure_storage.dart';

part 'import_wallet_cubit.g.dart';
part 'import_wallet_state.dart';

class ImportWalletCubit extends Cubit<ImportWalletState> {
  ImportWalletCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.keyGenerator,
    required this.homeCubit,
    required this.didCubit,
    required this.walletCubit,
  }) : super(const ImportWalletState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final HomeCubit homeCubit;
  final DIDCubit didCubit;
  final WalletCubit walletCubit;

  final log = Logger('altme-wallet/on-boarding/key-recovery');

  void isMnemonicsOrKeyValid(String value) {
    //different type of tezos private keys start with 'edsk' , 'pspsk' and 'p2sk;
    final bool isSecretKey = value.startsWith('edsk') ||
        value.startsWith('spsk') ||
        value.startsWith('p2sk');
    // TODO(all): Need more validation for Tezos private key that s
    // tarted with edsk or edsek

    emit(
      state.populating(
        isTextFieldEdited: value.isNotEmpty,
        isMnemonicOrKeyValid:
            (bip39.validateMnemonic(value) || isSecretKey) && value.isNotEmpty,
      ),
    );
  }

  Future<void> saveMnemonicOrKey({
    required String mnemonicOrKey,
    required bool isFromOnboarding,
    String? accountName,
  }) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));

    try {
      if (isFromOnboarding) {
        /// ssi creation

        late String mnemonic;
        final isSecretKey = mnemonicOrKey.startsWith('edsk') ||
            mnemonicOrKey.startsWith('spsk') ||
            mnemonicOrKey.startsWith('p2sk');

        if (isSecretKey) {
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

        const didMethod = AltMeStrings.defaultDIDMethod;
        final did = didKitProvider.keyToDID(didMethod, ssiKey);
        final verificationMethod =
            await didKitProvider.keyToVerificationMethod(didMethod, ssiKey);

        await didCubit.set(
          did: did,
          didMethod: didMethod,
          didMethodName: AltMeStrings.defaultDIDMethodName,
          verificationMethod: verificationMethod,
        );
      }

      /// crypto wallet
      await walletCubit.createCryptoWallet(
        accountName: accountName,
        mnemonicOrKey: mnemonicOrKey,
      );
      await walletCubit.setCurrentWalletAccount(0);

      homeCubit.emitHasWallet();
      emit(state.success());
    } catch (error, stack) {
      log.info('error: $error,stack: $stack');
      log.severe('something went wrong when generating a key', error);
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY,
          ),
        ),
      );
    }
  }
}
