//TODO remove all temp models

import 'package:altme/credentials/models/author/author.dart';

import 'work_for.dart';

class CertificateOfEmploymentModel {
  String id;
  String type;
  String familyName;
  String givenName;
  String startDate;
  WorkFor workFor;
  String employmentType;
  String jobTitle;
  String baseSalary;
  final Author issuedBy;

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
      this.issuedBy);
}
