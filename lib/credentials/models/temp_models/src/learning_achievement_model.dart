import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/temp_models/src/credential_subject_model.dart';

import 'has_credential_model.dart';

class LearningAchievementModel extends CredentialSubjectModel {
  String familyName;
  String givenName;
  String email;
  String birthDate;
  HasCredentialModel hasCredential;

  LearningAchievementModel(
      String id,
      String type,
      this.familyName,
      this.givenName,
      this.email,
      this.birthDate,
      this.hasCredential,
      Author issuedBy)
      : super(id, type, issuedBy);
}
