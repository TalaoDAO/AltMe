// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_credential_subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityCredentialSubjectModel _$IdentityCredentialSubjectModelFromJson(
  Map<String, dynamic> json,
) => IdentityCredentialSubjectModel(
  id: json['id'] as String?,
  type: json['type'],
  issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
);

Map<String, dynamic> _$IdentityCredentialSubjectModelToJson(
  IdentityCredentialSubjectModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'issuedBy': instance.issuedBy?.toJson(),
};
