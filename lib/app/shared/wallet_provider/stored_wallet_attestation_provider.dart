import 'dart:convert';

import 'package:altme/app/shared/constants/secure_storage_keys.dart';
import 'package:altme/app/shared/helper_functions/helper_functions.dart';
import 'package:altme/app/shared/message_handler/message_handler.dart';
import 'package:altme/app/shared/wallet_provider/wallet_attestation_provider.dart';
import 'package:jose_plus/jose.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Presents the Wallet Instance Attestation stored when a wallet provider
/// profile was set up, per OAuth 2.0 Attestation-Based Client Authentication.
///
/// The attestation is fetched once, when the profile is loaded, and kept in
/// secure storage; it is bound (`cnf.jwk`) to the wallet attestation key that
/// requested it. Each request gets a fresh proof of possession signed with
/// that key, issued by the `client_id` the attestation assigns (its `sub`) and
/// addressed to the authorization server that checks it (draft 11, §5.1).
class StoredWalletAttestationProvider implements WalletAttestationProvider {
  /// Creates a provider over the attestation kept in [secureStorageProvider].
  const StoredWalletAttestationProvider({required this.secureStorageProvider});

  /// How long a proof of possession stays valid.
  static const Duration proofOfPossessionLifetime = Duration(minutes: 5);

  /// The JOSE `typ` of a Client Attestation PoP.
  static const String proofOfPossessionType =
      'oauth-client-attestation-pop+jwt';

  /// Where the attestation and its key are kept.
  final SecureStorageProvider secureStorageProvider;

  @override
  Future<ClientAttestationPair?> attestationFor({
    required String credentialIssuer,
    String? authorizationServer,
    String? challenge,
    Map<String, dynamic>? issuerMetadata,
  }) async {
    final attestation = await secureStorageProvider.get(
      SecureStorageKeys.walletAttestationData,
    );
    if (attestation == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'This profile has no wallet attestation to present.',
        },
      );
    }

    final claims = JWTDecode().parseJwt(attestation);
    final clientId = claims['sub'] as String?;
    final cnf = claims['cnf'];
    final confirmationKey = cnf is Map<String, dynamic> ? cnf['jwk'] : null;

    final privateKey =
        jsonDecode(await getWalletAttestationP256Key(secureStorageProvider))
            as Map<String, dynamic>;

    // The authorization server verifies the proof with `cnf.jwk`: signed with
    // any other key it can only be rejected, and the reason would be lost
    // there.
    // Coordinates compared without base64url padding, which either side may
    // or may not carry.
    String? coordinate(Map<String, dynamic> jwk, String name) =>
        jwk[name]?.toString().replaceAll('=', '');
    if (confirmationKey is! Map<String, dynamic> ||
        coordinate(confirmationKey, 'x') != coordinate(privateKey, 'x') ||
        coordinate(confirmationKey, 'y') != coordinate(privateKey, 'y')) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'The wallet attestation is not bound to this wallet.',
        },
      );
    }

    final issuedAt = DateTime.now();
    final builder = JsonWebSignatureBuilder()
      ..jsonContent = {
        if (clientId != null) 'iss': clientId,
        // Without an issuer identifier for the authorization server, the
        // credential issuer is its own.
        'aud': authorizationServer ?? credentialIssuer,
        if (challenge != null) 'challenge': challenge,
        'iat': issuedAt.millisecondsSinceEpoch ~/ 1000,
        'exp':
            issuedAt.add(proofOfPossessionLifetime).millisecondsSinceEpoch ~/
            1000,
        'jti': const Uuid().v4(),
      }
      ..setProtectedHeader('typ', proofOfPossessionType)
      ..addRecipient(JsonWebKey.fromJson(privateKey), algorithm: 'ES256');

    return ClientAttestationPair(
      attestation: attestation,
      proofOfPossession: builder.build().toCompactSerialization(),
      clientId: clientId,
    );
  }

  /// Always `null`: the stored attestation scheme attests no
  /// credential-binding keys.
  @override
  Future<KeyAttestationProofs?> keyAttestationProofsFor({
    required String credentialIssuer,
    required String cNonce,
    required int batchSize,
    String? credentialConfigurationId,
    Map<String, dynamic>? issuerMetadata,
  }) async => null;

  /// Does nothing: with no key attestations there is nothing to spend.
  @override
  Future<void> markKeyAttestationsConsumed({
    required String credentialIssuer,
  }) async {}
}
