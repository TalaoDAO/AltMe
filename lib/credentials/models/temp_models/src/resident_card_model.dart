import 'package:altme/credentials/models/author/author.dart';

import 'credential_subject_model.dart';

class ResidentCardModel extends CredentialSubjectModel {
  final String gender;
  final String maritalStatus;
  final String birthPlace;
  final String nationality;
  final String address;
  final String identifier;
  final String familyName;
  final String image;
  final String birthDate;
  final String givenName;

  ResidentCardModel(
      String id,
      this.gender,
      this.maritalStatus,
      String type,
      this.birthPlace,
      this.nationality,
      this.address,
      this.identifier,
      this.familyName,
      this.image,
      Author issuedBy,
      this.birthDate,
      this.givenName)
      : super(id, type, issuedBy);
}
