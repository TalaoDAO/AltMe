import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
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
    required this.splashCubit,
  }) : super(const OnBoardingGenPhraseState());

  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;
  final WalletCubit walletCubit;
  final SplashCubit splashCubit;

  final log = getLogger('OnBoardingGenPhraseCubit');

  Future<void> generateSSIAndCryptoAccount(List<String> mnemonic) async {
    emit(state.loading());
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
      await secureStorageProvider.set(
        SecureStorageKeys.hasVerifiedMnemonics,
        'no',
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
