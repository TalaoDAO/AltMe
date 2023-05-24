import 'package:altme/dashboard/dashboard.dart';

class Parameters {
  static const int multipleCredentialsProcessDelay = 1;

  static const bool walletHandlesCrypto = false;

  static const AdvanceSettingsState defaultAdvanceSettingsState =
      AdvanceSettingsState(
    isGamingEnabled: false,
    isIdentityEnabled: true,
    isBlockchainAccountsEnabled: false,
    isEducationEnabled: true,
    isSocialMediaEnabled: true,
    isCommunityEnabled: true,
    isOtherEnabled: true,
    isPassEnabled: true,
    isFinanceEnabled: true,
    isHumanityProofEnabled: true,
    isWalletIntegrityEnabled: true,
  );

  static const ebsiUniversalLink = 'https://app.talao.co/app/download/ebsi';

  static const web3RpcMainnetUrl = 'https://mainnet.infura.io/v3/';
}
