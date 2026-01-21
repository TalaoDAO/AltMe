import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:credential_manifest/credential_manifest.dart';

enum BlockchainType { tezos, ethereum, fantom, polygon, binance, etherlink }

extension BlockchainTypeX on BlockchainType {
  String get icon {
    switch (this) {
      case BlockchainType.tezos:
        return IconStrings.tezos;

      case BlockchainType.ethereum:
        return IconStrings.ethereum;

      case BlockchainType.fantom:
        return IconStrings.fantom;

      case BlockchainType.polygon:
        return IconStrings.polygon;

      case BlockchainType.binance:
        return IconStrings.binance;

      case BlockchainType.etherlink:
        return IconStrings.etherlink;
    }
  }

  AccountType get accountType {
    switch (this) {
      case BlockchainType.tezos:
        return AccountType.tezos;

      case BlockchainType.ethereum:
        return AccountType.ethereum;

      case BlockchainType.fantom:
        return AccountType.fantom;

      case BlockchainType.polygon:
        return AccountType.polygon;

      case BlockchainType.binance:
        return AccountType.binance;

      case BlockchainType.etherlink:
        return AccountType.etherlink;
    }
  }

  String get symbol {
    switch (this) {
      case BlockchainType.tezos:
        return 'XTZ';

      case BlockchainType.ethereum:
        return 'ETH';

      case BlockchainType.fantom:
        return 'FTM';

      case BlockchainType.polygon:
        return 'MATIC';

      case BlockchainType.binance:
        return 'BNB';

      case BlockchainType.etherlink:
        return 'XTZ';
    }
  }

  bool get supportWert {
    switch (this) {
      case BlockchainType.tezos:
      case BlockchainType.ethereum:
      case BlockchainType.polygon:
      case BlockchainType.binance:
        return true;

      case BlockchainType.etherlink:
      case BlockchainType.fantom:
        return false;
    }
  }

  // commodity, network, commodityId
  (String, String, String) get commodityData {
    switch (this) {
      case BlockchainType.tezos:
        return ('XTZ', 'tezos', 'xtz.simple.tezos');
      case BlockchainType.ethereum:
        return ('ETH', 'ethereum', 'eth.simple.ethereum');
      case BlockchainType.polygon:
        return ('POL', 'polygon', 'pol.simple.polygon');
      case BlockchainType.binance:
        return ('BNB', 'bsc', 'bnb.simple.bsc');
      case BlockchainType.etherlink:
      case BlockchainType.fantom:
        return ('', '', '');
    }
  }

  String get chain {
    String name = '';
    switch (this) {
      case BlockchainType.tezos:
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'Chain is not supported for tezos.',
          },
        );

      case BlockchainType.ethereum:
        name = '1';

      case BlockchainType.fantom:
        name = '250';

      case BlockchainType.polygon:
        name = '137';

      case BlockchainType.binance:
        name = '56';

