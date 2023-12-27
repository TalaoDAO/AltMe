class AltMeStrings {
  static const String defaultDIDMethod = 'key';
  static const String cryptoTezosDIDMethod = 'pkh:tz';
  static const String cryptoEVMDIDMethod = 'pkh:eth';
  static const String defaultDIDMethodName = 'Tezos';
  static const String enterpriseDIDMethod = 'web';
  static const String enterpriseDIDMethodName = 'Web';
  static const String databaseFilename = 'wallet.db';
  static const String appContactWebsiteName = 'www.talao.io';
  static const String appContactMail = 'contact@altme.io';
  static const String appSupportMail = 'support@talao.io';
  static const String ivVector = 'Talao';
  static const String additionalAuthenticatedData = 'Credible';
  static const String passBasePublishableApiKey =
      'Ww3TIde3B8nh5M3EZ57tkzIbMyAVwzh9YzW8FcwADKgpQ76UfT5bqox2dvdNTDVo';

  static const String date = 'date';
  static const String uri = 'uri';
  static const String email = 'email';
  static const String time = 'time';

  //page
  static const String matrixSupportId = '@support:matrix.talao.co';

  //Chat
  static const String dashBoardPage = '/dashboardPage';

  //ID360
  /// ALTME
  // static const int clientIdForID360 = 100;

  /// TALAO
  static const int clientIdForID360 = 200;

  //minter
  static const List<String> minterBurnAddress = [
    '0x240863E65b2ace78eda93334be396FF220f14354',
  ];

  //Don't send address
  static const List<String> contractDontSendAddress = [
    'KT1VuCBGQW4WakHj1PXhFC1G848dKyNy34kB',
    'KT1Wv4dPiswWYj2H9UrSrVNmcMd9w5NtzczG',
  ];

  static const emailPattern =
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,}$';
}
