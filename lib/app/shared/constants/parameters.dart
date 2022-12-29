import 'package:altme/dashboard/dashboard.dart';

class Parameters {
  static const int multipleCredentialsProcessDelay = 1;
  static const List<String> credentialTypeList = [
    'Over18',
    'AgeRange',
    'IdCard',
    'EmailPass',
    'Nationality'
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
