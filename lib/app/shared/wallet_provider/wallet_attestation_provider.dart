import 'package:equatable/equatable.dart';

/// The `OAuth-Client-Attestation` and `OAuth-Client-Attestation-PoP` header
/// values a wallet presents to an OpenID4VCI Authorization Server.
///
/// Both halves are nullable because that is what the call site they feed
/// already accepts: `oidc4vc` takes each as a `String?` and omits the header
/// when it is null. A wallet that holds an attestation but cannot build a proof
/// of possession — or the reverse — must be able to say so without the type
/// system forcing an invented value.
class ClientAttestationPair extends Equatable {
  /// Creates an attestation pair.
  const ClientAttestationPair({this.attestation, this.proofOfPossession});

  /// The `OAuth-Client-Attestation` header value.
  final String? attestation;

  /// The `OAuth-Client-Attestation-PoP` header value.
  final String? proofOfPossession;

  @override
  List<Object?> get props => [attestation, proofOfPossession];
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
  Future<ClientAttestationPair?> attestationFor({
    required String credentialIssuer,
  });

  /// Key attestation proofs covering [batchSize] fresh credential-binding keys,
  /// or `null` when this wallet does not attest its keys.
  ///
  /// [cNonce] is the nonce the credential issuer supplied for this
  /// issuance, and the returned proofs are bound to it. A wallet with no key
  /// attestation scheme returns `null`, and its credential requests then
  /// carry no key proofs.
  Future<List<String>?> keyAttestationProofsFor({
    required String credentialIssuer,
    required String cNonce,
    required int batchSize,
  });
}
