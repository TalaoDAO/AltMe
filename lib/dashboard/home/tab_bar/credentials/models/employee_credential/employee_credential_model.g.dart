// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeCredentialModel _$EmployeeCredentialModelFromJson(
        Map<String, dynamic> json) =>
    EmployeeCredentialModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$EmployeeCredentialModelToJson(
        EmployeeCredentialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
