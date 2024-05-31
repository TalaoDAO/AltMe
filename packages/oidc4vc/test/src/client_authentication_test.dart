import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('ClientAuthenticationX', () {
    test('value', () {
      expect(ClientAuthentication.none.value, 'none');
      expect(
          ClientAuthentication.clientSecretBasic.value, 'client_secret_basic');
      expect(ClientAuthentication.clientSecretPost.value, 'client_secret_post');
      expect(ClientAuthentication.clientId.value, 'client_id');
      expect(ClientAuthentication.clientSecretJwt.value, 'client_secret_jwt');
    });
  });
}
