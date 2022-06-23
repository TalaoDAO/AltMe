import 'package:altme/app/app.dart';
import 'package:altme/app/shared/helper_function/is_wallet_created.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/home/home/home.dart';
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
  }) : super(const SplashState()) {
    _getAppVersion();
  }

  final SecureStorageProvider secureStorageProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;

  Future<void> initialiseApp() async {
    final bool hasWallet = await isWalletCreated(
      secureStorageProvider: secureStorageProvider,
      didCubit: didCubit,
    );

    if (hasWallet) {
      homeCubit.emitHasWallet();
      emit(state.copyWith(status: SplashStatus.routeToPassCode));
    } else {
      homeCubit.emitHasNoWallet();
      emit(state.copyWith(status: SplashStatus.routeToHomePage));
    }
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(state.copyWith(versionNumber: packageInfo.version));
  }
}
