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

      await didCubit.load(
        did: did,
        didMethod: didMethod,
        didMethodName: AltMeStrings.defaultDIDMethodName,
        verificationMethod: verificationMethod,
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
