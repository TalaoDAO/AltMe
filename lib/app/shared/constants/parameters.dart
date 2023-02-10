import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

class Parameters {
  static const int multipleCredentialsProcessDelay = 1;

  static List<CredentialSubjectType> passbaseCredentialTypeList = [
    CredentialSubjectType.over13,
    CredentialSubjectType.over18,
    CredentialSubjectType.ageRange,
    CredentialSubjectType.verifiableIdCard,
    CredentialSubjectType.emailPass,
    CredentialSubjectType.nationality,
    // CredentialSubjectType.linkedInCard,
  ];
  static const bool hasCryptoCallToAction = false;

  static const AdvanceSettingsState defaultAdvanceSettingsState =
      AdvanceSettingsState(
    isGamingEnabled: false,
    isIdentityEnabled: true,
    isBlockchainAccountsEnabled: false,
    isSocialMediaEnabled: true,
    isCommunityEnabled: true,
    isOtherEnabled: true,
    isPassEnabled: true,
  );

  static const ebsiUniversalLink =
      'https://app.talao.co/app/download/credential';

  static const web3RpcMainnetUrl = 'https://mainnet.infura.io/v3/';
}
