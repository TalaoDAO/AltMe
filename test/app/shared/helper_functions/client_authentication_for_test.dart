import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  const asksForAttestation = {
    'token_endpoint_auth_methods_supported': [
      'private_key_jwt',
      'attest_jwt_client_auth',
    ],
  };

  final custom = ProfileModel.empty();
  final configured = custom
      .profileSetting
      .selfSovereignIdentityOptions
      .customOidc4vcProfile
      .clientAuthentication;

  group('clientAuthenticationFor', () {
    test('uses WIA when the authorization server asks for it', () {
      expect(
        clientAuthenticationFor(
          profile: custom,
          authorizationServerMetadata: asksForAttestation,
        ),
        ClientAuthentication.wia,
      );
    });

    test("keeps the profile's otherwise", () {
      expect(
        clientAuthenticationFor(
          profile: custom,
          authorizationServerMetadata: const {
            'token_endpoint_auth_methods_supported': ['private_key_jwt'],
          },
        ),
        configured,
      );
      expect(clientAuthenticationFor(profile: custom), configured);
    });

    test('never on the default profile, which has no wallet attestation', () {
      final defaultOne = ProfileModel.defaultOne(
        walletType: WalletType.personal,
        walletProtectionType: WalletProtectionType.pinCode,
        isDeveloperMode: false,
        clientId: null,
        clientSecret: null,
      );

      expect(
        clientAuthenticationFor(
          profile: defaultOne,
          authorizationServerMetadata: asksForAttestation,
        ),
        defaultOne
            .profileSetting
            .selfSovereignIdentityOptions
            .customOidc4vcProfile
            .clientAuthentication,
      );
    });
  });
}
