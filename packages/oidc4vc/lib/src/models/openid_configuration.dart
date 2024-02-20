import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'openid_configuration.g.dart';

@JsonSerializable()
class OpenIdConfiguration extends Equatable {
  const OpenIdConfiguration({
    this.authorizationServer,
    this.credentialsSupported,
    this.credentialConfigurationsSupported,
    this.credentialEndpoint,
    this.credentialIssuer,
    this.subjectSyntaxTypesSupported,
    this.tokenEndpoint,
    this.batchEndpoint,
    this.authorizationEndpoint,
    this.subjectTrustFrameworksSupported,
    this.deferredCredentialEndpoint,
    this.serviceDocumentation,
    this.credentialManifest,
    this.credentialManifests,
    this.issuer,
    this.jwksUri,
  });

  factory OpenIdConfiguration.fromJson(Map<String, dynamic> json) =>
      _$OpenIdConfigurationFromJson(json);

  @JsonKey(name: 'authorization_server')
  final String? authorizationServer;
  @JsonKey(name: 'credential_endpoint')
  final String? credentialEndpoint;
  @JsonKey(name: 'credential_issuer')
  final String? credentialIssuer;
  @JsonKey(name: 'subject_syntax_types_supported')
  final List<dynamic>? subjectSyntaxTypesSupported;
  @JsonKey(name: 'token_endpoint')
  final String? tokenEndpoint;
  @JsonKey(name: 'batch_endpoint')
  final String? batchEndpoint;
  @JsonKey(name: 'authorization_endpoint')
  final String? authorizationEndpoint;
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

  Map<String, dynamic> toJson() => _$OpenIdConfigurationToJson(this);

  @override
  List<Object?> get props => [
        authorizationServer,
        credentialEndpoint,
        credentialIssuer,
        subjectSyntaxTypesSupported,
        tokenEndpoint,
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
  });

  factory DisplayDetails.fromJson(Map<String, dynamic> json) =>
      _$DisplayDetailsFromJson(json);

  final String? url;
  @JsonKey(name: 'alt_text')
  final String? altText;

  Map<String, dynamic> toJson() => _$DisplayDetailsToJson(this);

  @override
  List<Object?> get props => [
        url,
        altText,
      ];
}
