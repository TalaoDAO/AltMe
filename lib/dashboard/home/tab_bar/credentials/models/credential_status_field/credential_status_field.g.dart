// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_status_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialStatusField _$CredentialStatusFieldFromJson(
        Map<String, dynamic> json) =>
    CredentialStatusField(
      json['id'] as String? ?? '',
      json['type'] as String? ?? '',
      json['revocationListIndex'] as String? ?? '',
      json['revocationListCredential'] as String? ?? '',
      json['statusListCredential'] as String,
      json['statusListIndex'] as String? ?? '',
      json['statusPurpose'] as String? ?? '',
    );

Map<String, dynamic> _$CredentialStatusFieldToJson(
        CredentialStatusField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'revocationListIndex': instance.revocationListIndex,
      'revocationListCredential': instance.revocationListCredential,
      'statusListCredential': instance.statusListCredential,
      'statusListIndex': instance.statusListIndex,
      'statusPurpose': instance.statusPurpose,
    };
