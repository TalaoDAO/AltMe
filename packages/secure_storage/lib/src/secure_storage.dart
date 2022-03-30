import 'secure_storage_stub.dart'
    if (dart.library.io) 'secure_storage_io.dart'
    if (dart.library.js) 'secure_storage_js.dart';

abstract class SecureStorageProvider {
  static SecureStorageProvider? _instance;

  static SecureStorageProvider get instance {
    _instance ??= getProvider();
    return _instance!;
  }

  Future<String?> get(String key);

  Future<void> set(String key, String val);

  Future<void> delete(String key);

  Future<Map<String, dynamic>> getAllValues();

  Future<void> deleteAll();
}

abstract class SecureStorageKeys {
  static const data = 'data';
  static const mnemonic = 'mnemonic';
  static const isEnterpriseUser = 'isEnterpriseUser';
  static const did = 'DID';
  static const rsaKeyJson = 'RSAKeyJson';
  static const key = 'key';
  static const didMethod = 'DIDMethod';
  static const didMethodName = 'DIDMethodName';
  static const verificationMethod = 'VerificationMethod';
  static const companyName = 'companyName';
  static const companyWebsite = 'companyWebsite';
  static const jobTitle = 'jobTitle';
  //
  static const String firstNameKey = 'profile/firstName';
  static const String lastNameKey = 'profile/lastName';
  static const String phoneKey = 'profile/phone';
  static const String locationKey = 'profile/location';
  static const String emailKey = 'profile/email';
  static const String issuerVerificationSettingKey =
      'profile/issuerVerificationSetting';
}
