import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'openid_configuration.g.dart';

@JsonSerializable()
class OpenIdConfiguration extends Equatable {
  const OpenIdConfiguration({
    required this.requirePushedAuthorizationRequests,
    this.authorizationServer,
    this.authorizationServers,
    this.credentialsSupported,
    this.credentialConfigurationsSupported,
    this.credentialEndpoint,
    this.pushedAuthorizationRequestEndpoint,
    this.credentialIssuer,
    this.display,
    this.subjectSyntaxTypesSupported,
    this.tokenEndpoint,
    this.nonceEndpoint,
    this.batchEndpoint,
    this.authorizationEndpoint,
    this.subjectTrustFrameworksSupported,
    this.deferredCredentialEndpoint,
    this.serviceDocumentation,
    this.credentialManifest,
    this.credentialManifests,
    this.issuer,
    this.jwksUri,
    this.jwks,
    this.grantTypesSupported,
    this.rawConfiguration,
    this.signedMetadata,
  });

  factory OpenIdConfiguration.fromJson(Map<String, dynamic> json) =>
      _$OpenIdConfigurationFromJson(json);

  @JsonKey(name: 'authorization_server')
  final String? authorizationServer;
  @JsonKey(name: 'authorization_servers')
  final List<String>? authorizationServers;
  @JsonKey(name: 'credential_endpoint')
  final String? credentialEndpoint;
  @JsonKey(name: 'credential_issuer')
  final String? credentialIssuer;
  final List<Display>? display;
  @JsonKey(name: 'subject_syntax_types_supported')
  final List<dynamic>? subjectSyntaxTypesSupported;
  @JsonKey(name: 'token_endpoint')
  final String? tokenEndpoint;
  @JsonKey(name: 'nonce_endpoint')
  final String? nonceEndpoint;
  @JsonKey(name: 'batch_endpoint')
  final String? batchEndpoint;
  @JsonKey(name: 'authorization_endpoint')
  final String? authorizationEndpoint;
  @JsonKey(name: 'pushed_authorization_request_endpoint')
  final String? pushedAuthorizationRequestEndpoint;
  @JsonKey(name: 'subject_trust_frameworks_supported')
  final List<dynamic>? subjectTrustFrameworksSupported;
  @JsonKey(name: 'credentials_supported')
  final List<CredentialsSupported>? credentialsSupported;
  @JsonKey(name: 'credential_configurations_supported')
  final dynamic credentialConfigurationsSupported;
  @JsonKey(name: 'deferred_credential_endpoint')
  final String? deferredCredentialEndpoint;
  @JsonKey(name: 'service_documentation')
  final String? serviceDocumentation;
  @JsonKey(name: 'credential_manifest')
  final CredentialManifest? credentialManifest;
  @JsonKey(name: 'credential_manifests')
  final List<CredentialManifest>? credentialManifests;
  final String? issuer;
  @JsonKey(name: 'jwks_uri')
  final String? jwksUri;
  final Map<String, dynamic>? jwks;
  @JsonKey(name: 'require_pushed_authorization_requests', defaultValue: false)
  final bool requirePushedAuthorizationRequests;
  @JsonKey(name: 'grant_types_supported')
  final List<String>? grantTypesSupported;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, dynamic>? rawConfiguration;
  @JsonKey(name: 'signed_metadata')
  final String? signedMetadata;

  Map<String, dynamic> toJson() => _$OpenIdConfigurationToJson(this);

  OpenIdConfiguration copyWith({
    bool? requirePushedAuthorizationRequests,
    String? authorizationServer,
    List<String>? authorizationServers,
    List<CredentialsSupported>? credentialsSupported,
    dynamic credentialConfigurationsSupported,
    String? credentialEndpoint,
    String? pushedAuthorizationRequestEndpoint,
    String? credentialIssuer,
    List<Display>? display,
    List<dynamic>? subjectSyntaxTypesSupported,
    String? tokenEndpoint,
    String? nonceEndpoint,
    String? batchEndpoint,
    String? authorizationEndpoint,
    List<dynamic>? subjectTrustFrameworksSupported,
    String? deferredCredentialEndpoint,
    String? serviceDocumentation,
    CredentialManifest? credentialManifest,
    List<CredentialManifest>? credentialManifests,
    String? issuer,
    String? jwksUri,
    Map<String, dynamic>? jwks,
    List<String>? grantTypesSupported,
    Map<String, dynamic>? rawConfiguration,
    String? signedMetadata,
  }) {
    return OpenIdConfiguration(
      requirePushedAuthorizationRequests: requirePushedAuthorizationRequests ??
          this.requirePushedAuthorizationRequests,
      authorizationServer: authorizationServer ?? this.authorizationServer,
      authorizationServers: authorizationServers ?? this.authorizationServers,
      credentialsSupported: credentialsSupported ?? this.credentialsSupported,
      credentialConfigurationsSupported: credentialConfigurationsSupported ??
          this.credentialConfigurationsSupported,
      credentialEndpoint: credentialEndpoint ?? this.credentialEndpoint,
      pushedAuthorizationRequestEndpoint: pushedAuthorizationRequestEndpoint ??
          this.pushedAuthorizationRequestEndpoint,
      credentialIssuer: credentialIssuer ?? this.credentialIssuer,
      display: display ?? this.display,
      subjectSyntaxTypesSupported:
          subjectSyntaxTypesSupported ?? this.subjectSyntaxTypesSupported,
      tokenEndpoint: tokenEndpoint ?? this.tokenEndpoint,
      nonceEndpoint: nonceEndpoint ?? this.nonceEndpoint,
      batchEndpoint: batchEndpoint ?? this.batchEndpoint,
      authorizationEndpoint:
          authorizationEndpoint ?? this.authorizationEndpoint,
      subjectTrustFrameworksSupported: subjectTrustFrameworksSupported ??
          this.subjectTrustFrameworksSupported,
      deferredCredentialEndpoint:
          deferredCredentialEndpoint ?? this.deferredCredentialEndpoint,
      serviceDocumentation: serviceDocumentation ?? this.serviceDocumentation,
      credentialManifest: credentialManifest ?? this.credentialManifest,
      credentialManifests: credentialManifests ?? this.credentialManifests,
      issuer: issuer ?? this.issuer,
      jwksUri: jwksUri ?? this.jwksUri,
      jwks: jwks ?? this.jwks,
      grantTypesSupported: grantTypesSupported ?? this.grantTypesSupported,
      rawConfiguration: rawConfiguration ?? this.rawConfiguration,
      signedMetadata: signedMetadata ?? this.signedMetadata,
    );
  }

