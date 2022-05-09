class ProofModel {
  final String type;
  final String proofPurpose;
  final String verificationMethod;
  final String created;
  final String jws;

  ProofModel(this.type, this.proofPurpose, this.verificationMethod,
      this.created, this.jws);
}
