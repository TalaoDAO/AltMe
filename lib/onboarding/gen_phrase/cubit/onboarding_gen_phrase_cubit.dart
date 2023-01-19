import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';

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

  final log = getLogger('OnBoardingGenPhraseCubit');

  Future<void> switchTick() async {
    emit(state.copyWith(isTicked: !state.isTicked));
  }

  Future<void> generateSSIAndCryptoAccount(List<String> mnemonic) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final mnemonicFormatted = mnemonic.join(' ');

      /// ssi wallet
      await secureStorageProvider.set(
        SecureStorageKeys.ssiMnemonic,
        mnemonicFormatted,
      );

      final ssiKey = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonicFormatted,
        accountType: AccountType.ssi,
      );
      await secureStorageProvider.set(SecureStorageKeys.ssiKey, ssiKey);

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

      /// crypto wallet
      await walletCubit.createCryptoWallet(
        mnemonicOrKey: mnemonicFormatted,
        isImported: false,
        isFromOnboarding: true,
      );

      await homeCubit.emitHasWallet();
      emit(state.success());
    } catch (error) {
      log.e('something went wrong when generating a key', error);
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
