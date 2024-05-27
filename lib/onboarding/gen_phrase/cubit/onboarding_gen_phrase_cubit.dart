import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';

part 'onboarding_gen_phrase_cubit.g.dart';

part 'onboarding_gen_phrase_state.dart';

class OnBoardingGenPhraseCubit extends Cubit<OnBoardingGenPhraseState> {
  OnBoardingGenPhraseCubit({
    required this.keyGenerator,
    required this.didKitProvider,
    required this.homeCubit,
    required this.walletCubit,
    required this.splashCubit,
    required this.altmeChatSupportCubit,
    required this.profileCubit,
  }) : super(const OnBoardingGenPhraseState());

  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;

  final HomeCubit homeCubit;
  final WalletCubit walletCubit;
  final SplashCubit splashCubit;
  final AltmeChatSupportCubit altmeChatSupportCubit;
  final ProfileCubit profileCubit;

  final log = getLogger('OnBoardingGenPhraseCubit');

  Future<void> generateSSIAndCryptoAccount(List<String> mnemonic) async {
    emit(state.loading());
    try {
      await generateAccount(
        mnemonic: mnemonic,
        keyGenerator: keyGenerator,
        didKitProvider: didKitProvider,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        profileCubit: profileCubit,
      );
      await profileCubit.secureStorageProvider.set(
        SecureStorageKeys.hasVerifiedMnemonics,
        'no',
      );
      emit(state.success());
    } catch (e, s) {
      log.e(
        'something went wrong when generating a key',
        error: e,
        stackTrace: s,
      );
      emit(
        state.error(
          messageHandler: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY,
          ),
        ),
      );
    }
  }
}
