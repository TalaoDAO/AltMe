import 'package:altme/app/app.dart';
import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/certificate_of_employment/work_for.dart';
import 'package:json_annotation/json_annotation.dart';

part 'certificate_of_employment.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CertificateOfEmploymentModel {
  CertificateOfEmploymentModel(
    this.id,
    this.type,
    this.familyName,
    this.givenName,
    this.startDate,
    this.workFor,
    this.employmentType,
    this.jobTitle,
    this.baseSalary,
    this.issuedBy,
  );

  factory CertificateOfEmploymentModel.fromJson(Map<String, dynamic> json) =>
      _$CertificateOfEmploymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateOfEmploymentModelToJson(this);

  String id;
  CredentialType type;
  @JsonKey(defaultValue: '')
  String familyName;
  @JsonKey(defaultValue: '')
  String givenName;
  @JsonKey(defaultValue: '')
  String startDate;
  WorkFor workFor;
  @JsonKey(defaultValue: '')
  String employmentType;
  @JsonKey(defaultValue: '')
  String jobTitle;
  @JsonKey(defaultValue: '')
  String baseSalary;
  final Author issuedBy;
}
