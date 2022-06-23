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

      final ssiKey = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonicFormatted,
        accountType: AccountType.ssi,
      );
      await secureStorageProvider.set('${SecureStorageKeys.key}/0', ssiKey);

      const didMethod = AltMeStrings.defaultDIDMethod;
      final did = didKitProvider.keyToDID(didMethod, ssiKey);
      const didMethodName = AltMeStrings.defaultDIDMethodName;
      final verificationMethod =
          await didKitProvider.keyToVerificationMethod(didMethod, ssiKey);

      await didCubit.set(
        did: did,
        didMethod: didMethod,
        didMethodName: didMethodName,
        verificationMethod: verificationMethod,
      );

      final ssiSecretKey = await keyGenerator.secretKeyFromMnemonic(
        mnemonic: mnemonicFormatted,
        accountType: AccountType.ssi,
      );
      await secureStorageProvider.set(
          '${SecureStorageKeys.secretKey}/0', ssiSecretKey);

      final ssiWalletAddress = await keyGenerator.tz1AddressFromSecretKey(
        secretKey: ssiSecretKey,
      );
      await secureStorageProvider.set(
        '${SecureStorageKeys.walletAddresss}/0',
        ssiWalletAddress,
      );

      await walletCubit.insertWalletAccount(
        WalletAccount(
          mnemonics: mnemonicFormatted,
          key: ssiKey,
          walletAddress: ssiWalletAddress,
          secretKey: ssiSecretKey,
          accountType: AccountType.ssi,
        ),
      );

      /// crypto wallet
      await secureStorageProvider.set(
        '${SecureStorageKeys.menomicss}/1',
        mnemonicFormatted,
      );

      final cryptoKey = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonicFormatted,
        accountType: AccountType.crypto,
        cryptoAccountLength: 1,
      );
      await secureStorageProvider.set('${SecureStorageKeys.key}/1', cryptoKey);

      final cryptoSecretKey = await keyGenerator.secretKeyFromMnemonic(
        mnemonic: mnemonicFormatted,
        accountType: AccountType.crypto,
        cryptoAccountLength: 1,
      );
      await secureStorageProvider.set(
        '${SecureStorageKeys.secretKey}/1',
        cryptoSecretKey,
      );

      final cryptoWalletAddress = await keyGenerator.tz1AddressFromSecretKey(
        secretKey: cryptoSecretKey,
      );
      await secureStorageProvider.set(
        '${SecureStorageKeys.walletAddresss}/1',
        cryptoWalletAddress,
      );

      await walletCubit.insertWalletAccount(
        WalletAccount(
          mnemonics: mnemonicFormatted,
          key: cryptoKey,
          walletAddress: cryptoWalletAddress,
          secretKey: cryptoSecretKey,
          accountType: AccountType.crypto,
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
}
