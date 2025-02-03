// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_person_credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalPersonCredentialModel _$LegalPersonCredentialModelFromJson(
        Map<String, dynamic> json) =>
    LegalPersonCredentialModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$LegalPersonCredentialModelToJson(
        LegalPersonCredentialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
