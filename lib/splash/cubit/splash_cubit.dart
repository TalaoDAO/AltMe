import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.secureStorageProvider) : super(SplashState.init);

  final SecureStorageProvider secureStorageProvider;

  Future<void> initialiseApp() async {
    final String? key = await secureStorageProvider.get(SecureStorageKeys.key);
    if (key == null || key.isEmpty) {
      return emit(SplashState.onboarding);
    }

    final String? did = await secureStorageProvider.get(SecureStorageKeys.did);
    final String? didMethod =
        await secureStorageProvider.get(SecureStorageKeys.didMethod);
    final String? didMethodName =
        await secureStorageProvider.get(SecureStorageKeys.didMethodName);
    if (did == null || did.isEmpty) {
      return emit(SplashState.onboarding);
    }
    if (didMethod == null || didMethod.isEmpty) {
      return emit(SplashState.onboarding);
    }
    if (didMethodName == null || didMethodName.isEmpty) {
      return emit(SplashState.onboarding);
    }

    final String? isEnterprise =
        await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser);

    if (isEnterprise == null || isEnterprise.isEmpty) {
      return emit(SplashState.onboarding);
    }

    if (isEnterprise == 'true') {
      final rsaKeyJson =
          await secureStorageProvider.get(SecureStorageKeys.rsaKeyJson);
      if (rsaKeyJson == null || rsaKeyJson.isEmpty) {
        return emit(SplashState.onboarding);
      }
    }
    // TODO(all): load_didkit
    // context
    //     .read<DIDCubit>()
    //     .load(did: did, didMethod: didMethod, didMethodName: didMethodName);
    emit(SplashState.bypassOnboarding);
  }
}
