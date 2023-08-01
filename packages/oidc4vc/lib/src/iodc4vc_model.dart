class OIDC4VCModel {
  const OIDC4VCModel({
    required this.issuerVcType,
    required this.verifierVpType,
    required this.offerPrefix,
    required this.presentationPrefix,
    required this.cryptographicBindingMethodsSupported,
    required this.cryptographicSuitesSupported,
    required this.subjectSyntaxTypesSupported,
    required this.grantTypesSupported,
    required this.credentialSupported,
    required this.schemaForType,
    required this.publicJWKNeeded,
    required this.serviceDocumentation,
  });

  final String issuerVcType;
  final String verifierVpType;
  final String offerPrefix;
  final String presentationPrefix;
  final List<String> cryptographicBindingMethodsSupported;
  final List<String> cryptographicSuitesSupported;
  final List<String> subjectSyntaxTypesSupported;
  final List<String> grantTypesSupported;
  final List<String> credentialSupported;
  final bool schemaForType;
  final bool publicJWKNeeded;
  final String serviceDocumentation;
}
