import 'package:altme/app/app.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class SplashCubit extends Cubit<SplashStatus> {
  SplashCubit({
    required this.secureStorageProvider,
    required this.didCubit,
  }) : super(SplashStatus.init);

  final SecureStorageProvider secureStorageProvider;
  final DIDCubit didCubit;

  Future<void> initialiseApp() async {
    final String? key = await secureStorageProvider.get(SecureStorageKeys.key);
    if (key == null || key.isEmpty) {
      return emit(SplashStatus.onboarding);
    }

    final String? did = await secureStorageProvider.get(SecureStorageKeys.did);

    if (did == null || did.isEmpty) {
      return emit(SplashStatus.onboarding);
    }

    final String? didMethod =
        await secureStorageProvider.get(SecureStorageKeys.didMethod);
    if (didMethod == null || didMethod.isEmpty) {
      return emit(SplashStatus.onboarding);
    }

    final String? didMethodName =
        await secureStorageProvider.get(SecureStorageKeys.didMethodName);
    if (didMethodName == null || didMethodName.isEmpty) {
      return emit(SplashStatus.onboarding);
    }

    final String? isEnterprise =
        await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser);

    if (isEnterprise != null && isEnterprise.isNotEmpty) {
      if (isEnterprise == 'true') {
        final rsaKeyJson =
            await secureStorageProvider.get(SecureStorageKeys.rsaKeyJson);
        if (rsaKeyJson == null || rsaKeyJson.isEmpty) {
          return emit(SplashStatus.onboarding);
        }
      }
    }

    await didCubit.load(
      did: did,
      didMethod: didMethod,
      didMethodName: didMethodName,
    );
    emit(SplashStatus.bypassOnBoarding);
  }
}
