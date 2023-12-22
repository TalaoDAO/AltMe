import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'openid_configuration.g.dart';

@JsonSerializable()
class OpenIdConfiguration extends Equatable {
  const OpenIdConfiguration({
    this.authorizationServer,
    this.credentialsSupported,
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
    this.issuer,
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
  @JsonKey(name: 'deferred_credential_endpoint')
  final String? deferredCredentialEndpoint;
  @JsonKey(name: 'service_documentation')
  final String? serviceDocumentation;
  @JsonKey(name: 'credential_manifest')
  final CredentialManifest? credentialManifest;
  final String? issuer;

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
        deferredCredentialEndpoint,
        serviceDocumentation,
        credentialManifest,
        issuer,
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
  });

  factory CredentialsSupported.fromJson(Map<String, dynamic> json) =>
      _$CredentialsSupportedFromJson(json);

  final List<dynamic>? display;
  final String? format;
  @JsonKey(name: 'trust_framework')
  final TrustFramework? trustFramework;
  final List<String>? types;
  final String? id;
  final String? scope;

  Map<String, dynamic> toJson() => _$CredentialsSupportedToJson(this);

  @override
  List<Object?> get props => [
        display,
        format,
        trustFramework,
        types,
        id,
        scope,
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
