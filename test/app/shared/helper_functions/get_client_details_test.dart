import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class _MockProfileCubit extends Mock implements ProfileCubit {}

class _MockSecureStorage extends Mock implements SecureStorageProvider {}

/// Hands out one fixed attestation pair and counts the requests for it.
class _FakeAttestationProvider extends Fake
    implements WalletAttestationProvider {
  int requests = 0;

  @override
  Future<ClientAttestationPair?> attestationFor({
    required String credentialIssuer,
    String? authorizationServer,
    String? challenge,
    Map<String, dynamic>? issuerMetadata,
  }) async {
    requests++;
    return const ClientAttestationPair(
      attestation: 'the-attestation',
      proofOfPossession: 'the-proof-of-possession',
      clientId: 'the-wia-sub',
    );
  }
}

void main() {
  group('getClientDetails', () {
    late _MockProfileCubit profileCubit;
    late _FakeAttestationProvider attestationProvider;

    setUp(() {
      profileCubit = _MockProfileCubit();
      attestationProvider = _FakeAttestationProvider();
      final secureStorage = _MockSecureStorage();
      final deviceKey = generateP256KeyForDPop();
      when(() => secureStorage.get(any())).thenAnswer((_) async => deviceKey);
      when(() => profileCubit.secureStorageProvider).thenReturn(secureStorage);
      when(() => profileCubit.walletAttestationProvider).thenReturn(null);

      // A profile whose own setting is a plain client_id.
      final model = ProfileModel.empty();
      final options = model.profileSetting.selfSovereignIdentityOptions;
      when(() => profileCubit.state).thenReturn(
        ProfileState(
          model: model.copyWith(
            profileSetting: model.profileSetting.copyWith(
              selfSovereignIdentityOptions: options.copyWith(
                customOidc4vcProfile: options.customOidc4vcProfile.copyWith(
                  clientAuthentication: ClientAuthentication.clientId,
                  clientType: ClientType.p256JWKThumprint,
                  defaultDid: DidKeyType.jwkP256,
                ),
              ),
            ),
          ),
        ),
      );
    });

    Future<(String?, String?, String?, String?, String?)> clientDetails(
      ClientAuthentication clientAuthentication,
    ) => getClientDetails(
      profileCubit: profileCubit,
      isEBSI: false,
      issuer: 'https://issuer.example',
      attestationProvider: attestationProvider,
      clientAuthentication: clientAuthentication,
    );

    test('authenticates with the WIA the policy decided on, whatever the '
        "profile's setting", () async {
      final (clientId, _, _, attestation, proofOfPossession) =
          await clientDetails(ClientAuthentication.wia);

      expect(clientId, 'the-wia-sub');
      expect(attestation, 'the-attestation');
      expect(proofOfPossession, 'the-proof-of-possession');
    });

    test(
      'sends no attestation when the policy decided on a client_id',
      () async {
        final (clientId, _, _, attestation, proofOfPossession) =
            await clientDetails(ClientAuthentication.clientId);

        expect(clientId, isNotNull);
        expect(clientId, isNot('the-wia-sub'));
        expect(attestation, isNull);
        expect(proofOfPossession, isNull);
        expect(attestationProvider.requests, 0);
      },
    );
  });
}
