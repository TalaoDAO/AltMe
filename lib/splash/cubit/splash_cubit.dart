import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class SplashCubit extends Cubit<SplashStatus> {
  SplashCubit(this.secureStorageProvider) : super(SplashStatus.init);

  final SecureStorageProvider secureStorageProvider;

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

    if (isEnterprise == null || isEnterprise.isEmpty) {
      return emit(SplashStatus.onboarding);
    }

    if (isEnterprise == 'true') {
      final rsaKeyJson =
          await secureStorageProvider.get(SecureStorageKeys.rsaKeyJson);
      if (rsaKeyJson == null || rsaKeyJson.isEmpty) {
        return emit(SplashStatus.onboarding);
      }
    }
    // TODO(all): load_didkit
    // context
    //     .read<DIDCubit>()
    //     .load(did: did, didMethod: didMethod, didMethodName: didMethodName);
    emit(SplashStatus.bypassOnboarding);
  }
}
