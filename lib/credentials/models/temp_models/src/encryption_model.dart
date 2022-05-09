class EncryptionModel {
  EncryptionModel({
    this.cipherText,
    this.authenticationTag,
  });

  final String? cipherText;
  final String? authenticationTag;
}
