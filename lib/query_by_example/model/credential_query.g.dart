// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialQuery _$CredentialQueryFromJson(Map<String, dynamic> json) =>
    CredentialQuery(
      reason: json['reason'] as String?,
      example: json['example'] == null
          ? null
          : Example.fromJson(json['example'] as Map<String, dynamic>),
      required: json['required'] as bool?,
    );

Map<String, dynamic> _$CredentialQueryToJson(CredentialQuery instance) =>
    <String, dynamic>{
      'example': instance.example?.toJson(),
      'reason': instance.reason,
      'required': instance.required,
    };
