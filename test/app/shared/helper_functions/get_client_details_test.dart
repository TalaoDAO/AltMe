import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jose_plus/jose.dart';
import 'package:jwt_decode/jwt_decode.dart';
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

/// Cannot provide an attestation, as when the wallet provider is unreachable.
class _FailingAttestationProvider extends Fake
    implements WalletAttestationProvider {
  @override
  Future<ClientAttestationPair?> attestationFor({
    required String credentialIssuer,
    String? authorizationServer,
    String? challenge,
    Map<String, dynamic>? issuerMetadata,
  }) async => throw ResponseMessage(data: {'error': 'unavailable'});
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

    test('says why when the WIA it decided on cannot be had', () async {
      await expectLater(
        getClientDetails(
          profileCubit: profileCubit,
          isEBSI: false,
          issuer: 'https://issuer.example',
          attestationProvider: _FailingAttestationProvider(),
          clientAuthentication: ClientAuthentication.wia,
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });

    /// Stores a WIA bound to the wallet's attestation key, as the wallet
    /// provider issues it, and returns it.
    Future<String> storeAttestation() async {
      final secureStorage = profileCubit.secureStorageProvider;
      final attestationKey = JsonWebKey.generate('ES256');
      final attestation =
          (JsonWebSignatureBuilder()
                ..jsonContent = {
                  'sub': 'https://client.wallet-provider.example',
                  'cnf': {
                    'jwk': Map<String, dynamic>.from(attestationKey.toJson())
                      ..remove('d'),
                  },
                }
                ..addRecipient(
                  JsonWebKey.generate('ES256'),
                  algorithm: 'ES256',
                ))
              .build()
              .toCompactSerialization();
      when(
        () => secureStorage.get(SecureStorageKeys.walletAttestationData),
      ).thenAnswer((_) async => attestation);
      when(
        () => secureStorage.get(SecureStorageKeys.p256PrivateKeyForWallet),
      ).thenAnswer((_) async => jsonEncode(attestationKey.toJson()));
      return attestation;
    }

    test('presents the stored WIA, signed with its attestation key', () async {
      final attestation = await storeAttestation();

      final (
        clientId,
        _,
        _,
        sentAttestation,
        proofOfPossession,
      ) = await getClientDetails(
        profileCubit: profileCubit,
        isEBSI: false,
        issuer: 'https://issuer.example',
        clientAuthentication: ClientAuthentication.wia,
      );

      expect(clientId, 'https://client.wallet-provider.example');
      expect(sentAttestation, attestation);
      expect(proofOfPossession, isNotNull);
    });

    test('takes the client_id of an enterprise profile from its WIA', () async {
      // #3553: an enterprise profile configured by a wallet provider got the
      // enterprise scheme, which has no client_id to give, and the
      // authorization server refused the token request.
      final model = profileCubit.state.model;
      when(() => profileCubit.state).thenReturn(
        ProfileState(
          model: model.copyWith(
            profileType: ProfileType.enterprise,
            enterpriseWalletName: 'IMT',
          ),
        ),
      );
      await storeAttestation();

      final (clientId, _, _, _, proofOfPossession) = await getClientDetails(
        profileCubit: profileCubit,
        isEBSI: false,
        issuer: 'https://issuer.example',
        clientAuthentication: ClientAuthentication.wia,
      );

      expect(clientId, 'https://client.wallet-provider.example');
      expect(
        JWTDecode().parseJwt(proofOfPossession!)['iss'],
        'https://client.wallet-provider.example',
      );
    });

    test('keeps the enterprise scheme for client_secret_jwt', () async {
      await storeAttestation();

      final (clientId, _, _, _, proofOfPossession) = await getClientDetails(
        profileCubit: profileCubit,
        isEBSI: false,
        issuer: 'https://issuer.example',
        clientAuthentication: ClientAuthentication.clientSecretJwt,
      );

      expect(clientId, startsWith('did:'));
      expect(JWTDecode().parseJwt(proofOfPossession!)['iss'], clientId);
    });
  });
}
