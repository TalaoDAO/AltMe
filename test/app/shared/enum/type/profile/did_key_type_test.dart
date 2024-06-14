import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DidKeyType Extension', () {
    test('Formatted String', () {
      expect(DidKeyType.edDSA.formattedString, 'did:key edDSA');
      expect(DidKeyType.secp256k1.formattedString, 'did:key secp256k1');
      expect(DidKeyType.p256.formattedString, 'did:key P-256');
      expect(DidKeyType.ebsiv3.formattedString, 'did:key EBSI-V3');
      expect(DidKeyType.jwkP256.formattedString, 'did:jwk P-256');
      expect(DidKeyType.jwtClientAttestation.formattedString, '');
    });

    test('Support Crypto Credential', () {
      expect(DidKeyType.edDSA.supportCryptoCredential, true);
      expect(DidKeyType.secp256k1.supportCryptoCredential, true);
      expect(DidKeyType.p256.supportCryptoCredential, true);
      expect(DidKeyType.ebsiv3.supportCryptoCredential, false);
      expect(DidKeyType.jwkP256.supportCryptoCredential, true);
      expect(DidKeyType.jwtClientAttestation.supportCryptoCredential, true);
    });
  });
}
