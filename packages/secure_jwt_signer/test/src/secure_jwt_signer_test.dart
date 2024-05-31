// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:secure_jwt_signer/secure_jwt_signer.dart';
import 'package:test/test.dart';

void main() {
  group('SecureJwtSigner', () {
    test('can be instantiated', () {
      expect(SecureJwtSigner(), isNotNull);
    });
  });
}
