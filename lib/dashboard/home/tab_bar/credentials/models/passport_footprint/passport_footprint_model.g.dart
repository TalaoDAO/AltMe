// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passport_footprint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassportFootprintModel _$PassportFootprintModelFromJson(
        Map<String, dynamic> json) =>
    PassportFootprintModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$PassportFootprintModelToJson(
        PassportFootprintModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
