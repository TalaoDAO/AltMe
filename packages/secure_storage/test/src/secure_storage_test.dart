// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_storage/secure_storage.dart';

void main() {
  group('SecureStorage', () {
    test('can be instantiated', () {
      expect(SecureStorageProvider.instance, isNotNull);
    });
  });
}
