// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issuer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Issuer _$IssuerFromJson(Map<String, dynamic> json) => Issuer(
      preferredName: json['preferredName'] as String? ?? '',
      did: (json['did'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      organizationInfo: OrganizationInfo.fromJson(
          json['organizationInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IssuerToJson(Issuer instance) => <String, dynamic>{
      'preferredName': instance.preferredName,
      'did': instance.did,
      'organizationInfo': instance.organizationInfo,
    };
