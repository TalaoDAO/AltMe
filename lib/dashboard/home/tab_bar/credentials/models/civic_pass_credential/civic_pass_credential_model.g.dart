// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'civic_pass_credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CivicPassCredentialModel _$CivicPassCredentialModelFromJson(
        Map<String, dynamic> json) =>
    CivicPassCredentialModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$CivicPassCredentialModelToJson(
        CivicPassCredentialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
