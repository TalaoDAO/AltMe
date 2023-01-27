import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/certificate_of_employment/work_for.dart';
import 'package:json_annotation/json_annotation.dart';

part 'certificate_of_employment_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CertificateOfEmploymentModel extends CredentialSubjectModel {
  CertificateOfEmploymentModel({
    super.id,
    super.type,
    this.familyName,
    this.givenName,
    this.startDate,
    this.workFor,
    this.employmentType,
    this.jobTitle,
    this.baseSalary,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.certificateOfEmployment,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory CertificateOfEmploymentModel.fromJson(Map<String, dynamic> json) =>
      _$CertificateOfEmploymentModelFromJson(json);

  @JsonKey(defaultValue: '')
  String? familyName;
  @JsonKey(defaultValue: '')
  String? givenName;
  @JsonKey(defaultValue: '')
  String? startDate;
  WorkFor? workFor;
  @JsonKey(defaultValue: '')
  String? employmentType;
  @JsonKey(defaultValue: '')
  String? jobTitle;
  @JsonKey(defaultValue: '')
  String? baseSalary;

  @override
  Map<String, dynamic> toJson() => _$CertificateOfEmploymentModelToJson(this);
}
