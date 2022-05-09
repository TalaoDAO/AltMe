import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/temp_models/src/signature_model.dart';
import 'package:altme/credentials/models/temp_models/src/skill_model.dart';

import 'credential_subject_model.dart';

class ProfessionalSkillAssessmentModel extends CredentialSubjectModel {
  final List<SkillModel> skills;
  final String familyName;
  final String givenName;
  final List<SignatureModel> signatureLines;

  ProfessionalSkillAssessmentModel(String id, String type, this.skills,
      Author issuedBy, this.signatureLines, this.familyName, this.givenName)
      : super(id, type, issuedBy);
}
