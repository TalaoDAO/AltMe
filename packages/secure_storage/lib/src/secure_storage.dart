import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///SecureStorageProvider getter
SecureStorageProvider get getSecureStorage =>
    const SecureStorageProvider(FlutterSecureStorage());

///SecureStorageProvider
class SecureStorageProvider {
  ///SecureStorageProvider
  const SecureStorageProvider(this._storage);

  final FlutterSecureStorage _storage;

  IOSOptions get _defaultIOSOptions =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  ///get
  Future<String?> get(String key) async {
    try {
      return await _storage.read(
        key: key,
        iOptions: _defaultIOSOptions,
      );
    } catch (e) {
      return null;
    }
  }

  ///set
  Future<void> set(String key, String val) async {
    return _storage.write(
      key: key,
      value: val,
      iOptions: _defaultIOSOptions,
    );
  }

  ///delete
  Future<void> delete(String key) async {
    return _storage.delete(
      key: key,
      iOptions: _defaultIOSOptions,
    );
  }

  ///getAllValues
  Future<Map<String, String>> getAllValues() {
    return _storage.readAll();
  }

  ///deleteAll
  Future<void> deleteAll() async {
    return _storage.deleteAll();
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
