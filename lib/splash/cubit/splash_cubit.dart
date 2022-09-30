import 'dart:async';

import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/did/cubit/did_cubit.dart';
import 'package:arago_wallet/get_identity_credentials/get_multiple_credentials.dart';
import 'package:arago_wallet/splash/helper_function/is_wallet_created.dart';
import 'package:arago_wallet/wallet/cubit/wallet_cubit.dart';
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
    required this.didCubit,
    required this.homeCubit,
    required this.walletCubit,
    required this.client,
  }) : super(const SplashState()) {
    _getAppVersion();
  }

  final SecureStorageProvider secureStorageProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;
  final WalletCubit walletCubit;
  final DioClient client;

  Future<void> initialiseApp() async {
    final bool hasWallet = await isWalletCreated(
      secureStorageProvider: secureStorageProvider,
      didCubit: didCubit,
      walletCubit: walletCubit,
    );

    if (hasWallet) {
      await homeCubit.emitHasWallet();
      emit(state.copyWith(status: SplashStatus.routeToPassCode));
      if (await isGettingMultipleCredentialsNeeded(secureStorageProvider)) {
        final String? preAuthorizedCode = await secureStorageProvider.get(
          SecureStorageKeys.preAuthorizedCode,
        );
        if (preAuthorizedCode != null) {
          unawaited(
            getCredentialsFromIssuer(
              preAuthorizedCode,
              client,
              Parameters.credentialTypeList,
              secureStorageProvider,
              walletCubit,
            ),
          );
        }
      }
    } else {
      homeCubit.emitHasNoWallet();
      emit(state.copyWith(status: SplashStatus.routeToOnboarding));
    }
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(
      state.copyWith(
        versionNumber: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
      ),
    );
  }
}
