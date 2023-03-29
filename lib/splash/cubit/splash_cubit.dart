import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/splash/helper_function/is_wallet_created.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:polygonid/polygonid.dart';
import 'package:secure_storage/secure_storage.dart';

part 'splash_cubit.g.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required this.secureStorageProvider,
    required this.didCubit,
    required this.homeCubit,
    required this.walletCubit,
    required this.client,
    required this.polygonId,
  }) : super(const SplashState()) {
    _getAppVersion();
  }

  final SecureStorageProvider secureStorageProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;
  final WalletCubit walletCubit;
  final DioClient client;
  final PolygonId polygonId;

  StreamSubscription<DownloadInfo>? _subscription;

  Future<void> initialiseApp() async {
    final bool hasWallet = await isWalletCreated(
      secureStorageProvider: secureStorageProvider,
      didCubit: didCubit,
      walletCubit: walletCubit,
      polygonId: polygonId,
    );

    if (hasWallet) {
      await homeCubit.emitHasWallet();
      //emit(state.copyWith(status: SplashStatus.routeToPassCode));
      if (await isGettingMultipleCredentialsNeeded(secureStorageProvider)) {
        final String? preAuthorizedCode = await secureStorageProvider.get(
          SecureStorageKeys.preAuthorizedCode,
        );
        if (preAuthorizedCode != null) {
          unawaited(
            multipleCredentialsTimer(
              preAuthorizedCode,
              client,
              secureStorageProvider,
              walletCubit,
            ),
          );
        }
      }
      unawaited(
        homeCubit.periodicCheckRewardOnTezosBlockchain(),
      );
    } else {
      homeCubit.emitHasNoWallet();
      //emit(state.copyWith(status: SplashStatus.routeToOnboarding));
    }

    final Stream<DownloadInfo> stream =
        await polygonId.initCircuitsDownloadAndGetInfoStream;
    _subscription = stream.listen((DownloadInfo downloadInfo) {
      if (downloadInfo.completed) {
        if (downloadInfo.downloaded == 0 && downloadInfo.contentLength == 0) {
          double counter = 0;
          Timer.periodic(const Duration(milliseconds: 5), (timer) async {
            counter = counter + 0.001;
            emit(state.copyWith(loadedValue: counter));
            if (counter >= 1) {
              timer.cancel();
              unawaited(_subscription?.cancel());
              if (hasWallet) {
                emit(state.copyWith(status: SplashStatus.routeToPassCode));
              } else {
                emit(state.copyWith(status: SplashStatus.routeToOnboarding));
              }
            }
          });
        } else {
          _subscription?.cancel();
          if (hasWallet) {
            emit(state.copyWith(status: SplashStatus.routeToPassCode));
          } else {
            emit(state.copyWith(status: SplashStatus.routeToOnboarding));
          }
        }
      } else {
        final double loadedValue =
            downloadInfo.downloaded / downloadInfo.contentLength;
        emit(state.copyWith(loadedValue: loadedValue));
      }
    });
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
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

  void disableWhatsNewPopUp() {
    emit(
      state.copyWith(
        isNewVersion: false,
        status: SplashStatus.idle,
      ),
    );
  }
}
