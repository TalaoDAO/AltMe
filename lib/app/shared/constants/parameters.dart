import 'package:altme/app/shared/enum/enum.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

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
  static const POLYGON_INFURA_URL = 'https://polygon-mainnet.infura.io/v3/';
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

  static const chainChanged = 'chainChanged';
  static const accountsChanged = 'accountsChanged';

  static const requiredEvents = [
    chainChanged,
    accountsChanged,
  ];
  static const optionalEvents = ['message', 'disconnect', 'connect'];

  static const allEvents = [...requiredEvents, ...optionalEvents];

  static const String clientId = 'urn:altme:0001';
  static const int maxEntries = 3;

  // 'Talao'for talao
  static const String appName = 'Altme';

  // false for talao
  static const bool supportDefiCompliance = true;
  // false for talao
  static const bool supportCryptoAccountOwnershipInDiscoverForEnterpriseMode =
      true;
  // false for talao
  static const bool showChainbornCard = false;
  // false for talao
  static const bool showTezotopiaCard = false;

  //'https://app.talao.co/app/download/authorize' for Talao
  static const String redirectUri =
      'https://app.altme.io/app/download/authorize';

  //'https://app.talao.co/app/download/callback' for Talao
  static const String authorizationEndPoint =
      'https://app.altme.io/app/download/callback';

  // 'talao_wallet'for talao
  static const String walletName = 'altme_wallet';

  static const DidKeyType didKeyTypeForEbsiV3 = DidKeyType.ebsiv3;
  static const DidKeyType didKeyTypeForDefault = DidKeyType.edDSA;
  static const DidKeyType didKeyTypeForDutch = DidKeyType.jwkP256;
  static const DidKeyType didKeyTypeForOwfBaselineProfile = DidKeyType.jwkP256;

  // seed color for the app Theme
  // Altme
  static const Color seedColor = Color(0xff6600FF);
  // Talao
  // static const Color seedColor = Color(0xff1EAADC);

  // ThemeMode.light for talao
  static const ThemeMode defaultTheme = ThemeMode.dark;
}

final respond = [
  {
    "token_instance": {
      "is_unique": true,
      "id": "431",
      "holder_address_hash": "0x394c399dbA25B99Ab7708EdB505d755B3aa29997",
      "image_url": "example.com/picture.png",
      "animation_url": "example.com/video.mp4",
      "external_app_url": "d-app.com",
      "metadata": {
        "year": 2023,
        "tags": ["poap", "event"],
        "name": "Social Listening Committee #2 Attendees",
        "image_url":
            "https://assets.poap.xyz/chanel-poap-4c-2023-logo-1675083420470.png",
        "home_url": "https://app.poap.xyz/token/6292128",
        "external_url": "https://api.poap.tech/metadata/99010/6292128",
        "description":
            "This is the POAP for attendees of the second Social Listening Committee.",
        "attributes": [
          {"value": "01-Feb-2023", "trait_type": "startDate"},
          {"value": "01-Feb-2023", "trait_type": "endDate"},
          {"value": "false", "trait_type": "virtualEvent"},
          {"value": "Paris", "trait_type": "city"},
          {"value": "France", "trait_type": "country"},
          {"value": "https://www.chanel.com", "trait_type": "eventURL"}
        ]
      },
      "owner": {
        "hash": "0xEb533ee5687044E622C69c58B1B12329F56eD9ad",
        "implementation_name": "implementationName",
        "name": "contractName",
        "is_contract": true,
        "private_tags": [
          {
            "address_hash": "0xEb533ee5687044E622C69c58B1B12329F56eD9ad",
            "display_name": "name to show",
            "label": "label"
          }
        ],
        "watchlist_names": [
          {"display_name": "name to show", "label": "label"}
        ],
        "public_tags": [
          {
            "address_hash": "0xEb533ee5687044E622C69c58B1B12329F56eD9ad",
            "display_name": "name to show",
            "label": "label"
          }
        ],
        "is_verified": true
      },
      "token": {
        "circulating_market_cap": "83606435600.3635",
        "icon_url":
            "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/assets/0xdAC17F958D2ee523a2206206994597C13D831ec7/logo.png",
        "name": "Tether USD",
        "decimals": "6",
        "symbol": "USDT",
        "address": "0x394c399dbA25B99Ab7708EdB505d755B3aa29997",
        "type": "ERC-20",
        "holders": "837494234523",
        "exchange_rate": "0.99",
        "total_supply": "10000000"
      }
    },
    "value": "10000",
    "token_id": "123",
    "token": {
      "name": "Tether USD",
      "decimals": "16",
      "symbol": "USDT",
      "address": "0x394c399dbA25B99Ab7708EdB505d755B3aa29997",
      "type": "ERC-20",
      "holders": 837494234523,
      "exchange_rate": "0.99",
      "total_supply": "10000000"
    }
  }
];
