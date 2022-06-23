import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:altme/wallet/wallet.dart';
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
    required this.walletCubit,
  }) : super(OnBoardingGenPhraseState());

  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;
  final WalletCubit walletCubit;

  final log = Logger('altme-wallet/on-boarding/key-generation');

  Future<void> generateSSIAndCryptoKey(List<String> mnemonic) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final mnemonicFormatted = mnemonic.join(' ');

      /// ssi wallet
      await secureStorageProvider.set(
        '${SecureStorageKeys.menomicss}/0',
        mnemonicFormatted,
      );

      final ssiSecretKey =
          await keyGenerator.jwkFromMnemonic(mnemonic: mnemonicFormatted);
      await secureStorageProvider.set(
        '${SecureStorageKeys.secretKeyy}/0',
        ssiSecretKey,
      );

      const didMethod = AltMeStrings.defaultDIDMethod;
      final did = didKitProvider.keyToDID(didMethod, ssiSecretKey);
      const didMethodName = AltMeStrings.defaultDIDMethodName;
      final verificationMethod =
          await didKitProvider.keyToVerificationMethod(didMethod, ssiSecretKey);

      await didCubit.set(
        did: did,
        didMethod: didMethod,
        didMethodName: didMethodName,
        verificationMethod: verificationMethod,
      );

      final ssiWalletAddress =
          await keyGenerator.tz1AddressFromMnemonic(mnemonicFormatted);
      await secureStorageProvider.set(
        '${SecureStorageKeys.walletAddresss}/0',
        ssiWalletAddress,
      );

      await walletCubit.insertWalletAccount(
        WalletAccount(
          mnemonics: mnemonicFormatted,
          secretKey: ssiSecretKey,
          walletAddress: ssiWalletAddress,
        ),
      );

      /// crypto wallet
      await secureStorageProvider.set(
        '${SecureStorageKeys.menomicss}/1',
        mnemonicFormatted,
      );

      final cryptoSecretKey = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonicFormatted,
        accountType: AccountType.crypto,
        cryptoAccountLength: 1,
      );
      await secureStorageProvider.set(
        '${SecureStorageKeys.secretKeyy}/1',
        cryptoSecretKey,
      );

      final cryptoWalletAddress =
          await keyGenerator.tz1AddressFromMnemonic(mnemonicFormatted);
      await secureStorageProvider.set(
        '${SecureStorageKeys.walletAddresss}/1',
        cryptoWalletAddress,
      );

      await walletCubit.insertWalletAccount(
        WalletAccount(
          mnemonics: mnemonicFormatted,
          secretKey: cryptoSecretKey,
          walletAddress: cryptoWalletAddress,
        ),
      );

      //setting ssi index
      await walletCubit.setCurrentWalletAccount(0);

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

  Future<void> saveMnemonicKey({
    required String mnemonic,
    required int index,
  }) async {
    emit(state.loading());
    try {
      log.info('will save mnemonic to secure storage');
      await secureStorageProvider.set(
        '${SecureStorageKeys.menomicss}/$index',
        mnemonic,
      );
      final walletAddress = await keyGenerator.tz1AddressFromMnemonic(mnemonic);
      await secureStorageProvider.set(
        '${SecureStorageKeys.walletAddresss}/$index',
        walletAddress,
      );
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
