import 'package:altme/credentials/models/author/author.dart';

import 'credential_subject_model.dart';
import 'offer_model.dart';

class VoucherModel extends CredentialSubjectModel {
  final String identifier;
  final OfferModel offer;

  VoucherModel(
    String id,
    String type,
    Author issuedBy,
    this.identifier,
    this.offer,
  ) : super(id, type, issuedBy);
}
