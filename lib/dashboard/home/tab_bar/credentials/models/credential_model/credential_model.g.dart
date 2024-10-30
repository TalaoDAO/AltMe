// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialModel _$CredentialModelFromJson(Map<String, dynamic> json) =>
    CredentialModel(
      id: CredentialModel.fromJsonId(json['id']),
      image: json['image'] as String?,
      credentialPreview: Credential.fromJson(
          json['credentialPreview'] as Map<String, dynamic>),
      shareLink: json['shareLink'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>,
      format: json['format'] as String?,
      display: CredentialModel.fromJsonDisplay(json['display']),
      expirationDate: json['expirationDate'] as String?,
      credentialManifest: CredentialModel.credentialManifestFromJson(
          json['credential_manifest'] as Map<String, dynamic>?),
      receivedId:
          CredentialModel.readValueReceivedId(json, 'receivedId') as String?,
      challenge: json['challenge'] as String?,
      domain: json['domain'] as String?,
      activities: (json['activities'] as List<dynamic>?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      jwt: json['jwt'] as String?,
      selectiveDisclosureJwt: json['selectiveDisclosureJwt'] as String?,
      pendingInfo: json['pendingInfo'] == null
          ? null
          : PendingInfo.fromJson(json['pendingInfo'] as Map<String, dynamic>),
      credentialSupported: json['credentialSupported'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CredentialModelToJson(CredentialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receivedId': instance.receivedId,
      'image': instance.image,
      'data': instance.data,
      'shareLink': instance.shareLink,
      'credentialPreview': instance.credentialPreview.toJson(),
      'display': instance.display?.toJson(),
      'expirationDate': instance.expirationDate,
      'credential_manifest': instance.credentialManifest?.toJson(),
      'challenge': instance.challenge,
      'domain': instance.domain,
      'activities': instance.activities.map((e) => e.toJson()).toList(),
      'jwt': instance.jwt,
      'selectiveDisclosureJwt': instance.selectiveDisclosureJwt,
      'pendingInfo': instance.pendingInfo?.toJson(),
      'format': instance.format,
      'credentialSupported': instance.credentialSupported,
    };
