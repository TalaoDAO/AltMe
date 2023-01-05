import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

class Parameters {
  static const int multipleCredentialsProcessDelay = 1;

  static List<CredentialSubjectType> credentialTypeList = [
    CredentialSubjectType.over13,
    CredentialSubjectType.over18,
    CredentialSubjectType.ageRange,
    CredentialSubjectType.verifiableIdCard,
    CredentialSubjectType.emailPass,
    CredentialSubjectType.nationality,
  ];
  static const bool hasCryptoCallToAction = false;

  static const AdvanceSettingsState defaultAdvanceSettingsState =
      AdvanceSettingsState(
    isGamingEnabled: true,
    isIdentityEnabled: true,
    isBlockchainAccountsEnabled: false,
    isSocialMediaEnabled: true,
    isCommunityEnabled: true,
    isOtherEnabled: true,
    isPassEnabled: true,
  );
}
