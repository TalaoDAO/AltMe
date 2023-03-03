import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/onboarding/helper_function/helper_function.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';

import 'package:secure_storage/secure_storage.dart';

part 'onboarding_verify_phrase_cubit.g.dart';

part 'onboarding_verify_phrase_state.dart';

class OnBoardingVerifyPhraseCubit extends Cubit<OnBoardingVerifyPhraseState> {
  OnBoardingVerifyPhraseCubit({
    required this.secureStorageProvider,
    required this.keyGenerator,
    required this.didKitProvider,
    required this.didCubit,
    required this.homeCubit,
    required this.walletCubit,
    required this.splashCubit,
  }) : super(const OnBoardingVerifyPhraseState());

  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;
  final WalletCubit walletCubit;
  final SplashCubit splashCubit;

  final log = getLogger('OnBoardingVerifyPhraseCubit');

  Future<void> verify({
    required List<String> mnemonic,
    required List<String> lastFourMnemonics,
  }) async {
    if (mnemonic[8] == lastFourMnemonics[0] &&
        mnemonic[9] == lastFourMnemonics[1] &&
        mnemonic[10] == lastFourMnemonics[2] &&
        mnemonic[11] == lastFourMnemonics[3]) {
      emit(state.copyWith(isVerified: true));
    } else {
      emit(state.copyWith(isVerified: false));
    }
  }

  Future<void> generateSSIAndCryptoAccount(List<String> mnemonic) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      await generateAccount(
        mnemonic: mnemonic,
        secureStorageProvider: secureStorageProvider,
        keyGenerator: keyGenerator,
        didKitProvider: didKitProvider,
        didCubit: didCubit,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
      );
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
