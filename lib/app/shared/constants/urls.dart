class Urls {
  static const String appContactWebsiteUrl = 'https://altme.io';
  static const String checkIssuerTalaoUrl =
      'https://talao.co/trusted-issuers-registry/v1/issuers';
  static const String checkIssuerEbsiUrl =
      'https://api.conformance.intebsi.xyz/trusted-issuers-registry/v2/issuers';

  static const String issuerBaseUrl = 'https://issuer.talao.co';
  static const String phonePassUrl = 'https://issuer.talao.co/phonepass';
  static const String emailPassUrl = 'https://issuer.talao.co/emailpass';
  static const String ageRangeUrl = 'https://issuer.talao.co/agerange';
  static const String nationalityUrl = 'https://issuer.talao.co/nationality';
  static const String genderUrl = 'https://issuer.talao.co/gender';
  static const String over18Url = 'https://issuer.talao.co/over18';
  static const String tezotopiaVoucherUrl =
      'https://issuer.tezotopia.altme.io/issuer/voucher_mobile';
  static const String talaoCommunityCardUrl =
      'https://issuer.talao.co/talao_community';
  // TODO(all): not sure about the issuer url for tezotopiaMembershipCard
  static const String tezotopiaMembershipCardUrl =
      'http://issuer.talao.co/membership_1';
  static const String identityCardUrl = 'http://issuer.talao.co/kyc';
  static const String talaoIpfsGateway = 'https://talao.mypinata.cloud/ipfs/';

  /// main tezos rpc
  static const mainnetRPC = 'https://rpc.tzstats.com';
  static const ghostnetRPC = 'https://rpc.tzkt.io/ghostnet';

  static const tezToolPrices = 'https://api.teztools.io/v1/prices';
  static const tezToolBase = 'https://api.teztools.io';
}
