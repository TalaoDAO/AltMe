class CredentialStatusFieldModel {
  final String id;
  final String type;
  final String revocationListIndex;
  final String revocationListCredential;

  CredentialStatusFieldModel(this.id, this.type, this.revocationListIndex,
      this.revocationListCredential);
}
