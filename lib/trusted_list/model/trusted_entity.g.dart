// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trusted_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrustedEntity _$TrustedEntityFromJson(Map<String, dynamic> json) =>
    TrustedEntity(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      endpoint: json['endpoint'] as String?,
      postalAddress: json['postalAddress'] == null
          ? null
          : PostalAddress.fromJson(
              json['postalAddress'] as Map<String, dynamic>),
      electronicAddress: json['electronicAddress'] == null
          ? null
          : ElectronicAddress.fromJson(
              json['electronicAddress'] as Map<String, dynamic>),
      rootCertificates: (json['rootCertificates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vcTypes:
          (json['vcTypes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TrustedEntityToJson(TrustedEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'endpoint': instance.endpoint,
      'postalAddress': instance.postalAddress?.toJson(),
      'electronicAddress': instance.electronicAddress?.toJson(),
      'rootCertificates': instance.rootCertificates,
      'vcTypes': instance.vcTypes,
    };
