import 'package:altme/credentials/credential.dart';

import 'credential_subject_model.dart';

class LoyaltyCardModel extends CredentialSubjectModel {
  final String address;
  final String familyName;
  final String birthDate;
  final String givenName;
  final String programName;
  final String telephone;
  final String email;

  LoyaltyCardModel(
    String id,
    String type,
    this.address,
    this.familyName,
    Author issuedBy,
    this.birthDate,
    this.givenName,
    this.programName,
    this.telephone,
    this.email,
  ) : super(id, type, issuedBy);
}
