import 'package:altme/app/app.dart';
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
  final log = getLogger('LocalAuthApi');

  Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return <BiometricType>[];
    }
  }

  Future<bool> authenticate({
    required String localizedReason,
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
    } on PlatformException catch (e, s) {
      log.e('${e.message} stack: $s');
      return false;
    }
  }
}
