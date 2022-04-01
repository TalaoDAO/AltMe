import 'package:secure_storage/src/secure_storage_stub.dart'
    if (dart.library.io) 'secure_storage_io.dart'
    if (dart.library.js) 'secure_storage_js.dart';

///SecureStorageProviderClass
abstract class SecureStorageProvider {
  static SecureStorageProvider? _instance;

  ///SecureStorageProviderInstance
  static SecureStorageProvider get instance {
    _instance ??= getProvider();
    return _instance!;
  }

  ///get string
  Future<String?> get(String key);

  ///set string
  Future<void> set(String key, String val);

  ///delete string
  Future<void> delete(String key);

  ///get all values
  Future<Map<String, dynamic>> getAllValues();

  ///delete all values
  Future<void> deleteAll();
}

///SecureStorage keys class
abstract class SecureStorageKeys {
  ///data
  static const data = 'data';

  ///mnemonic
  static const mnemonic = 'mnemonic';

  ///isEnterpriseUser
  static const isEnterpriseUser = 'isEnterpriseUser';

  ///did
  static const did = 'DID';

  ///rsaKeyJson
  static const rsaKeyJson = 'RSAKeyJson';

  ///key
  static const key = 'key';

  ///didMethod
  static const didMethod = 'DIDMethod';

  ///didMethodName
  static const didMethodName = 'DIDMethodName';

  ///verificationMethod
  static const verificationMethod = 'VerificationMethod';

  ///companyName
  static const companyName = 'companyName';

  ///companyWebsite
  static const companyWebsite = 'companyWebsite';

  ///jobTitle
  static const jobTitle = 'jobTitle';

  ///firstNameKey
  static const String firstNameKey = 'profile/firstName';

  ///lastNameKey
  static const String lastNameKey = 'profile/lastName';

  ///phoneKey
  static const String phoneKey = 'profile/phone';

  ///locationKey
  static const String locationKey = 'profile/location';

  ///emailKey
  static const String emailKey = 'profile/email';

  ///issuerVerificationSettingKey
  static const String issuerVerificationSettingKey =
      'profile/issuerVerificationSetting';
}
