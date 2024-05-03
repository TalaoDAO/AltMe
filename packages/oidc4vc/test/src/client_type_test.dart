import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('ClientTypeX', () {
    test('getTitle', () {
      expect(ClientType.p256JWKThumprint.getTitle, 'P-256 JWK Thumbprint');
      expect(ClientType.did.getTitle, 'DID');
      expect(ClientType.confidential.getTitle, 'Confidential Client');
    });
  });
}
