import 'package:altme/credentials/models/author/author.dart';

import 'credential_subject_model.dart';

class PhonePassModel extends CredentialSubjectModel {
  final String expires;
  final String phone;

  PhonePassModel(
      this.expires, this.phone, String id, String type, Author issuedBy)
      : super(id, type, issuedBy);
}
