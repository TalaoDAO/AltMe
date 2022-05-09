import 'package:altme/app/shared/models/translation/translation.dart';

import '../index.dart';

class MCredential {
  final String id;
  final List<String> type;
  final String issuer;
  final List<Translation> description;
  final List<Translation> name;
  final String issuanceDate;
  final List<ProofModel> proof;
  final CredentialSubjectModel credentialSubject;
  final List<EvidenceModel> evidence;
  final CredentialStatusFieldModel credentialStatus;

  MCredential(
    this.id,
    this.type,
    this.issuer,
    this.issuanceDate,
    this.proof,
    this.credentialSubject,
    this.description,
    this.name,
    this.credentialStatus,
    this.evidence,
  );
}
