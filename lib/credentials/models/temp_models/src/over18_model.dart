import 'package:altme/credentials/models/author/author.dart';

import 'credential_subject_model.dart';

class Over18Model extends CredentialSubjectModel {
  Over18Model(String id, String type, Author issuedBy)
      : super(id, type, issuedBy);
}
