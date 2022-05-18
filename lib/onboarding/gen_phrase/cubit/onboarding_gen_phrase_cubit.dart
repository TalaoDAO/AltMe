import 'package:altme/app/app.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  }) : super(OnBoardingGenPhraseState());

  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;
  final DIDCubit didCubit;

  final log = Logger('altme-wallet/on-boarding/key-generation');

  Future<void> generateKey(BuildContext context, List<String> mnemonic) async {
    try {
      emit(state.loading());
      final mnemonicFormatted = mnemonic.join(' ');
      await secureStorageProvider.set(
        SecureStorageKeys.mnemonic,
        mnemonicFormatted,
      );
      final key = await keyGenerator.privateKey(mnemonicFormatted);
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

      emit(state.success());
    } catch (error) {
      log.severe('something went wrong when generating a key', error);
      print(error);
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
      await secureStorageProvider.set('mnemonic', mnemonic);
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
