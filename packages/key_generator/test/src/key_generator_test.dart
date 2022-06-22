// ignore_for_file: prefer_const_constructors
import 'package:key_generator/key_generator.dart';
import 'package:test/test.dart';

void main() {
  group('KeyGenerator', () {
    late KeyGenerator keyGenerator;

    setUpAll(() {
      keyGenerator = KeyGenerator();
    });

    test('can be instantiated', () {
      keyGenerator.jwkFromMnemonic(
        mnemonic:
            '''notice photo opera keen climb agent soft parrot best joke field devote''',
      );
      expect(keyGenerator, isNotNull);
    });
  });
}
