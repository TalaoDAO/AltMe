import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jose_plus/jose.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class _MockSecureStorage extends Mock implements SecureStorageProvider {}

Map<String, dynamic> _publicJwk(JsonWebKey key) =>
    Map<String, dynamic>.from(key.toJson())..remove('d');

/// A Wallet Instance Attestation as wallet-provider.com issues it: what the
/// provider reads is its `sub` and its `cnf.jwk`.
String _walletInstanceAttestation({required Map<String, dynamic> boundTo}) =>
    (JsonWebSignatureBuilder()
          ..jsonContent = {
            'iss': 'https://wallet-provider.example',
            'sub': 'https://client.wallet-provider.example',
            'cnf': {'jwk': boundTo},
          }
          ..setProtectedHeader('typ', 'oauth-client-attestation+jwt')
          ..addRecipient(JsonWebKey.generate('ES256'), algorithm: 'ES256'))
        .build()
        .toCompactSerialization();

void main() {
  late _MockSecureStorage secureStorage;
  late JsonWebKey attestationKey;
  late StoredWalletAttestationProvider provider;

  setUp(() {
    secureStorage = _MockSecureStorage();
    attestationKey = JsonWebKey.generate('ES256');
    when(
      () => secureStorage.get(SecureStorageKeys.p256PrivateKeyForWallet),
    ).thenAnswer((_) async => jsonEncode(attestationKey.toJson()));
    provider = StoredWalletAttestationProvider(
      secureStorageProvider: secureStorage,
    );
  });

  void storeAttestation(String? attestation) => when(
    () => secureStorage.get(SecureStorageKeys.walletAttestationData),
  ).thenAnswer((_) async => attestation);

  Future<ClientAttestationPair?> attestationFor() => provider.attestationFor(
    credentialIssuer: 'https://issuer.example',
    authorizationServer: 'https://as.example',
    challenge: 'the-challenge',
  );

  group('StoredWalletAttestationProvider', () {
    test('presents the stored attestation with a proof of possession signed '
        'by its cnf key, issued by its sub, addressed to the authorization '
        'server', () async {
      final attestation = _walletInstanceAttestation(
        boundTo: _publicJwk(attestationKey),
      );
      storeAttestation(attestation);

      final pair = await attestationFor();

      expect(pair?.attestation, attestation);
      expect(pair?.clientId, 'https://client.wallet-provider.example');

      final proof = JsonWebSignature.fromCompactSerialization(
        pair!.proofOfPossession!,
      );
      expect(
        await proof.verify(
          JsonWebKeyStore()
            ..addKey(JsonWebKey.fromJson(_publicJwk(attestationKey))),
        ),
        isTrue,
      );
      expect(
        proof.commonProtectedHeader.type,
        'oauth-client-attestation-pop+jwt',
      );
      final claims = proof.unverifiedPayload.jsonContent as Map;
      expect(claims['iss'], 'https://client.wallet-provider.example');
      expect(claims['aud'], 'https://as.example');
      expect(claims['challenge'], 'the-challenge');
      expect(claims['jti'], isA<String>());
      expect(
        (claims['exp'] as int) - (claims['iat'] as int),
        StoredWalletAttestationProvider.proofOfPossessionLifetime.inSeconds,
      );
    });

    test('refuses an attestation bound to another key', () async {
      storeAttestation(
        _walletInstanceAttestation(
          boundTo: _publicJwk(JsonWebKey.generate('ES256')),
        ),
      );

      await expectLater(attestationFor(), throwsA(isA<ResponseMessage>()));
    });

    test('refuses when no attestation is stored', () async {
      storeAttestation(null);

      await expectLater(attestationFor(), throwsA(isA<ResponseMessage>()));
    });

    test('attests no credential-binding keys', () async {
      expect(
        await provider.keyAttestationProofsFor(
          credentialIssuer: 'https://issuer.example',
          cNonce: 'nonce',
          batchSize: 1,
        ),
        isNull,
      );
    });
  });
}
