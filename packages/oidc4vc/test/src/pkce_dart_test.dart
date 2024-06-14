import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('PkcePair', () {
    test('generate', () {
      final pkcePair = PkcePair.generate();
      expect(pkcePair.codeVerifier.length, 43);
      expect(pkcePair.codeChallenge.length, 43);
    });

    test('generate with invalid length', () {
      expect(
        () => PkcePair.generate(length: 31), // Less than 32
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => PkcePair.generate(length: 97), // Greater than 96
        throwsA(isA<ArgumentError>()),
      );
    });

    test('generate produces unique values', () {
      final pkcePair1 = PkcePair.generate();
      final pkcePair2 = PkcePair.generate();

      expect(pkcePair1.codeVerifier, isNot(pkcePair2.codeVerifier));
      expect(pkcePair1.codeChallenge, isNot(pkcePair2.codeChallenge));
    });
  });
}