      case BlockchainType.etherlink:
        name = '42793';
    }

    return '${Parameters.NAMESPACE}:$name';
  }

  int get chainId {
    switch (this) {
      case BlockchainType.tezos:
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'Chain is not supported for tezos.',
          },
        );

      case BlockchainType.ethereum:
        return 1;

      case BlockchainType.fantom:
        return 250;

      case BlockchainType.polygon:
        return 137;

      case BlockchainType.binance:
        return 56;

      case BlockchainType.etherlink:
        return 42793;
    }
  }

  String get derivePathIndexKey {
    switch (this) {
      case BlockchainType.tezos:
        return SecureStorageKeys.tezosDerivePathIndex;

      case BlockchainType.ethereum:
        return SecureStorageKeys.ethereumDerivePathIndex;

      case BlockchainType.fantom:
        return SecureStorageKeys.fantomDerivePathIndex;

      case BlockchainType.polygon:
        return SecureStorageKeys.polygonDerivePathIndex;

      case BlockchainType.binance:
        return SecureStorageKeys.binanceDerivePathIndex;

      case BlockchainType.etherlink:
        return SecureStorageKeys.etherlinkDerivePathIndex;
    }
  }

  CredentialManifest get credentialManifest {
    switch (this) {
      case BlockchainType.tezos:
        return CredentialManifest.fromJson(
          ConstantsJson.tezosAssociatedAddressCredentialManifestJson,
        );
      case BlockchainType.ethereum:
        return CredentialManifest.fromJson(
          ConstantsJson.ethereumAssociatedAddressCredentialManifestJson,
        );
      case BlockchainType.fantom:
        return CredentialManifest.fromJson(
          ConstantsJson.fantomAssociatedAddressCredentialManifestJson,
        );
      case BlockchainType.polygon:
        return CredentialManifest.fromJson(
          ConstantsJson.polygonAssociatedAddressCredentialManifestJson,
        );
      case BlockchainType.binance:
        return CredentialManifest.fromJson(
          ConstantsJson.binanceAssociatedAddressCredentialManifestJson,
        );
      case BlockchainType.etherlink:
        return CredentialManifest.fromJson(
          ConstantsJson.etherlinkAssociatedAddressCredentialManifestJson,
        );
    }
  }

  Filter get filter {
    switch (this) {
      case BlockchainType.tezos:
        return Filter(type: 'String', pattern: 'TezosAssociatedAddress');

      case BlockchainType.ethereum:
        return Filter(type: 'String', pattern: 'EthereumAssociatedAddress');

      case BlockchainType.fantom:
        return Filter(type: 'String', pattern: 'FantomAssociatedAddress');

      case BlockchainType.polygon:
        return Filter(type: 'String', pattern: 'PolygonAssociatedAddress');

      case BlockchainType.binance:
        return Filter(type: 'String', pattern: 'BinanceAssociatedAddress');

      case BlockchainType.etherlink:
        return Filter(type: 'String', pattern: 'EtherlinkAssociatedAddress');
    }
  }

  ConnectionBridgeType get connectionBridge {
    switch (this) {
      case BlockchainType.tezos:
        return ConnectionBridgeType.beacon;

      case BlockchainType.ethereum:
      case BlockchainType.fantom:
      case BlockchainType.polygon:
      case BlockchainType.binance:
      case BlockchainType.etherlink:
        return ConnectionBridgeType.walletconnect;
    }
  }

  /// index 0 must be mainnet
  /// index 1 is considered testnet in enterprise cubit
  List<BlockchainNetwork> get networks {
    switch (this) {
      case BlockchainType.tezos:
        return [TezosNetwork.mainNet(), TezosNetwork.ghostnet()];

      case BlockchainType.ethereum:
        return [EthereumNetwork.mainNet(), EthereumNetwork.testNet()];
      case BlockchainType.fantom:
        return [FantomNetwork.mainNet(), FantomNetwork.testNet()];
      case BlockchainType.polygon:
        return [PolygonNetwork.mainNet(), PolygonNetwork.testNet()];
      case BlockchainType.binance:
        return [BinanceNetwork.mainNet(), BinanceNetwork.testNet()];
      case BlockchainType.etherlink:
        return [EtherlinkNetwork.mainNet(), EtherlinkNetwork.testNet()];
    }
  }

  bool get isDisabled {
    switch (this) {
      case BlockchainType.tezos:
      case BlockchainType.ethereum:
      case BlockchainType.fantom:
      case BlockchainType.polygon:
      case BlockchainType.binance:
      case BlockchainType.etherlink:
        return false;
    }
  }

  bool isSupported(ProfileSetting profileSetting) {
    if (profileSetting.generalOptions.walletType != WalletAppType.altme) {
      /// Only applies to altme
      return true;
    }

    final blockchainOptions = profileSetting.blockchainOptions;

    switch (this) {
      case BlockchainType.tezos:
        if (blockchainOptions?.tezosSupport ?? false) return true;
      case BlockchainType.ethereum:
        if (blockchainOptions?.ethereumSupport ?? false) return true;
      case BlockchainType.fantom:
        if (blockchainOptions?.fantomSupport ?? false) return true;
      case BlockchainType.polygon:
        if (blockchainOptions?.polygonSupport ?? false) return true;
      case BlockchainType.binance:
        if (blockchainOptions?.bnbSupport ?? false) return true;
      case BlockchainType.etherlink:
        if (blockchainOptions?.etherlinkSupport ?? false) return true;
    }

    return false;
  }

  String get category {
    switch (this) {
      case BlockchainType.tezos:
        return 'tezos-ecosystem';

      case BlockchainType.ethereum:
        return 'ethereum-ecosystem';

      case BlockchainType.fantom:
        return 'fantom-ecosystem';

      case BlockchainType.polygon:
        return 'polygon-ecosystem';

      case BlockchainType.binance:
        return 'binance-smart-chain';

      case BlockchainType.etherlink:
        return 'etherlink-ecosystem';
    }
  }
}
