import '../../author/author.dart';
import 'credential_subject_model.dart';
import 'identity_pass_recipient_model.dart';

class IdentityPassModel extends CredentialSubjectModel {
  final IdentityPassRecipient recipient;
  final String expires;

  IdentityPassModel(
      this.recipient, this.expires, Author issuedBy, String id, String type)
      : super(id, type, issuedBy);
}
