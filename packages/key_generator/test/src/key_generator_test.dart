// ignore_for_file: prefer_const_constructors
import 'package:key_generator/key_generator.dart';
import 'package:test/test.dart';

void main() {
  group('KeyGenerator', () {
    test('can be instantiated', () {
      expect(KeyGenerator(), isNotNull);
    });
  });
}
