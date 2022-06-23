import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

part 'onboarding_recovery_cubit.g.dart';

part 'onboarding_recovery_state.dart';

class OnBoardingRecoveryCubit extends Cubit<OnBoardingRecoveryState> {
  OnBoardingRecoveryCubit({
    required this.didKitProvider,
    required this.cryptoKeys,
    required this.secureStorageProvider,
    required this.keyGenerator,
    required this.homeCubit,
    required this.didCubit,
    required this.walletCubit,
  }) : super(const OnBoardingRecoveryState());

  final DIDKitProvider didKitProvider;
  final CryptocurrencyKeys cryptoKeys;
  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final HomeCubit homeCubit;
  final DIDCubit didCubit;
  final WalletCubit walletCubit;

  void isMnemonicsValid(String value) {
    emit(
      state.populating(
        isTextFieldEdited: value.isNotEmpty,
        isMnemonicValid: bip39.validateMnemonic(value) && value.isNotEmpty,
      ),
    );
  }

  Future<void> saveMnemonic(String mnemonic) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      // TODO(bibash): change recovery indexes based on ssi or cypto
      //for now I am considering crypto
      await secureStorageProvider.set(
        '${SecureStorageKeys.menomicss}/0',
        mnemonic,
      );

      final walletAddress = await keyGenerator.tz1AddressFromMnemonic(
        mnemonic: mnemonic,
        accountType: AccountType.ssi,
      );
      await secureStorageProvider.set(
          '${SecureStorageKeys.walletAddresss}/0', walletAddress);

      final key = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonic,
        accountType: AccountType.ssi,
      );
      await secureStorageProvider.set('${SecureStorageKeys.key}/0', key);

      final secretKey = await keyGenerator.secretKeyFromMnemonic(
        mnemonic: mnemonic,
        accountType: AccountType.ssi,
      );
      await secureStorageProvider.set(
          '${SecureStorageKeys.secretKey}/0', secretKey);

      const didMethod = AltMeStrings.defaultDIDMethod;
      final did = didKitProvider.keyToDID(didMethod, key);
      final verificationMethod =
          await didKitProvider.keyToVerificationMethod(didMethod, key);

      await didCubit.load(
        did: did,
        didMethod: didMethod,
        didMethodName: AltMeStrings.defaultDIDMethodName,
        verificationMethod: verificationMethod,
      );

      await walletCubit.insertWalletAccount(
        WalletAccount(
          mnemonics: mnemonic,
          key: key,
          secretKey: secretKey,
          walletAddress: walletAddress,
          accountType: AccountType.ssi,
        ),
      );

      //setting ssi index
      await walletCubit.setCurrentWalletAccount(0);

      homeCubit.emitHasWallet();

      emit(state.success());
    } catch (error) {
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
