// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_of_employment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateOfEmploymentModel _$CertificateOfEmploymentModelFromJson(
        Map<String, dynamic> json) =>
    CertificateOfEmploymentModel(
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
        CertificateOfEmploymentModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.type case final value?) 'type': value,
      if (instance.issuedBy?.toJson() case final value?) 'issuedBy': value,
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      if (instance.familyName case final value?) 'familyName': value,
      if (instance.givenName case final value?) 'givenName': value,
      if (instance.startDate case final value?) 'startDate': value,
      if (instance.workFor?.toJson() case final value?) 'workFor': value,
      if (instance.employmentType case final value?) 'employmentType': value,
      if (instance.jobTitle case final value?) 'jobTitle': value,
      if (instance.baseSalary case final value?) 'baseSalary': value,
    };
