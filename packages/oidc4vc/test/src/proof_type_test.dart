import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('ProofTypeeX', () {
    test('formattedString', () {
      expect(ProofType.ldpVp.formattedString, 'ldp_vp');
      expect(ProofType.jwt.formattedString, 'jwt');
    });

    test('value', () {
      expect(ProofType.ldpVp.value, 'ldp_vp');
      expect(ProofType.jwt.value, 'jwt');
    });
  });
}
