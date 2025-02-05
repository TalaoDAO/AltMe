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
      authorization: json['authorization'] as String?,
      clientId: json['clientId'] as String?,
      clientSecret: json['clientSecret'] as String?,
      oAuthClientAttestation: json['oAuthClientAttestation'] as String?,
      oAuthClientAttestationPop: json['oAuthClientAttestationPop'] as String?,
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
      'authorization': instance.authorization,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'oAuthClientAttestation': instance.oAuthClientAttestation,
      'oAuthClientAttestationPop': instance.oAuthClientAttestationPop,
    };
