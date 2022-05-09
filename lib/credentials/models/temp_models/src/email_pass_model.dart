import 'package:altme/credentials/models/author/author.dart';

import 'credential_subject_model.dart';

class EmailPassModel extends CredentialSubjectModel {
  final String expires;
  final String email;

  final String passbaseMetadata;

  EmailPassModel(this.expires, this.email, String id, String type,
      Author issuedBy, this.passbaseMetadata)
      : super(id, type, issuedBy);
}
