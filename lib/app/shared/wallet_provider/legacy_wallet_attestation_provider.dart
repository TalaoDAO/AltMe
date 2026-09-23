import 'package:altme/app/shared/constants/secure_storage_keys.dart';
import 'package:altme/app/shared/enum/enum.dart';
import 'package:altme/app/shared/message_handler/message_handler.dart';
import 'package:altme/app/shared/wallet_provider/wallet_attestation_provider.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

/// The enterprise wallet provider's client attestation scheme.
///
/// The attestation is fetched once, when the enterprise account is
/// configured, and kept in secure storage. Each request then gets a freshly
/// minted proof of possession bound to the credential issuer it is going to.
///
/// This is today's `clientSecretJwt` behaviour, moved here unchanged and behind
/// an interface. The per-request values it needs — the DID that signs the proof
/// and the key to sign it with — are supplied at construction rather than per
/// call, because the caller has already computed them by the time it needs an
/// attestation, and recomputing them here would be both wasteful and a chance
/// to get a different answer.
class LegacyWalletAttestationProvider implements WalletAttestationProvider {
  /// Creates a provider over the current request's signing context.
  const LegacyWalletAttestationProvider({
    required this.secureStorageProvider,
    required this.walletType,
    required this.did,
    required this.tokenParameters,
  });

  /// How long a proof of possession stays valid.
  static const int proofOfPossessionLifetimeInSeconds = 60;

  /// How far before issuance the proof of possession becomes valid, absorbing
  /// clock skew between the wallet and the authorization server.
  static const int proofOfPossessionBackdateInSeconds = 10;

  /// Where the attestation was stored when the account was configured.
  final SecureStorageProvider secureStorageProvider;

  /// The kind of wallet this is.
  ///
  /// Only an enterprise wallet has an attestation to present: a personal wallet
  /// never had one configured, and asking for one is a programming error rather
  /// than an empty result.
  final WalletType walletType;

  /// The DID that issues the proof of possession.
  final String did;

  /// The key material the proof of possession is signed with.
  final TokenParameters tokenParameters;

  /// [issuerMetadata] is ignored: the enterprise scheme publishes nothing in
  /// the credential issuer's metadata and reads nothing out of it.
  @override
  Future<ClientAttestationPair?> attestationFor({
    required String credentialIssuer,
    Map<String, dynamic>? issuerMetadata,
  }) async {
    if (walletType != WalletType.enterprise) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Please switch to enterprise account',
        },
      );
    }

    final walletAttestationData = await secureStorageProvider.get(
      SecureStorageKeys.walletAttestationData,
    );

    final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final nbf = iat - proofOfPossessionBackdateInSeconds;

    final payload = {
      'iss': did,
      'aud': credentialIssuer,
      'nbf': nbf,
      'exp': nbf + proofOfPossessionLifetimeInSeconds,
      'jti': const Uuid().v4(),
    };

    final jwtProofOfPossession = generateToken(
      payload: payload,
      tokenParameters: tokenParameters,
      ignoreProofHeaderType: true,
    );

    return ClientAttestationPair(
      attestation: walletAttestationData,
      proofOfPossession: jwtProofOfPossession,
    );
  }

  /// Always `null`: this wallet provider does not attest credential-binding
  /// keys, so credential requests carry no key proofs.
  @override
  Future<List<String>?> keyAttestationProofsFor({
    required String credentialIssuer,
    required String cNonce,
    required int batchSize,
    String? credentialConfigurationId,
    Map<String, dynamic>? issuerMetadata,
  }) async => null;

  /// Does nothing: with no key attestations to spend there is no single-use
  /// bookkeeping to keep.
  @override
  Future<void> markKeyAttestationsConsumed({
    required String credentialIssuer,
  }) async {}
}
