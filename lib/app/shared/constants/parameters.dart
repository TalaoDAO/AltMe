import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

class Parameters {
  static const int multipleCredentialsProcessDelay = 1;

  static List<String> credentialTypeList = [
    CredentialSubjectType.over18.name,
    CredentialSubjectType.ageRange.name,
    CredentialSubjectType.verifiableIdCard.name,
    CredentialSubjectType.emailPass.name,
    CredentialSubjectType.nationality.name,
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
