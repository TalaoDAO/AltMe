// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc4vci_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Oidc4VCIState _$Oidc4VCIStateFromJson(Map<String, dynamic> json) =>
    Oidc4VCIState(
      codeVerifier: json['codeVerifier'] as String,
      challenge: json['challenge'] as String,
      selectedCredentials: json['selectedCredentials'] as List<dynamic>,
      issuer: json['issuer'] as String,
      isEBSI: json['isEBSI'] as bool,
      publicKeyForDPo: json['publicKeyForDPo'] as String,
      oidc4vciDraft: json['oidc4vciDraft'] as String,
      tokenEndpoint: json['tokenEndpoint'] as String,
      authorizationServer: json['authorizationServer'] as String?,
      authorization: json['authorization'] as String?,
      clientId: json['clientId'] as String?,
      clientSecret: json['clientSecret'] as String?,
      oAuthClientAttestation: json['oAuthClientAttestation'] as String?,
      oAuthClientAttestationPop: json['oAuthClientAttestationPop'] as String?,
      dpop: json['dpop'] as bool? ?? false,
      clientAuthentication: $enumDecodeNullable(
        _$ClientAuthenticationEnumMap,
        json['clientAuthentication'],
      ),
    );

Map<String, dynamic> _$Oidc4VCIStateToJson(Oidc4VCIState instance) =>
    <String, dynamic>{
      'codeVerifier': instance.codeVerifier,
      'challenge': instance.challenge,
      'selectedCredentials': instance.selectedCredentials,
      'issuer': instance.issuer,
      'isEBSI': instance.isEBSI,
      'publicKeyForDPo': instance.publicKeyForDPo,
      'oidc4vciDraft': instance.oidc4vciDraft,
      'tokenEndpoint': instance.tokenEndpoint,
      'authorizationServer': instance.authorizationServer,
      'authorization': instance.authorization,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'oAuthClientAttestation': instance.oAuthClientAttestation,
      'oAuthClientAttestationPop': instance.oAuthClientAttestationPop,
      'dpop': instance.dpop,
      'clientAuthentication':
          _$ClientAuthenticationEnumMap[instance.clientAuthentication],
    };

const _$ClientAuthenticationEnumMap = {
  ClientAuthentication.none: 'none',
  ClientAuthentication.clientSecretBasic: 'client_secret_basic',
  ClientAuthentication.clientSecretPost: 'client_secret_post',
  ClientAuthentication.clientId: 'client_id',
  ClientAuthentication.clientSecretJwt: 'client_secret_jwt',
  ClientAuthentication.wia: 'wia',
};
