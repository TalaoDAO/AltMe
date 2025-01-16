import 'package:oidc4vc/oidc4vc.dart';
import 'package:oidc4vc/src/models/oidc4vc_type.dart';

class Oidc4vcParameters {
  const Oidc4vcParameters({
    required this.oidc4vciDraftType,
    required this.useOAuthAuthorizationServerLink,
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

  Oidc4vcParameters copyWith({
    Map<String, dynamic>? walletClientMetadata,
    String? classIssuer,
    Map<String, dynamic>? classCredentialOffer,
    OpenIdConfiguration? classIssuerOpenIdConfiguration,
    OpenIdConfiguration? classAuthorizationServerOpenIdConfiguration,
    String? classAuthorizationEndpoint,
    String? classTokenEndpoint,
    OIDC4VCType? oidc4vcType,
  }) {
    return Oidc4vcParameters(
      oidc4vciDraftType: oidc4vciDraftType,
      useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
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
    );
  }
}
