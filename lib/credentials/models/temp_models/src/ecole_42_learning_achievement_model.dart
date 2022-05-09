import 'package:altme/credentials/models/author/author.dart';

import 'credential_subject_model.dart';
import 'has_credential_ecole_42.dart';
import 'signature_model.dart';

class Ecole42LearningAchievementModel extends CredentialSubjectModel {
  final String givenName;
  final SignatureModel signatureLines;
  final String birthDate;

  HasCredentialEcole42Model hasCredential;
  final String familyName;

  Ecole42LearningAchievementModel(
      String id,
      String type,
      Author issuedBy,
      this.givenName,
      this.signatureLines,
      this.birthDate,
      this.familyName,
      this.hasCredential)
      : super(id, type, issuedBy);
}
