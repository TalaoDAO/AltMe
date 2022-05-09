import 'package:altme/credentials/models/author/author.dart';

import 'credential_subject_model.dart';
import 'professional_student_card_recipient_model.dart';

class ProfessionalStudentCardModel extends CredentialSubjectModel {
  final ProfessionalStudentCardRecipientModel recipient;
  final String expires;

  ProfessionalStudentCardModel(
      this.recipient, this.expires, Author issuedBy, String id, String type)
      : super(id, type, issuedBy);
}
