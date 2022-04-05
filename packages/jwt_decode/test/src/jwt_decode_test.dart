// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';

void main() {
  group('JwtDecode', () {
    test('can be instantiated', () {
      expect(JwtDecode(), isNotNull);
    });
  });
}