  @override
  List<Object?> get props => [
        authorizationServer,
        authorizationServers,
        credentialEndpoint,
        credentialIssuer,
        display,
        subjectSyntaxTypesSupported,
        tokenEndpoint,
        nonceEndpoint,
        batchEndpoint,
        authorizationEndpoint,
        subjectTrustFrameworksSupported,
        credentialsSupported,
        credentialConfigurationsSupported,
        deferredCredentialEndpoint,
        serviceDocumentation,
        credentialManifest,
        credentialManifests,
        issuer,
        jwksUri,
        jwks,
        requirePushedAuthorizationRequests,
        grantTypesSupported,
        rawConfiguration,
        signedMetadata,
      ];
}

@JsonSerializable()
class CredentialsSupported extends Equatable {
  const CredentialsSupported({
    this.display,
    this.format,
    this.trustFramework,
    this.types,
    this.id,
    this.scope,
    this.credentialSubject,
  });

  factory CredentialsSupported.fromJson(Map<String, dynamic> json) =>
      _$CredentialsSupportedFromJson(json);

  final List<Display>? display;
  final String? format;
  @JsonKey(name: 'trust_framework')
  final TrustFramework? trustFramework;
  final List<String>? types;
  final String? id;
  final String? scope;
  final dynamic credentialSubject;

  Map<String, dynamic> toJson() => _$CredentialsSupportedToJson(this);

  @override
  List<Object?> get props => [
        display,
        format,
        trustFramework,
        types,
        id,
        scope,
        credentialSubject,
      ];
}

@JsonSerializable()
class TrustFramework extends Equatable {
  const TrustFramework({
    this.name,
    this.type,
    this.uri,
  });

  factory TrustFramework.fromJson(Map<String, dynamic> json) =>
      _$TrustFrameworkFromJson(json);

  final String? name;
  final String? type;
  final String? uri;

  Map<String, dynamic> toJson() => _$TrustFrameworkToJson(this);

  @override
  List<Object?> get props => [
        name,
        type,
        uri,
      ];
}

@JsonSerializable()
class Display extends Equatable {
  const Display({
    this.locale,
    this.name,
    this.description,
    this.textColor,
    this.backgroundColor,
    this.backgroundImage,
    this.logo,
  });

  factory Display.fromJson(Map<String, dynamic> json) =>
      _$DisplayFromJson(json);

  final String? locale;
  final String? name;
  final String? description;
  @JsonKey(name: 'text_color')
  final String? textColor;
  @JsonKey(name: 'background_color')
  final String? backgroundColor;
  @JsonKey(name: 'background_image')
  final DisplayDetails? backgroundImage;
  final DisplayDetails? logo;

  Map<String, dynamic> toJson() => _$DisplayToJson(this);

  @override
  List<Object?> get props => [
        locale,
        name,
        description,
        textColor,
        backgroundColor,
        backgroundImage,
        logo,
      ];
}

@JsonSerializable()
class DisplayDetails extends Equatable {
  const DisplayDetails({
    this.url,
    this.altText,
    this.uri,
  });

  factory DisplayDetails.fromJson(Map<String, dynamic> json) =>
      _$DisplayDetailsFromJson(json);

  final String? url;
  @JsonKey(name: 'alt_text')
  final String? altText;
  final String? uri;

  Map<String, dynamic> toJson() => _$DisplayDetailsToJson(this);

  @override
  List<Object?> get props => [
        url,
        altText,
        uri,
      ];
}
