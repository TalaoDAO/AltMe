// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_age_credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KYCAgeCredentialModel _$KYCAgeCredentialModelFromJson(
        Map<String, dynamic> json) =>
    KYCAgeCredentialModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      birthday: (json['birthday'] as num?)?.toInt(),
      documentType: (json['documentType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KYCAgeCredentialModelToJson(
        KYCAgeCredentialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'birthday': instance.birthday,
      'documentType': instance.documentType,
    };
