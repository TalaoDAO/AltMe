import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:altme/onboarding/helper_function/helper_function.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'onboarding_verify_phrase_cubit.g.dart';
part 'onboarding_verify_phrase_state.dart';

class OnBoardingVerifyPhraseCubit extends Cubit<OnBoardingVerifyPhraseState> {
  OnBoardingVerifyPhraseCubit({
    required this.keyGenerator,
    required this.didKitProvider,
    required this.homeCubit,
    required this.qrCodeScanCubit,
    required this.profileCubit,
    required this.splashCubit,
    required this.flavorCubit,
    required this.altmeChatSupportCubit,
    required this.matrixNotificationCubit,
    required this.activityLogManager,
    required this.walletCubit,
    required this.walletConnectCubit,
    required this.credentialsCubit,
  }) : super(OnBoardingVerifyPhraseState());

  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;

  final HomeCubit homeCubit;
  final QRCodeScanCubit qrCodeScanCubit;
  final FlavorCubit flavorCubit;
  final SplashCubit splashCubit;
  final AltmeChatSupportCubit altmeChatSupportCubit;
  final MatrixNotificationCubit matrixNotificationCubit;
  final ProfileCubit profileCubit;
  final WalletCubit walletCubit;
  final CredentialsCubit credentialsCubit;
  final WalletConnectCubit walletConnectCubit;
  final ActivityLogManager activityLogManager;

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

  List<int> selectionorder = [];

  Future<void> verify({
    required List<String> mnemonic,
    required int index,
  }) async {
    final mnemonicState = state.mnemonicStates[index];

    final updatedList = List<MnemonicState>.from(state.mnemonicStates);

    switch (mnemonicState.mnemonicStatus) {
      case MnemonicStatus.unselected:
        // new selection
        updatedList[index] = mnemonicState.copyWith(
          mnemonicStatus: MnemonicStatus.selected,
          userSelectedOrder: selectionorder.length + 1,
        );
        selectionorder.add(mnemonicState.order);
      case MnemonicStatus.selected:
        // remove selection
        final order = mnemonicState.order;
        updatedList[index] = mnemonicState.copyWith(
          mnemonicStatus: MnemonicStatus.unselected,
          userSelectedOrder: null,
        );

        if (selectionorder.last != order) {
          // if first or middle elements are removed then we need to reorder
          // the selection

          selectionorder.remove(order);

          var count = 0;

          for (int i = 0; i < updatedList.length; i++) {
            if (index == i) continue; // already operated in this index

            final element = updatedList[i];
            if (selectionorder.contains(element.order)) {
              // reorder remaining list
              updatedList[i] = updatedList[i].copyWith(
                mnemonicStatus: MnemonicStatus.selected,
                userSelectedOrder: count + 1,
              );
              count++;
            }
          }
        } else {
          selectionorder.remove(order);
        }
    }

    emit(
      state.copyWith(
        status: AppStatus.idle,
        mnemonicStates: updatedList,
        isVerified: selectionorder.length == 12,
      ),
    );
  }

  Future<void> generateSSIAndCryptoAccount({
    required List<String> mnemonic,
    required bool isFromOnboarding,
  }) async {
    emit(state.loading());

    try {
      if (selectionorder.length == 12) {
        var verified = true;
        final updatedList = List<MnemonicState>.from(state.mnemonicStates);
        for (var i = 0; i < 12; i++) {
          if (updatedList[i].order == updatedList[i].userSelectedOrder) {
            verified = true;
          } else {
            verified = false;
            break;
          }
        }

        if (!verified) {
          selectionorder = [];
          for (var i = 0; i < 12; i++) {
            updatedList[i] = updatedList[i].copyWith(
              mnemonicStatus: MnemonicStatus.unselected,
              userSelectedOrder: null,
            );
          }

          emit(
            state.copyWith(
              status: AppStatus.error,
              mnemonicStates: updatedList,
              message: StateMessage.error(
                showDialog: true,
                messageHandler: ResponseMessage(
                  message: ResponseString
                      .RESPONSE_STRING_recoveryPhraseIncorrectErrorMessage,
                ),
              ),
            ),
          );
          return;
        }
      }
      if (isFromOnboarding) {
        await generateAccount(
          mnemonic: mnemonic,
          keyGenerator: keyGenerator,
          didKitProvider: didKitProvider,
          homeCubit: homeCubit,
          splashCubit: splashCubit,
          altmeChatSupportCubit: altmeChatSupportCubit,
          matrixNotificationCubit: matrixNotificationCubit,
          activityLogManager: activityLogManager,
          qrCodeScanCubit: qrCodeScanCubit,
          credentialsCubit: credentialsCubit,
          walletCubit: walletCubit,
          profileCubit: profileCubit,
          walletConnectCubit: walletConnectCubit,
        );
      }
      await profileCubit.secureStorageProvider.set(
        SecureStorageKeys.hasVerifiedMnemonics,
        'yes',
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
