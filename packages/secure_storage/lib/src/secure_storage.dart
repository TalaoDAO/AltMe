import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///SecureStorageProvider
class SecureStorageProvider {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  IOSOptions get _defaultIOSOptions => const IOSOptions(
        accessibility: IOSAccessibility.unlocked_this_device,
      );

  ///get
  Future<String?> get(String key) async {
    try {
      return await _storage.read(key: key);
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
}
