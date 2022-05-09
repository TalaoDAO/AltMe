import 'package:altme/credentials/models/author/author.dart';

import '../index.dart';

class ProfessionalExperienceAssessmentModel extends CredentialSubjectModel {
  final List<SkillModel> skills;
  final String title;
  final String description;
  final String familyName;
  final String givenName;
  final String endDate;
  final String startDate;
  final String expires;
  final String email;
  final List<ReviewModel> review;
  final List<SignatureModel> signatureLines;

  ProfessionalExperienceAssessmentModel(
      this.expires,
      this.email,
      String id,
      String type,
      this.skills,
      this.title,
      this.endDate,
      this.startDate,
      Author issuedBy,
      this.review,
      this.signatureLines,
      this.familyName,
      this.givenName,
      this.description)
      : super(id, type, issuedBy);
}
