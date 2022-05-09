
import 'package:altme/credentials/models/author/author.dart';

class CredentialSubjectModel {
  final String id;
  final String type;
  final Author issuedBy;

  CredentialSubjectModel(this.id, this.type, this.issuedBy);
}