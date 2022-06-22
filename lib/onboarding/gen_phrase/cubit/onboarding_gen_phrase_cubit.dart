import 'package:altme/app/app.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/home/home.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:logging/logging.dart';
import 'package:secure_storage/secure_storage.dart';

part 'onboarding_gen_phrase_cubit.g.dart';

part 'onboarding_gen_phrase_state.dart';

class OnBoardingGenPhraseCubit extends Cubit<OnBoardingGenPhraseState> {
  OnBoardingGenPhraseCubit({
    required this.secureStorageProvider,
    required this.keyGenerator,
    required this.didKitProvider,
    required this.didCubit,
    required this.homeCubit,
  }) : super(OnBoardingGenPhraseState());

  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;

  final log = Logger('altme-wallet/on-boarding/key-generation');

  Future<void> generateSSIAndCryptoKey(List<String> mnemonic) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final mnemonicFormatted = mnemonic.join(' ');
      const didMethod = AltMeStrings.defaultDIDMethod;
      const didMethodName = AltMeStrings.defaultDIDMethodName;

      /// ssi wallet
      await secureStorageProvider.set(
        '${SecureStorageKeys.mnemonic}/${SecureStorageKeys.ssi}',
        mnemonicFormatted,
      );

      final ssiSecretKey =
          await keyGenerator.jwkFromMnemonic(mnemonic: mnemonicFormatted);
      await secureStorageProvider.set(
        '${SecureStorageKeys.secretKey}/${SecureStorageKeys.ssi}',
        ssiSecretKey,
      );

      final ssiWalletAddress =
          await keyGenerator.tz1AddressFromMnemonic(mnemonicFormatted);
      await secureStorageProvider.set(
        '${SecureStorageKeys.walletAddress}/${SecureStorageKeys.ssi}',
        ssiWalletAddress,
      );

      final ssiDid = didKitProvider.keyToDID(didMethod, ssiSecretKey);
      final ssiVerificationMethod =
          await didKitProvider.keyToVerificationMethod(didMethod, ssiSecretKey);

      /// crypto wallet
      await secureStorageProvider.set(
        '${SecureStorageKeys.mnemonic}/${SecureStorageKeys.ssi}',
        mnemonicFormatted,
      );

      final cyptoSecretKey = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonicFormatted,
        accountType: AccountType.crypto,
        cryptoAccountLength: 1,
      );
      await secureStorageProvider.set(
        '${SecureStorageKeys.secretKey}/${SecureStorageKeys.ssi}',
        cyptoSecretKey,
      );

      final cryptoWalletAddress =
          await keyGenerator.tz1AddressFromMnemonic(mnemonicFormatted);
      await secureStorageProvider.set(
        '${SecureStorageKeys.walletAddress}/${SecureStorageKeys.ssi}',
        cryptoWalletAddress,
      );

      final cryptoDid = didKitProvider.keyToDID(didMethod, cyptoSecretKey);
      final cryptoVerificationMethod = await didKitProvider
          .keyToVerificationMethod(didMethod, cyptoSecretKey);

      ///set address to wallet

      ///  set default for ssi wallet
      await didCubit.set(
        did: ssiDid,
        didMethod: didMethod,
        didMethodName: didMethodName,
        verificationMethod: ssiVerificationMethod,
        walletAddress: ssiWalletAddress,
      );

      homeCubit.emitHasWallet();
      emit(state.success());
    } catch (error) {
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

  Future<void> saveMnemonicKey(String mnemonic) async {
    emit(state.loading());
    try {
      log.info('will save mnemonic to secure storage');
      await secureStorageProvider.set(SecureStorageKeys.mnemonic, mnemonic);
      final address = await keyGenerator.tz1AddressFromMnemonic(mnemonic);
      await secureStorageProvider.set(SecureStorageKeys.walletAddress, address);
      log.info('mnemonic saved');
      emit(state.success());
    } catch (error) {
      log.severe('error ocurred setting mnemonic to secure storate', error);

      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString
                .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN,
          ),
        ),
      );
    }
  }
}
