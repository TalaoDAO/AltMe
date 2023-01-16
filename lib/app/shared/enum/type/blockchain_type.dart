import 'package:altme/app/app.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:key_generator/key_generator.dart';

enum BlockchainType { tezos, ethereum, fantom, polygon, binance }

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
    }
  }

  Filter get filter {
    switch (this) {
      case BlockchainType.tezos:
        return Filter('String', 'TezosAssociatedAddress');

      case BlockchainType.ethereum:
        return Filter('String', 'EthereumAssociatedAddress');

      case BlockchainType.fantom:
        return Filter('String', 'FantomAssociatedAddress');

      case BlockchainType.polygon:
        return Filter('String', 'PolygonAssociatedAddress');

      case BlockchainType.binance:
        return Filter('String', 'BinanceAssociatedAddress');
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
        return ConnectionBridgeType.walletconnect;
    }
  }

  List<BlockchainNetwork> get networks {
    switch (this) {
      case BlockchainType.tezos:
        return [
          TezosNetwork.mainNet(),
          TezosNetwork.ghostnet(),
        ];

      case BlockchainType.ethereum:
        return [
          EthereumNetwork.mainNet(),
          EthereumNetwork.testNet(),
        ];
      case BlockchainType.fantom:
        return [
          FantomNetwork.mainNet(),
          FantomNetwork.testNet(),
        ];
      case BlockchainType.polygon:
        return [
          PolygonNetwork.mainNet(),
          PolygonNetwork.testNet(),
        ];
      case BlockchainType.binance:
        return [
          BinanceNetwork.mainNet(),
          BinanceNetwork.testNet(),
        ];
    }
  }

  bool get isDisabled {
    switch (this) {
      case BlockchainType.tezos:
        return false;
      case BlockchainType.ethereum:
        return false;
      case BlockchainType.fantom:
        return true;
      case BlockchainType.polygon:
        return false;
      case BlockchainType.binance:
        return true;
    }
  }
}
