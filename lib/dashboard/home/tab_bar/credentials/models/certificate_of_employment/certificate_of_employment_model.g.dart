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
    CertificateOfEmploymentModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('type', instance.type);
  writeNotNull('issuedBy', instance.issuedBy?.toJson());
  writeNotNull('offeredBy', instance.offeredBy?.toJson());
  writeNotNull('familyName', instance.familyName);
  writeNotNull('givenName', instance.givenName);
  writeNotNull('startDate', instance.startDate);
  writeNotNull('workFor', instance.workFor?.toJson());
  writeNotNull('employmentType', instance.employmentType);
  writeNotNull('jobTitle', instance.jobTitle);
  writeNotNull('baseSalary', instance.baseSalary);
  return val;
}
