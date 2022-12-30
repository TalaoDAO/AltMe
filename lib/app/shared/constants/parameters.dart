import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

class Parameters {
  static const int multipleCredentialsProcessDelay = 1;
  static List<String> credentialTypeList = [
    CredentialSubjectType.over18.name,
    CredentialSubjectType.ageRange.name,
    CredentialSubjectType.identityCard.name,
    CredentialSubjectType.emailPass.name,
    CredentialSubjectType.nationality.name,
  ];
  static const bool hasCryptoCallToAction = true;

  static const AdvanceSettingsState defaultAdvanceSettingsState =
      AdvanceSettingsState(
    isGamingEnabled: true,
    isIdentityEnabled: true,
    isBlockchainAccountsEnabled: true,
    isSocialMediaEnabled: true,
    isCommunityEnabled: true,
    isOtherEnabled: true,
    isPassEnabled: true,
  );
}
