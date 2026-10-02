import 'package:equatable/equatable.dart';

/// The `OAuth-Client-Attestation` and `OAuth-Client-Attestation-PoP` header
/// values a wallet presents to an OpenID4VCI Authorization Server, with the
/// OAuth `client_id` they authenticate.
///
/// All three halves are nullable because that is what the call site they feed
/// already accepts: `oidc4vc` takes each as a `String?` and omits the header
/// when it is null. A wallet that holds an attestation but cannot build a proof
/// of possession — or the reverse — must be able to say so without the type
/// system forcing an invented value.
class ClientAttestationPair extends Equatable {
  /// Creates an attestation pair.
  const ClientAttestationPair({
    this.attestation,
    this.proofOfPossession,
    this.clientId,
  });

  /// The `OAuth-Client-Attestation` header value.
  final String? attestation;

  /// The `OAuth-Client-Attestation-PoP` header value.
  final String? proofOfPossession;

  /// The OAuth `client_id` this attestation authenticates, when the attestation
  /// scheme is the one that decides it.
  ///
  /// The Wallet Provider Protocol assigns the identifier rather than letting
  /// the wallet pick one: §3 makes `client_id` the `sub` claim of the Wallet
  /// Instance Attestation, and the Authorization Server rejects a request whose
  /// `client_id` does not equal it (§8). A scheme that leaves the identifier to
  /// the caller — the enterprise wallet provider uses the wallet's DID —
  /// answers `null` here and the caller keeps what it had.
  final String? clientId;

  @override
  List<Object?> get props => [attestation, proofOfPossession, clientId];
}

/// Proofs covering a batch of fresh credential-binding keys (Wallet Provider
/// Protocol §12.10), together with the local handle of each key.
///
/// [keyIds] is in the same order the issuer's batch credential request
/// expects: `keyIds[i]` is the key the i-th credential of the batch ends up
/// bound to, so it is also the key a presentation of that credential must
/// sign its Key Binding JWT with. A wallet that does not attest its own keys
/// has no handle to give — see
/// [WalletAttestationProvider.keyAttestationProofsFor].
class KeyAttestationProofs extends Equatable {
  /// Creates a key attestation proofs value.
  const KeyAttestationProofs({required this.proofs, required this.keyIds});

  /// The proof(s) sent as `proofs.attestation` in the Credential Request.
  final List<String> proofs;

  /// The local key-store handle of each credential-binding key the proof(s)
  /// cover.
  final List<String> keyIds;

  @override
  List<Object?> get props => [proofs, keyIds];
}

/// Where a wallet gets the attestations it presents to a credential issuer.
///
/// The seam between the wallet's OpenID4VCI code and whatever scheme its
/// wallet provider uses. The enterprise wallet provider answers with a stored
/// attestation and a locally built proof of possession; another wallet provider
/// may run a whole protocol behind this interface. Neither is visible to the
/// caller, which is the point: `getClientDetails` asks for an attestation and
/// does not know how one is obtained.
abstract class WalletAttestationProvider {
  /// The client attestation pair for [credentialIssuer], or `null` when this
  /// wallet presents no client attestation.
  ///
  /// [credentialIssuer] is the audience the proof of possession is bound
  /// to, so a pair obtained for one issuer is never returned for another.
  ///
  /// [issuerMetadata] is the credential issuer's own OpenID4VCI metadata
  /// document, when the caller has already fetched it. It is passed as the
  /// decoded JSON rather than a parsed model because what a scheme reads out of
  /// it is the scheme's business: the Wallet Provider Protocol reads
  /// `preferred_client_status_period` (§9) to decide whether a cached
  /// attestation is still good enough, and the enterprise scheme reads nothing
  /// at all.
  Future<ClientAttestationPair?> attestationFor({
    required String credentialIssuer,
    Map<String, dynamic>? issuerMetadata,
  });

  /// Key attestation proofs covering [batchSize] fresh credential-binding keys,
  /// or `null` when this wallet does not attest its keys.
  ///
  /// [cNonce] is the nonce the credential issuer supplied for this
  /// issuance, and the returned proofs are bound to it. A wallet with no key
  /// attestation scheme returns `null`, and its credential requests then
  /// carry no key proofs.
  ///
  /// [issuerMetadata] carries the same document as
  /// [attestationFor], and [credentialConfigurationId] names the entry of it
  /// this issuance is for. The Wallet Provider Protocol reads
  /// `preferred_key_storage_status_period` and, per credential configuration,
  /// the key-storage requirements out of them (§12.4).
  Future<KeyAttestationProofs?> keyAttestationProofsFor({
    required String credentialIssuer,
    required String cNonce,
    required int batchSize,
    String? credentialConfigurationId,
    Map<String, dynamic>? issuerMetadata,
  });

  /// Reports that the issuance which presented this wallet's key attestations
  /// for [credentialIssuer] has finished.
  ///
  /// Called once per issuance attempt, whether it succeeded or failed: a key
  /// attestation is spent on the attempt, not on the outcome. A wallet with no
  /// key attestation scheme has nothing to record, so the default does nothing
  /// and the enterprise scheme inherits it unchanged.
  Future<void> markKeyAttestationsConsumed({
    required String credentialIssuer,
  }) async {}
}
