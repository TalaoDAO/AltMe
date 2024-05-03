import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('MediaTypeX', () {
    test('typ', () {
      expect(MediaType.proofOfOwnership.typ, 'openid4vci-proof+jwt');
      expect(MediaType.basic.typ, 'JWT');
      expect(MediaType.walletAttestation.typ, 'wiar+jwt');
      expect(MediaType.selectiveDisclosure.typ, 'kb+jwt');
    });
  });
}
