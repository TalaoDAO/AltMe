import 'package:oidc4vc/oidc4vc.dart';

class Oidc4vcParameters {
  const Oidc4vcParameters({
    required this.oidc4vciDraftType,
    required this.useOAuthAuthorizationServerLink,
    required this.initialUri,
    required this.userPinRequired,
    required this.issuerState,
    this.walletClientMetadata = const {},
    this.issuer = '',
    this.credentialOffer = const {},
    this.issuerOpenIdConfiguration =
        const OpenIdConfiguration(requirePushedAuthorizationRequests: false),
    this.authorizationServerOpenIdConfiguration =
        const OpenIdConfiguration(requirePushedAuthorizationRequests: false),
    this.authorizationEndpoint = '',
    this.tokenEndpoint = '',
    this.nonceEndpoint = '',
    this.oidc4vcType,
    this.preAuthorizedCode,
    this.txCode,
  });

  final Map<String, dynamic> walletClientMetadata;
  final String issuer;
  final Map<String, dynamic> credentialOffer;
  final OpenIdConfiguration issuerOpenIdConfiguration;
  final OpenIdConfiguration authorizationServerOpenIdConfiguration;
  final String authorizationEndpoint;
  final String tokenEndpoint;
  final String nonceEndpoint;
  final OIDC4VCType? oidc4vcType;
  final String? preAuthorizedCode;
  final OIDC4VCIDraftType oidc4vciDraftType;
  final bool useOAuthAuthorizationServerLink;
  final Uri initialUri;
  final bool userPinRequired;
  final TxCode? txCode;
  final String? issuerState;

  Oidc4vcParameters copyWith({
    Map<String, dynamic>? walletClientMetadata,
    String? issuer,
    Map<String, dynamic>? credentialOffer,
    OpenIdConfiguration? issuerOpenIdConfiguration,
    OpenIdConfiguration? authorizationServerOpenIdConfiguration,
    String? authorizationEndpoint,
    String? tokenEndpoint,
    OIDC4VCType? oidc4vcType,
    String? preAuthorizedCode,
    TxCode? txCode,
    String? nonceEndpoint,
  }) {
    return Oidc4vcParameters(
      oidc4vciDraftType: oidc4vciDraftType,
      useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
      initialUri: initialUri,
      walletClientMetadata: walletClientMetadata ?? this.walletClientMetadata,
      issuer: issuer ?? this.issuer,
      credentialOffer: credentialOffer ?? this.credentialOffer,
      issuerOpenIdConfiguration:
          issuerOpenIdConfiguration ?? this.issuerOpenIdConfiguration,
      authorizationServerOpenIdConfiguration:
          authorizationServerOpenIdConfiguration ??
              this.authorizationServerOpenIdConfiguration,
      authorizationEndpoint:
          authorizationEndpoint ?? this.authorizationEndpoint,
      tokenEndpoint: tokenEndpoint ?? this.tokenEndpoint,
      oidc4vcType: oidc4vcType ?? this.oidc4vcType,
      userPinRequired: userPinRequired,
      preAuthorizedCode: preAuthorizedCode ?? this.preAuthorizedCode,
      txCode: txCode ?? this.txCode,
      issuerState: issuerState,
      nonceEndpoint: nonceEndpoint ?? this.nonceEndpoint,
    );
  }
}
