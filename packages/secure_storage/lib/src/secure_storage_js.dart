@JS()
library secure_storage;

import 'dart:html';

import 'package:js/js.dart';

import 'secure_storage.dart';

SecureStorageProvider getProvider() => SecureStorageWeb();

@JS('SecureStorage')
class SecureStorageJS {
  external static String example(String did, String inputMetadata);
}

class SecureStorageWeb extends SecureStorageProvider {
  @override
  Future<String?> get(String key) async {
    return window.localStorage[key];
  }

  @override
  Future<void> set(String key, String val) async {
    window.localStorage.update(
      key,
      (value) => val,
      ifAbsent: () => val,
    );
  }

  @override
  Future<void> delete(String key) async {
    window.localStorage.remove(key);
  }

  @override
  Future<Map<String, String>> getAllValues() async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll() async {
    throw UnimplementedError();
  }
}
