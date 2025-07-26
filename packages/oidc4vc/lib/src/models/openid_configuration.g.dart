// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openid_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenIdConfiguration _$OpenIdConfigurationFromJson(Map<String, dynamic> json) =>
    OpenIdConfiguration(
      requirePushedAuthorizationRequests:
          json['require_pushed_authorization_requests'] as bool? ?? false,
      authorizationServer: json['authorization_server'] as String?,
      authorizationServers: (json['authorization_servers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      credentialsSupported: (json['credentials_supported'] as List<dynamic>?)
          ?.map((e) => CredentialsSupported.fromJson(e as Map<String, dynamic>))
          .toList(),
      credentialConfigurationsSupported:
          json['credential_configurations_supported'],
      credentialEndpoint: json['credential_endpoint'] as String?,
      pushedAuthorizationRequestEndpoint:
          json['pushed_authorization_request_endpoint'] as String?,
      credentialIssuer: json['credential_issuer'] as String?,
      display: (json['display'] as List<dynamic>?)
          ?.map((e) => Display.fromJson(e as Map<String, dynamic>))
          .toList(),
      subjectSyntaxTypesSupported:
          json['subject_syntax_types_supported'] as List<dynamic>?,
      tokenEndpoint: json['token_endpoint'] as String?,
      nonceEndpoint: json['nonce_endpoint'] as String?,
      batchEndpoint: json['batch_endpoint'] as String?,
      authorizationEndpoint: json['authorization_endpoint'] as String?,
      subjectTrustFrameworksSupported:
          json['subject_trust_frameworks_supported'] as List<dynamic>?,
      deferredCredentialEndpoint:
          json['deferred_credential_endpoint'] as String?,
      serviceDocumentation: json['service_documentation'] as String?,
      credentialManifest: json['credential_manifest'] == null
          ? null
          : CredentialManifest.fromJson(
              json['credential_manifest'] as Map<String, dynamic>),
      credentialManifests: (json['credential_manifests'] as List<dynamic>?)
          ?.map((e) => CredentialManifest.fromJson(e as Map<String, dynamic>))
          .toList(),
      issuer: json['issuer'] as String?,
      jwksUri: json['jwks_uri'] as String?,
      jwks: json['jwks'] as Map<String, dynamic>?,
      grantTypesSupported: (json['grant_types_supported'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      signedMetadata: json['signed_metadata'] as String?,
    );

Map<String, dynamic> _$OpenIdConfigurationToJson(
        OpenIdConfiguration instance) =>
    <String, dynamic>{
      'authorization_server': instance.authorizationServer,
      'authorization_servers': instance.authorizationServers,
      'credential_endpoint': instance.credentialEndpoint,
      'credential_issuer': instance.credentialIssuer,
      'display': instance.display,
      'subject_syntax_types_supported': instance.subjectSyntaxTypesSupported,
      'token_endpoint': instance.tokenEndpoint,
      'nonce_endpoint': instance.nonceEndpoint,
      'batch_endpoint': instance.batchEndpoint,
      'authorization_endpoint': instance.authorizationEndpoint,
      'pushed_authorization_request_endpoint':
          instance.pushedAuthorizationRequestEndpoint,
      'subject_trust_frameworks_supported':
          instance.subjectTrustFrameworksSupported,
      'credentials_supported': instance.credentialsSupported,
      'credential_configurations_supported':
          instance.credentialConfigurationsSupported,
      'deferred_credential_endpoint': instance.deferredCredentialEndpoint,
      'service_documentation': instance.serviceDocumentation,
      'credential_manifest': instance.credentialManifest,
      'credential_manifests': instance.credentialManifests,
      'issuer': instance.issuer,
      'jwks_uri': instance.jwksUri,
      'jwks': instance.jwks,
      'require_pushed_authorization_requests':
          instance.requirePushedAuthorizationRequests,
      'grant_types_supported': instance.grantTypesSupported,
      'signed_metadata': instance.signedMetadata,
    };

CredentialsSupported _$CredentialsSupportedFromJson(
        Map<String, dynamic> json) =>
    CredentialsSupported(
      display: (json['display'] as List<dynamic>?)
          ?.map((e) => Display.fromJson(e as Map<String, dynamic>))
          .toList(),
      format: json['format'] as String?,
      trustFramework: json['trust_framework'] == null
          ? null
          : TrustFramework.fromJson(
              json['trust_framework'] as Map<String, dynamic>),
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
      id: json['id'] as String?,
      scope: json['scope'] as String?,
      credentialSubject: json['credentialSubject'],
    );

Map<String, dynamic> _$CredentialsSupportedToJson(
        CredentialsSupported instance) =>
    <String, dynamic>{
      'display': instance.display,
      'format': instance.format,
      'trust_framework': instance.trustFramework,
      'types': instance.types,
      'id': instance.id,
      'scope': instance.scope,
      'credentialSubject': instance.credentialSubject,
    };

TrustFramework _$TrustFrameworkFromJson(Map<String, dynamic> json) =>
    TrustFramework(
      name: json['name'] as String?,
      type: json['type'] as String?,
      uri: json['uri'] as String?,
    );

Map<String, dynamic> _$TrustFrameworkToJson(TrustFramework instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'uri': instance.uri,
    };

Display _$DisplayFromJson(Map<String, dynamic> json) => Display(
      locale: json['locale'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      textColor: json['text_color'] as String?,
      backgroundColor: json['background_color'] as String?,
      backgroundImage: json['background_image'] == null
          ? null
          : DisplayDetails.fromJson(
              json['background_image'] as Map<String, dynamic>),
      logo: json['logo'] == null
          ? null
          : DisplayDetails.fromJson(json['logo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DisplayToJson(Display instance) => <String, dynamic>{
      'locale': instance.locale,
      'name': instance.name,
      'description': instance.description,
      'text_color': instance.textColor,
      'background_color': instance.backgroundColor,
      'background_image': instance.backgroundImage,
      'logo': instance.logo,
    };

DisplayDetails _$DisplayDetailsFromJson(Map<String, dynamic> json) =>
    DisplayDetails(
      url: json['url'] as String?,
      altText: json['alt_text'] as String?,
      uri: json['uri'] as String?,
    );

Map<String, dynamic> _$DisplayDetailsToJson(DisplayDetails instance) =>
    <String, dynamic>{
      'url': instance.url,
      'alt_text': instance.altText,
      'uri': instance.uri,
    };
