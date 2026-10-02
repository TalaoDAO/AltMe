// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_of_employment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateOfEmploymentModel _$CertificateOfEmploymentModelFromJson(
  Map<String, dynamic> json,
) => CertificateOfEmploymentModel(
  id: json['id'] as String?,
  type: json['type'],
  familyName: json['familyName'] as String? ?? '',
  givenName: json['givenName'] as String? ?? '',
  startDate: json['startDate'] as String? ?? '',
  workFor: json['workFor'] == null
      ? null
      : WorkFor.fromJson(json['workFor'] as Map<String, dynamic>),
  employmentType: json['employmentType'] as String? ?? '',
  jobTitle: json['jobTitle'] as String? ?? '',
  baseSalary: json['baseSalary'] as String? ?? '',
  issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
  offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
);

Map<String, dynamic> _$CertificateOfEmploymentModelToJson(
  CertificateOfEmploymentModel instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'type': ?instance.type,
  'issuedBy': ?instance.issuedBy?.toJson(),
  'offeredBy': ?instance.offeredBy?.toJson(),
  'familyName': ?instance.familyName,
  'givenName': ?instance.givenName,
  'startDate': ?instance.startDate,
  'workFor': ?instance.workFor?.toJson(),
  'employmentType': ?instance.employmentType,
  'jobTitle': ?instance.jobTitle,
  'baseSalary': ?instance.baseSalary,
};
