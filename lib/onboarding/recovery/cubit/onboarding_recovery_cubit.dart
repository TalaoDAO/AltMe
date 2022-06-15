import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:tezart/tezart.dart';

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
  }) : super(const OnBoardingRecoveryState());

  final DIDKitProvider didKitProvider;
  final CryptocurrencyKeys cryptoKeys;
  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final HomeCubit homeCubit;
  final DIDCubit didCubit;

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
      await secureStorageProvider.set(SecureStorageKeys.mnemonic, mnemonic);
      final address = Keystore.fromMnemonic(mnemonic).address;
      await secureStorageProvider.set(SecureStorageKeys.walletAddress, address);
      final key = await keyGenerator.privateKey(mnemonic);
      await secureStorageProvider.set(SecureStorageKeys.key, key);

      const didMethod = AltMeStrings.defaultDIDMethod;
      final did = didKitProvider.keyToDID(didMethod, key);
      final verificationMethod =
          await didKitProvider.keyToVerificationMethod(didMethod, key);

      await didCubit.set(
        did: did,
        didMethod: didMethod,
        didMethodName: AltMeStrings.defaultDIDMethodName,
        verificationMethod: verificationMethod,
      );

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
