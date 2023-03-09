import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/flavor/flavor.dart';
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
    required this.flavorCubit,
  }) : super(OnBoardingVerifyPhraseState());

  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;
  final WalletCubit walletCubit;
  final FlavorCubit flavorCubit;
  final SplashCubit splashCubit;

  final log = getLogger('OnBoardingVerifyPhraseCubit');

  void orderMnemonics() {
    emit(state.loading());
    //create list
    final oldState = List<MnemonicState>.from(state.mnemonicStates);
    for (var i = 1; i <= 12; i++) {
      oldState.add(MnemonicState(order: i));
    }
    if (flavorCubit.state != FlavorMode.development) {
      oldState.shuffle();
    }

    emit(state.copyWith(mnemonicStates: oldState, status: AppStatus.idle));
  }

  List<String> tempMnemonics = [];

  Future<void> verify({
    required List<String> mnemonic,
    required int index,
  }) async {
    final mnemonicState = state.mnemonicStates[index];
    final int clickCount = tempMnemonics.length;

    if (mnemonicState.order <= clickCount) return;

    if (mnemonicState.mnemonicStatus != MnemonicStatus.wrongSelection) {
      for (final mnemonicState in state.mnemonicStates) {
        if (mnemonicState.mnemonicStatus == MnemonicStatus.wrongSelection) {
          return;
        }
      }
    }

    final updatedList = List<MnemonicState>.from(state.mnemonicStates);
    if (mnemonicState.order == clickCount + 1) {
      tempMnemonics.add(mnemonic[mnemonicState.order - 1]);
      updatedList[index] =
          mnemonicState.copyWith(mnemonicStatus: MnemonicStatus.selected);
    } else {
      if (mnemonicState.mnemonicStatus == MnemonicStatus.unselected) {
        updatedList[index] = mnemonicState.copyWith(
          mnemonicStatus: MnemonicStatus.wrongSelection,
        );
      } else {
        updatedList[index] =
            mnemonicState.copyWith(mnemonicStatus: MnemonicStatus.unselected);
      }
    }

    emit(state.copyWith(status: AppStatus.idle, mnemonicStates: updatedList));

    if (tempMnemonics.length >= 6) {
      if (mnemonic[0] == tempMnemonics[0] &&
          mnemonic[1] == tempMnemonics[1] &&
          mnemonic[2] == tempMnemonics[2] &&
          mnemonic[3] == tempMnemonics[3] &&
          mnemonic[4] == tempMnemonics[4] &&
          mnemonic[5] == tempMnemonics[5]) {
        emit(state.copyWith(isVerified: true, status: AppStatus.idle));
      } else {
        emit(state.copyWith(isVerified: false, status: AppStatus.idle));
      }
    }
  }

  Future<void> generateSSIAndCryptoAccount({
    required List<String> mnemonic,
    required bool isFromOnboarding,
  }) async {
    emit(state.loading());
    try {
      if (isFromOnboarding) {
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
      }
      await secureStorageProvider.set(
        SecureStorageKeys.hasVerifiedMnemonics,
        'yes',
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
