// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_range_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgeRangeModel _$AgeRangeModelFromJson(Map<String, dynamic> json) =>
    AgeRangeModel(
      expires: json['expires'] as String? ?? '',
      ageRange: json['ageRange'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$AgeRangeModelToJson(AgeRangeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'expires': instance.expires,
      'ageRange': instance.ageRange,
    };
