import 'package:altme/app/app.dart';
import 'package:altme/did/cubit/did_cubit.dart';
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
  }) : super(const SplashState()) {
    _getAppVersion();
  }

  final SecureStorageProvider secureStorageProvider;
  final DIDCubit didCubit;

  Future<void> initialiseApp() async {
    final String? key = await secureStorageProvider.get(SecureStorageKeys.key);
    if (key == null || key.isEmpty) {
      return emit(state.copyWith(status: SplashStatus.hasNoWallet));
    }

    final String? did = await secureStorageProvider.get(SecureStorageKeys.did);

    if (did == null || did.isEmpty) {
      return emit(state.copyWith(status: SplashStatus.hasNoWallet));
    }

    final String? didMethod =
        await secureStorageProvider.get(SecureStorageKeys.didMethod);
    if (didMethod == null || didMethod.isEmpty) {
      return emit(state.copyWith(status: SplashStatus.hasNoWallet));
    }

    final String? didMethodName =
        await secureStorageProvider.get(SecureStorageKeys.didMethodName);
    if (didMethodName == null || didMethodName.isEmpty) {
      return emit(state.copyWith(status: SplashStatus.hasNoWallet));
    }

    final String? isEnterprise =
        await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser);

    if (isEnterprise != null && isEnterprise.isNotEmpty) {
      if (isEnterprise == 'true') {
        final rsaKeyJson =
            await secureStorageProvider.get(SecureStorageKeys.rsaKeyJson);
        if (rsaKeyJson == null || rsaKeyJson.isEmpty) {
          return emit(state.copyWith(status: SplashStatus.hasNoWallet));
        }
      }
    }

    await didCubit.load(
      did: did,
      didMethod: didMethod,
      didMethodName: didMethodName,
    );

    return emit(state.copyWith(status: SplashStatus.hasWallet));
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(state.copyWith(versionNumber: packageInfo.version));
  }
}
