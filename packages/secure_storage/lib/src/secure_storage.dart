import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

SecureStorageProvider get getSecureStorage {
  return SecureStorageProvider(const FlutterSecureStorage());
}

///SecureStorageProvider
class SecureStorageProvider {
  SecureStorageProvider._internal();

  ///SecureStorageProvider
  factory SecureStorageProvider(FlutterSecureStorage storage) {
    if (_instance._storage == null) {
      _instance._storage = storage;
      if (Platform.isAndroid) {
        try {
          /// some android devices need additional parameters to use secureStorage
          /// We are testing getAllValues to check if those additional settings are
          /// required. We don't set it by default because old wallets would loose
          /// their data.
          /// https://github.com/mogol/flutter_secure_storage/issues/354
          print('firs try android');
          _instance.getAllValues();
          print('it worked but it didn\'t');
        } catch (e) {
          const defaultAndroidOptions = AndroidOptions(
            encryptedSharedPreferences: true,
            sharedPreferencesName: 'talao',
          );
          print('second try android');

          _instance._storage = const FlutterSecureStorage(
            aOptions: defaultAndroidOptions,
          );
        }
      } else {
        const defaultIOSOptions =
            IOSOptions(accessibility: KeychainAccessibility.first_unlock);
        print('ios!!! ?');

        _instance._storage = const FlutterSecureStorage(
          iOptions: defaultIOSOptions,
        );
      }
    }
    return _instance;
  }

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
