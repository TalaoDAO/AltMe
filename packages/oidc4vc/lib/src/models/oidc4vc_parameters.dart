import 'package:oidc4vc/oidc4vc.dart';

class Oidc4vcParameters {
  const Oidc4vcParameters({
    required this.oidc4vciDraftType,
    required this.useOAuthAuthorizationServerLink,
    required this.initialUri,
    required this.userPinRequired,
    this.walletClientMetadata = const {},
    this.classIssuer = '',
    this.classCredentialOffer = const {},
    this.classIssuerOpenIdConfiguration =
        const OpenIdConfiguration(requirePushedAuthorizationRequests: false),
    this.classAuthorizationServerOpenIdConfiguration =
        const OpenIdConfiguration(requirePushedAuthorizationRequests: false),
    this.classAuthorizationEndpoint = '',
    this.classTokenEndpoint = '',
    this.oidc4vcType,
    this.preAuthorizedCode,
    this.txCode,
  });

  final Map<String, dynamic> walletClientMetadata;
  final String classIssuer;
  final Map<String, dynamic> classCredentialOffer;
  final OpenIdConfiguration classIssuerOpenIdConfiguration;
  final OpenIdConfiguration classAuthorizationServerOpenIdConfiguration;
  final String classAuthorizationEndpoint;
  final String classTokenEndpoint;
  final OIDC4VCType? oidc4vcType;
  final String? preAuthorizedCode;
  final OIDC4VCIDraftType oidc4vciDraftType;
  final bool useOAuthAuthorizationServerLink;
  final Uri initialUri;
  final bool userPinRequired;
  final TxCode? txCode;

  Oidc4vcParameters copyWith({
    Map<String, dynamic>? walletClientMetadata,
    String? classIssuer,
    Map<String, dynamic>? classCredentialOffer,
    OpenIdConfiguration? classIssuerOpenIdConfiguration,
    OpenIdConfiguration? classAuthorizationServerOpenIdConfiguration,
    String? classAuthorizationEndpoint,
    String? classTokenEndpoint,
    OIDC4VCType? oidc4vcType,
    String? preAuthorizedCode,
    TxCode? txCode,
  }) {
    return Oidc4vcParameters(
      oidc4vciDraftType: oidc4vciDraftType,
      useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
      initialUri: initialUri,
      walletClientMetadata: walletClientMetadata ?? this.walletClientMetadata,
      classIssuer: classIssuer ?? this.classIssuer,
      classCredentialOffer: classCredentialOffer ?? this.classCredentialOffer,
      classIssuerOpenIdConfiguration:
          classIssuerOpenIdConfiguration ?? this.classIssuerOpenIdConfiguration,
      classAuthorizationServerOpenIdConfiguration:
          classAuthorizationServerOpenIdConfiguration ??
              this.classAuthorizationServerOpenIdConfiguration,
      classAuthorizationEndpoint:
          classAuthorizationEndpoint ?? this.classAuthorizationEndpoint,
      classTokenEndpoint: classTokenEndpoint ?? this.classTokenEndpoint,
      oidc4vcType: oidc4vcType ?? this.oidc4vcType,
      userPinRequired: userPinRequired,
      preAuthorizedCode: preAuthorizedCode ?? this.preAuthorizedCode,
      txCode: txCode ?? this.txCode,
    );
  }
}
