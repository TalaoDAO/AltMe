import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  factory LocalAuthApi() {
    _instance ??= LocalAuthApi._();
    return _instance!;
  }

  LocalAuthApi._();

  static final _auth = LocalAuthentication();
  static LocalAuthApi? _instance;

  Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  Future<bool> authenticate({
    String localizedReason = 'Scan Fingerprint to Authenticate',
  }) async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      return false;
    }
  }
}
