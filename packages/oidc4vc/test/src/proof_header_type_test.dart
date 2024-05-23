import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('ProofHeaderTypeX', () {
    test('formattedString', () {
      expect(ProofHeaderType.kid.formattedString, 'kid');
      expect(ProofHeaderType.jwk.formattedString, 'jwk');
    });
  });
}
