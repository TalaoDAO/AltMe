import 'package:altme/app/shared/enum/enum.dart';
import 'package:altme/dashboard/dashboard.dart';

class Parameters {
  static const int multipleCredentialsProcessDelay = 1;

  static const bool walletHandlesCrypto = true;

  static const AdvanceSettingsState defaultAdvanceSettingsState =
      AdvanceSettingsState(
    isGamingEnabled: true,
    isIdentityEnabled: true,
    isProfessionalEnabled: true,
    isBlockchainAccountsEnabled: true,
    isEducationEnabled: true,
    isSocialMediaEnabled: true,
    isCommunityEnabled: true,
    isOtherEnabled: true,
    isPassEnabled: true,
    isFinanceEnabled: true,
    isHumanityProofEnabled: true,
    isWalletIntegrityEnabled: true,
  );

  static const oidc4vcUniversalLink =
      'https://app.altme.io/app/download/callback';

  static const authorizeEndPoint =
      'https://app.altme.io/app/download/authorize';

  static const web3RpcMainnetUrl = 'https://mainnet.infura.io/v3/';

  static const POLYGON_MAIN_NETWORK = 'main';
  static const INFURA_URL = 'https://polygon-mainnet.infura.io/v3/';
  static const INFURA_RDP_URL = 'wss://polygon-mainnet.infura.io/v3/';
  static const ID_STATE_CONTRACT_ADDR =
      '0x624ce98D2d27b20b8f8d521723Df8fC4db71D79D';
  static const PUSH_URL = 'https://push-staging.polygonid.com/api/v1';

  static const POLYGON_TEST_NETWORK = 'mumbai';
  static const INFURA_MUMBAI_URL = 'https://polygon-mumbai.infura.io/v3/';
  static const INFURA_MUMBAI_RDP_URL = 'wss://polygon-mumbai.infura.io/v3/';
  static const MUMBAI_ID_STATE_CONTRACT_ADDR =
      '0x134B1BE34911E39A8397ec6289782989729807a4';
  static const MUMBAI_PUSH_URL = 'https://push-staging.polygonid.com/api/v1';

  static const NAMESPACE = 'eip155';
  static const PERSONAL_SIGN = 'personal_sign';
  static const ETH_SIGN = 'eth_sign';
  static const ETH_SIGN_TRANSACTION = 'eth_signTransaction';
  static const ETH_SIGN_TYPE_DATA = 'eth_signTypedData';
  static const ETH_SEND_TRANSACTION = 'eth_sendTransaction';
  static const ETH_SIGN_TYPE_DATA_V4 = 'eth_signTypedData_v4';

  static const walletConnectMethods = [
    PERSONAL_SIGN,
    ETH_SIGN,
    ETH_SIGN,
    ETH_SIGN_TRANSACTION,
    ETH_SIGN_TYPE_DATA,
    ETH_SEND_TRANSACTION,
    ETH_SIGN_TYPE_DATA_V4,
  ];

  static const walletConnectEvents = ['chainChanged', 'accountsChanged'];

  static const String clientId = 'urn:altme:0001';
  static const int maxEntries = 3;

  static const String appName = 'Altme';

  static const DidKeyType didKeyTypeForEbsiV3 = DidKeyType.ebsiv3;
  static const DidKeyType didKeyTypeForDefault = DidKeyType.p256;
  static const DidKeyType didKeyTypeForDutch = DidKeyType.jwkP256;
  static const DidKeyType didKeyTypeForOwfBaselineProfile = DidKeyType.jwkP256;
}
