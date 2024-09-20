enum OIDC4VCType {
  DEFAULT(
    offerPrefix: 'openid-credential-offer://',
    presentationPrefix: 'openid-vc://',
  ),

  GAIAX(
    offerPrefix: 'openid-initiate-issuance://',
    presentationPrefix: 'openid://',
  ),

  GREENCYPHER(
    offerPrefix: 'openid-credential-offer-hedera://',
    presentationPrefix: 'openid-hedera://',
  ),

  EBSI(
    offerPrefix: 'openid-credential-offer://',
    presentationPrefix: 'openid-vc://',
  ),

  JWTVC(
    offerPrefix: '',
    presentationPrefix: 'openid-vc://',
  ),

  HAIP(
    offerPrefix: 'haip',
    presentationPrefix: 'haip://',
  );

  const OIDC4VCType({
    required this.offerPrefix,
    required this.presentationPrefix,
  });

  final String offerPrefix;
  final String presentationPrefix;
}

extension OIDC4VCTypeX on OIDC4VCType {
  bool get isEnabled {
    switch (this) {
      case OIDC4VCType.DEFAULT:
      case OIDC4VCType.GAIAX:
      case OIDC4VCType.GREENCYPHER:
      case OIDC4VCType.EBSI:
      case OIDC4VCType.HAIP:
        return true;
      case OIDC4VCType.JWTVC:
        return false;
    }
  }
}
