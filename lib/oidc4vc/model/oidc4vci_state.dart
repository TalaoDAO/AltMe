import 'package:json_annotation/json_annotation.dart';

part 'oidc4vci_state.g.dart';

@JsonSerializable(explicitToJson: true)
class Oidc4VCIState {
  Oidc4VCIState({
    required this.codeVerifier,
    required this.challenge,
    required this.selectedCredentials,
    required this.issuer,
    required this.isEBSI,
    required this.publicKeyForDPo,
    required this.oidc4vciDraft,
    required this.tokenEndpoint,
    this.authorizationServer,
    this.authorization,
    this.clientId,
    this.clientSecret,
    this.oAuthClientAttestation,
    this.oAuthClientAttestationPop,
  });

  factory Oidc4VCIState.fromJson(Map<String, dynamic> json) =>
      _$Oidc4VCIStateFromJson(json);

  final String codeVerifier;
  final String challenge;
  final List<dynamic> selectedCredentials;
  final String issuer;
  final bool isEBSI;
  final String publicKeyForDPo;
  final String oidc4vciDraft;
  final String tokenEndpoint;

  /// The authorization server's RFC 8414 issuer identifier, discovered
  /// before the browser round trip (e.g. for the PAR). Carried across it so
  /// the token request's client attestation PoP can address its `aud` to
  /// the authorization server rather than falling back to the credential
  /// issuer.
  final String? authorizationServer;
  final String? authorization;
  final String? clientId;
  final String? clientSecret;
  final String? oAuthClientAttestation;
  final String? oAuthClientAttestationPop;

  Map<String, dynamic> toJson() => _$Oidc4VCIStateToJson(this);

  Oidc4VCIState copyWith({
    String? codeVerifier,
    String? challenge,
    List<dynamic>? selectedCredentials,
    String? issuer,
    bool? isEBSI,
    String? publicKeyForDPo,
    String? oidc4vciDraft,
    String? tokenEndpoint,
    String? authorizationServer,
    String? authorization,
    String? clientId,
    String? clientSecret,
    String? oAuthClientAttestation,
    String? oAuthClientAttestationPop,
  }) {
    return Oidc4VCIState(
      codeVerifier: codeVerifier ?? this.codeVerifier,
      challenge: challenge ?? this.challenge,
      selectedCredentials: selectedCredentials ?? this.selectedCredentials,
      issuer: issuer ?? this.issuer,
      isEBSI: isEBSI ?? this.isEBSI,
      publicKeyForDPo: publicKeyForDPo ?? this.publicKeyForDPo,
      oidc4vciDraft: oidc4vciDraft ?? this.oidc4vciDraft,
      tokenEndpoint: tokenEndpoint ?? this.tokenEndpoint,
      authorizationServer: authorizationServer ?? this.authorizationServer,
      authorization: authorization ?? this.authorization,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      oAuthClientAttestation:
          oAuthClientAttestation ?? this.oAuthClientAttestation,
      oAuthClientAttestationPop:
          oAuthClientAttestationPop ?? this.oAuthClientAttestationPop,
    );
  }
}
