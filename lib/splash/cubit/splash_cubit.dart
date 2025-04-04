import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/matrix_notification/cubit/matrix_notification_cubit.dart';
import 'package:altme/splash/helper_function/is_wallet_created.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:secure_storage/secure_storage.dart';

part 'splash_cubit.g.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required this.secureStorageProvider,
    required this.homeCubit,
    required this.walletCubit,
    required this.credentialsCubit,
    required this.qrCodeScanCubit,
    required this.profileCubit,
    required this.altmeChatSupportCubit,
    required this.matrixNotificationCubit,
    required this.walletConnectCubit,
    required this.client,
    this.packageInfo,
  }) : super(const SplashState()) {
    _getAppVersion(packageInfo);
  }

  final SecureStorageProvider secureStorageProvider;
  final HomeCubit homeCubit;
  final WalletCubit walletCubit;
  final CredentialsCubit credentialsCubit;
  final QRCodeScanCubit qrCodeScanCubit;
  final WalletConnectCubit walletConnectCubit;
  final AltmeChatSupportCubit altmeChatSupportCubit;
  final MatrixNotificationCubit matrixNotificationCubit;
  final ProfileCubit profileCubit;
  final DioClient client;
  final PackageInfo? packageInfo;

  Future<void> initialiseApp() async {
    double counter = 0;

    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      counter = counter + 0.5;
      emit(state.copyWith(loadedValue: counter / 5));
      if (counter > 5) {
        timer.cancel();

        final bool hasWallet = await isWalletCreated(
          secureStorageProvider: secureStorageProvider,
          qrCodeScanCubit: qrCodeScanCubit,
          credentialsCubit: credentialsCubit,
          walletCubit: walletCubit,
          walletConnectCubit: walletConnectCubit,
        );

        if (hasWallet) {
          await homeCubit.emitHasWallet();

          final helpCenterOptions =
              profileCubit.state.model.profileSetting.helpCenterOptions;

          if (helpCenterOptions.customChatSupport &&
              helpCenterOptions.customChatSupportName != null) {
            await altmeChatSupportCubit.init();
          }

          if (helpCenterOptions.customNotification != null &&
              helpCenterOptions.customNotification! &&
              helpCenterOptions.customNotificationRoom != null) {
            await matrixNotificationCubit.init();
          }

          emit(state.copyWith(status: SplashStatus.routeToPassCode));
        } else {
          homeCubit.emitHasNoWallet();
          emit(state.copyWith(status: SplashStatus.routeToOnboarding));
        }
      }
    });
  }

  Future<void> _getAppVersion(PackageInfo? packageInformation) async {
    late PackageInfo packageInfo;
    if (packageInformation == null) {
      packageInfo = await PackageInfo.fromPlatform();
    } else {
      packageInfo = packageInformation;
    }

    final String? savedVersion = await secureStorageProvider.get(
      SecureStorageKeys.version,
    );

    final String? savedBuildNumber = await secureStorageProvider.get(
      SecureStorageKeys.buildNumber,
    );

    var isNewVersion = false;

    if (savedVersion != null && savedBuildNumber != null) {
      if (savedVersion != packageInfo.version ||
          savedBuildNumber != packageInfo.buildNumber) {
        isNewVersion = true;
      }
    }

    await secureStorageProvider.set(
      SecureStorageKeys.version,
      packageInfo.version,
    );

    await secureStorageProvider.set(
      SecureStorageKeys.buildNumber,
      packageInfo.buildNumber,
    );

    emit(
      state.copyWith(
        versionNumber: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        isNewVersion: isNewVersion,
        status: SplashStatus.idle,
      ),
    );
  }

  void authenticated() {
    emit(state.copyWith(status: SplashStatus.authenticated));
  }
}
