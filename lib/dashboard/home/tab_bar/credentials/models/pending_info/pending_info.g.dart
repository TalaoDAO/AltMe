// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingInfo _$PendingInfoFromJson(Map<String, dynamic> json) => PendingInfo(
  encodedCredentialFromOIDC4VC:
      json['encodedCredentialFromOIDC4VC'] as Map<String, dynamic>,
  accessToken: json['accessToken'] as String,
  deferredCredentialEndpoint: json['deferredCredentialEndpoint'] as String,
  format: json['format'] as String,
  url: json['url'] as String,
  issuer: json['issuer'] as String?,
  requestedAt: json['requestedAt'] == null
      ? null
      : DateTime.parse(json['requestedAt'] as String),
);

Map<String, dynamic> _$PendingInfoToJson(PendingInfo instance) =>
    <String, dynamic>{
      'encodedCredentialFromOIDC4VC': instance.encodedCredentialFromOIDC4VC,
      'accessToken': instance.accessToken,
      'deferredCredentialEndpoint': instance.deferredCredentialEndpoint,
      'format': instance.format,
      'url': instance.url,
      'issuer': instance.issuer,
      'requestedAt': instance.requestedAt?.toIso8601String(),
    };
