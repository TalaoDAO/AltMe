import 'package:altme/credentials/models/author/author.dart';

import 'credential_subject_model.dart';

class DefaultCredentialSubjectModel extends CredentialSubjectModel {
  DefaultCredentialSubjectModel(String id, String type, Author issuedBy)
      : super(id, type, issuedBy);
}
