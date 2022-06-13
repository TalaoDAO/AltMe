// ignore_for_file: prefer_const_constructors
import 'package:key_generator/key_generator.dart';
import 'package:test/test.dart';

void main() {
  group('KeyGenerator', () {
    test('can be instantiated', () {
      KeyGenerator().privateKey(
        '''notice photo opera keen climb agent soft parrot best joke field devote''',
      );
      expect(KeyGenerator(), isNotNull);
    });
  });
}
