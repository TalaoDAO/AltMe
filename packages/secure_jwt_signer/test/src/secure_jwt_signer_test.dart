import 'package:secure_jwt_signer/secure_jwt_signer.dart';
import 'package:test/test.dart';

void main() {
  group('SecureJwtSigner', () {
    test('can be instantiated', () {
      expect(const SecureJwtSigner(), isNotNull);
    });
  });
}
