class Urls {
  static const String appContactWebsiteUrl = 'https://altme.io';
  static const String checkIssuerTalaoUrl =
      'https://talao.co/trusted-issuers-registry/v1/issuers';
  static const String checkIssuerEbsiUrl =
      'https://api.conformance.intebsi.xyz/trusted-issuers-registry/v2/issuers';

  static const String issuerBaseUrl = 'https://issuer.talao.co';
  static const String phonePassUrl = 'https://issuer.talao.co/phonepass';
  static const String emailPassUrl = 'https://issuer.talao.co/emailpass';
  static const String ageRangeUrl =
      'https://issuer.talao.co/passbase/endpoint/agerange/';
  static const String nationalityUrl =
      'https://issuer.talao.co/passbase/endpoint/nationality/';
  static const String genderUrl =
      'https://issuer.talao.co/passbase/endpoint/gender/';
  static const String over18Url =
      'https://issuer.talao.co/passbase/endpoint/over18/';
  static const String over13Url =
      'https://issuer.talao.co/passbase/endpoint/over13/';
  static const String passportFootprintUrl =
      'https://issuer.talao.co/passbase/endpoint/passportnumber/';

  static const String tezotopiaVoucherUrl =
      'https://issuer.tezotopia.altme.io/issuer/voucher_mobile';
  static const String talaoCommunityCardUrl =
      'https://issuer.talao.co/talao_community';

  static const String tezotopiaMembershipCardUrl =
      'https://issuer.talao.co/tezotopia/membershipcard/';

  static const String chainbornMembershipCardUrl =
      'https://issuer.talao.co/chainborn/membershipcard/';

  static const String twitterCardUrl = 'https://issuer.talao.co/twitter/';

  static const String identityCardUrl =
      'https://issuer.talao.co/passbase/endpoint/verifiableid/';
  static const String linkedinCardUrl =
      'https://issuer.talao.co/passbase/endpoint/linkedincard/';
  static const String talaoIpfsGateway = 'https://talao.mypinata.cloud/ipfs/';

  /// main tezos rpc
  static const mainnetRPC = 'https://rpc.tzstats.com';
  static const ghostnetRPC = 'https://rpc.tzkt.io/ghostnet';

  static const tezToolPrices = 'https://api.teztools.io/v1/prices';
  static const tezToolBase = 'https://api.teztools.io';

  static const xtzPrice = 'https://api.teztools.io/v1/xtz-price';
  static const cryptoCompareBaseUrl = 'https://min-api.cryptocompare.com';
  static const ethPrice = '$cryptoCompareBaseUrl/data/price?fsym=ETH&tsyms=USD';

  // TZKT
  static const tzktMainnetUrl = 'https://api.tzkt.io';
  static const tzktGhostnetUrl = 'https://api.ghostnet.tzkt.io';

  //Moralis
  static const moralisBaseUrl = 'https://deep-index.moralis.io/api/v2';

  static const objktUrl = 'https://objkt.com/';
  static const raribleUrl = 'https://rarible.com/';

  // TODO(all): remember to update all below urls.
  static const String bunnyPassCardUrl = 'https://issuer.tezotopia.altme.io';
  static const String dogamiPassCardUrl = 'https://issuer.tezotopia.altme.io';
  static const String matterlightPassCardUrl =
      'https://issuer.tezotopia.altme.io';
  static const String pigsPassCardUrl = 'https://issuer.tezotopia.altme.io';
  static const String trooperzPassCardUrl = 'https://issuer.tezotopia.altme.io';

  //
  static const over13AIValidationUrl = 'https://issuer.talao.co/ai/over13';
  static const over18AIValidationUrl = 'https://issuer.talao.co/ai/over18';
  static const ageRangeAIValidationUrl = 'https://issuer.talao.co/ai/agerange';

  //Matrix home server
  static const matrixHomeServer = 'https://matrix.talao.co';
  static const getNonce = 'https://talao.co/matrix/nonce';
  static const registerToMatrix = 'https://talao.co/matrix/register';

}
