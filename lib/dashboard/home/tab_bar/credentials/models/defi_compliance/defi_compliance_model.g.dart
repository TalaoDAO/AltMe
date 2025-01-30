// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defi_compliance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefiComplianceModel _$DefiComplianceModelFromJson(Map<String, dynamic> json) =>
    DefiComplianceModel(
      expires: json['expires'] as String? ?? '',
      ageCheck: json['ageCheck'] as String? ?? '',
      amlComplianceCheck: json['amlComplianceCheck'] as String? ?? '',
      sanctionListCheck: json['sanctionListCheck'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$DefiComplianceModelToJson(
        DefiComplianceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'expires': instance.expires,
      'ageCheck': instance.ageCheck,
      'amlComplianceCheck': instance.amlComplianceCheck,
      'sanctionListCheck': instance.sanctionListCheck,
    };
