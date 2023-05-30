import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provide secure storage
SecureStorageProvider get getSecureStorage {
  return SecureStorageProvider();
}

/// Initialize and test secure storage availability on the phone.
Future<void> get initSecureStorage async {
  if (Platform.isAndroid) {
    try {
      /// some android devices need additional parameters to use secureStorage
      /// We are testing getAllValues to check if those additional settings are
      /// required. We don't set it by default because old wallets would loose
      /// their data.
      /// https://github.com/mogol/flutter_secure_storage/issues/354
      const storage = FlutterSecureStorage();
      await testStorage(storage);
    } catch (e) {
      const defaultAndroidOptions = AndroidOptions(
        encryptedSharedPreferences: true,
        sharedPreferencesName: 'altme',
      );

      const storage = FlutterSecureStorage(
        aOptions: defaultAndroidOptions,
      );
      await testStorage(storage);
    }
  } else {
    const defaultIOSOptions =
        IOSOptions(accessibility: KeychainAccessibility.first_unlock);

    const storage = FlutterSecureStorage(
      iOptions: defaultIOSOptions,
    );
    await testStorage(storage);
  }
}

/// Some android phones are having issue with secure storage
/// We test different storage configuration in order to get
/// proper phone secure storage.
Future<void> testStorage(FlutterSecureStorage storage) async {
  final secureStorage = SecureStorageProvider(storage: storage);
  final testCompatibility = await secureStorage.getAllValues();
}

///SecureStorageProvider
class SecureStorageProvider {
  ///SecureStorageProvider
  factory SecureStorageProvider({
    FlutterSecureStorage? storage,
  }) {
    if (storage != null) {
      _instance._storage = storage;
      return _instance;
    } else {
      if (_instance._storage == null) {
        //TODO: Explain user and give him possibility to send issue report?
        throw Exception('Secure Storage issue with this device');
      }
      return _instance;
    }
  }

  SecureStorageProvider._internal();

  FlutterSecureStorage? _storage;

  static final SecureStorageProvider _instance =
      SecureStorageProvider._internal();

  ///get
  Future<String?> get(String key) async {
    try {
      return await _storage!.read(
        key: key,
      );
    } catch (e) {
      return null;
    }
  }

  ///set
  Future<void> set(String key, String val) async {
    return _storage!.write(
      key: key,
      value: val,
    );
  }

  ///delete
  Future<void> delete(String key) async {
    return _storage!.delete(
      key: key,
    );
  }

  ///getAllValues
  Future<Map<String, String>> getAllValues() {
    return _storage!.readAll();
  }

  ///deleteAll
  Future<void> deleteAll() async {
    return _storage!.deleteAll();
  }

  ///deleteAllExceptsSomeKeys
  Future<void> deleteAllExceptsSomeKeys(List<String>? exceptKeys) async {
    if (exceptKeys == null || exceptKeys.isEmpty) {
      await deleteAll();
    } else {
      final keyValues = await getAllValues();
      final keys = keyValues.keys.toList();
      for (final key in keys) {
        if (!exceptKeys.contains(key)) {
          await delete(key);
        }
      }
    }
  }
}
