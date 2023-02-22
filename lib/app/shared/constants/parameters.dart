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
    CredentialSubjectType.linkedInCard,
  ];
  static const bool hasCryptoCallToAction = true;

  static const AdvanceSettingsState defaultAdvanceSettingsState =
      AdvanceSettingsState(
    isGamingEnabled: true,
    isIdentityEnabled: true,
    isBlockchainAccountsEnabled: true,
    isEducationEnabled: true,
    isSocialMediaEnabled: true,
    isCommunityEnabled: true,
    isOtherEnabled: true,
    isPassEnabled: true,
  );

  static const ebsiUniversalLink = 'https://app.altme.io/app/download';

  static const web3RpcMainnetUrl = 'https://mainnet.infura.io/v3/';
}
