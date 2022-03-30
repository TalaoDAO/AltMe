library secure_storage;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage.dart';

SecureStorageProvider getProvider() => SecureStorageIO();

class SecureStorageIO extends SecureStorageProvider {
  FlutterSecureStorage get _storage => FlutterSecureStorage();

  IOSOptions get _defaultIOSOptions => const IOSOptions(
        accessibility: IOSAccessibility.unlocked_this_device,
      );

  @override
  Future<String?> get(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> set(String key, String val) async {
    return _storage.write(
      key: key,
      value: val,
      iOptions: _defaultIOSOptions,
    );
  }

  @override
  Future<void> delete(String key) async {
    return _storage.delete(
      key: key,
      iOptions: _defaultIOSOptions,
    );
  }

  @override
  Future<Map<String, String>> getAllValues() {
    return _storage.readAll();
  }

  @override
  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }
}
