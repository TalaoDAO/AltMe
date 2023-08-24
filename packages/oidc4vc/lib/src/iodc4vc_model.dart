class OIDC4VCModel {
  const OIDC4VCModel({
    required this.offerPrefix,
    required this.presentationPrefix,
    required this.publicJWKNeeded,
  });

  final String offerPrefix;
  final String presentationPrefix;
  final bool publicJWKNeeded;
}
