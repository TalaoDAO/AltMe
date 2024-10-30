// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationInfo _$OrganizationInfoFromJson(Map<String, dynamic> json) =>
    OrganizationInfo(
      id: json['id'] as String? ?? '',
      legalName: json['legalName'] as String? ?? '',
      currentAddress: json['currentAddress'] as String? ?? '',
      website: json['website'] as String? ?? '',
      issuerDomain: (json['issuerDomain'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$OrganizationInfoToJson(OrganizationInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'legalName': instance.legalName,
      'currentAddress': instance.currentAddress,
      'website': instance.website,
      'issuerDomain': instance.issuerDomain,
    };
