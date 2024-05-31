import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:key_generator/key_generator.dart';
import 'package:test/test.dart';

void main() {
  group('BlockchainType Extension Tests', () {
    test('BlockchainType icon returns correct value', () {
      expect(BlockchainType.tezos.icon, equals(IconStrings.tezos));
      expect(BlockchainType.ethereum.icon, equals(IconStrings.ethereum));
      expect(BlockchainType.fantom.icon, equals(IconStrings.fantom));
      expect(BlockchainType.polygon.icon, equals(IconStrings.polygon));
      expect(BlockchainType.binance.icon, equals(IconStrings.binance));
    });

    test('BlockchainType accountType returns correct value', () {
      expect(BlockchainType.tezos.accountType, equals(AccountType.tezos));
      expect(BlockchainType.ethereum.accountType, equals(AccountType.ethereum));
      expect(BlockchainType.fantom.accountType, equals(AccountType.fantom));
      expect(BlockchainType.polygon.accountType, equals(AccountType.polygon));
      expect(BlockchainType.binance.accountType, equals(AccountType.binance));
    });

    test('BlockchainType symbol returns correct value', () {
      expect(BlockchainType.tezos.symbol, equals('XTZ'));
      expect(BlockchainType.ethereum.symbol, equals('ETH'));
      expect(BlockchainType.fantom.symbol, equals('FTM'));
      expect(BlockchainType.polygon.symbol, equals('MATIC'));
      expect(BlockchainType.binance.symbol, equals('BNB'));
    });

    test('BlockchainType chain returns correct value', () {
      expect(() => BlockchainType.tezos.chain, throwsA(isA<ResponseMessage>()));
      expect(
          BlockchainType.ethereum.chain, equals('${Parameters.NAMESPACE}:1'));
      expect(
          BlockchainType.fantom.chain, equals('${Parameters.NAMESPACE}:250'));
      expect(
          BlockchainType.polygon.chain, equals('${Parameters.NAMESPACE}:137'));
      expect(
          BlockchainType.binance.chain, equals('${Parameters.NAMESPACE}:56'));
    });

    test('BlockchainType chainId returns correct value', () {
      expect(
          () => BlockchainType.tezos.chainId, throwsA(isA<ResponseMessage>()));
      expect(BlockchainType.ethereum.chainId, equals(1));
      expect(BlockchainType.fantom.chainId, equals(250));
      expect(BlockchainType.polygon.chainId, equals(137));
      expect(BlockchainType.binance.chainId, equals(56));
    });

    test('BlockchainType derivePathIndexKey returns correct value', () {
      expect(BlockchainType.tezos.derivePathIndexKey,
          equals(SecureStorageKeys.tezosDerivePathIndex));
      expect(BlockchainType.ethereum.derivePathIndexKey,
          equals(SecureStorageKeys.ethereumDerivePathIndex));
      expect(BlockchainType.fantom.derivePathIndexKey,
          equals(SecureStorageKeys.fantomDerivePathIndex));
      expect(BlockchainType.polygon.derivePathIndexKey,
          equals(SecureStorageKeys.polygonDerivePathIndex));
      expect(BlockchainType.binance.derivePathIndexKey,
          equals(SecureStorageKeys.binanceDerivePathIndex));
    });

    test('BlockchainType credentialManifest returns correct value', () {
      expect(
          jsonEncode(BlockchainType.tezos.credentialManifest),
          equals(jsonEncode(CredentialManifest.fromJson(
              ConstantsJson.tezosAssociatedAddressCredentialManifestJson))));
      expect(
          jsonEncode(BlockchainType.ethereum.credentialManifest),
          equals(jsonEncode(CredentialManifest.fromJson(
              ConstantsJson.ethereumAssociatedAddressCredentialManifestJson))));
      expect(
          jsonEncode(BlockchainType.fantom.credentialManifest),
          equals(jsonEncode(CredentialManifest.fromJson(
              ConstantsJson.fantomAssociatedAddressCredentialManifestJson))));
      expect(
          jsonEncode(BlockchainType.polygon.credentialManifest),
          equals(jsonEncode(CredentialManifest.fromJson(
              ConstantsJson.polygonAssociatedAddressCredentialManifestJson))));
      expect(
          jsonEncode(BlockchainType.binance.credentialManifest),
          equals(jsonEncode(CredentialManifest.fromJson(
              ConstantsJson.binanceAssociatedAddressCredentialManifestJson))));
    });

    test('BlockchainType filter returns correct value', () {
      expect(
          jsonEncode(BlockchainType.tezos.filter.toJson()),
          equals(jsonEncode(
              Filter(type: 'String', pattern: 'TezosAssociatedAddress')
                  .toJson())));
      expect(
          jsonEncode(BlockchainType.ethereum.filter.toJson()),
          equals(jsonEncode(
              Filter(type: 'String', pattern: 'EthereumAssociatedAddress')
                  .toJson())));
      expect(
          jsonEncode(BlockchainType.fantom.filter.toJson()),
          equals(jsonEncode(
              Filter(type: 'String', pattern: 'FantomAssociatedAddress')
                  .toJson())));
      expect(
          jsonEncode(BlockchainType.polygon.filter.toJson()),
          equals(jsonEncode(
              Filter(type: 'String', pattern: 'PolygonAssociatedAddress')
                  .toJson())));
      expect(
          jsonEncode(BlockchainType.binance.filter.toJson()),
          equals(jsonEncode(
              Filter(type: 'String', pattern: 'BinanceAssociatedAddress')
                  .toJson())));
    });

    test('BlockchainType connectionBridge returns correct value', () {
      expect(BlockchainType.tezos.connectionBridge,
          equals(ConnectionBridgeType.beacon));
      expect(BlockchainType.ethereum.connectionBridge,
          equals(ConnectionBridgeType.walletconnect));
      expect(BlockchainType.fantom.connectionBridge,
          equals(ConnectionBridgeType.walletconnect));
      expect(BlockchainType.polygon.connectionBridge,
          equals(ConnectionBridgeType.walletconnect));
      expect(BlockchainType.binance.connectionBridge,
          equals(ConnectionBridgeType.walletconnect));
    });

    test('BlockchainType networks returns correct value', () {
      expect(BlockchainType.tezos.networks,
          equals([TezosNetwork.mainNet(), TezosNetwork.ghostnet()]));
      expect(BlockchainType.ethereum.networks,
          equals([EthereumNetwork.mainNet(), EthereumNetwork.testNet()]));
      expect(BlockchainType.fantom.networks,
          equals([FantomNetwork.mainNet(), FantomNetwork.testNet()]));
      expect(BlockchainType.polygon.networks,
          equals([PolygonNetwork.mainNet(), PolygonNetwork.testNet()]));
      expect(BlockchainType.binance.networks,
          equals([BinanceNetwork.mainNet(), BinanceNetwork.testNet()]));
    });

    test('BlockchainType isDisabled returns correct value', () {
      expect(BlockchainType.tezos.isDisabled, isFalse);
      expect(BlockchainType.ethereum.isDisabled, isFalse);
      expect(BlockchainType.fantom.isDisabled, isFalse);
      expect(BlockchainType.polygon.isDisabled, isFalse);
      expect(BlockchainType.binance.isDisabled, isFalse);
    });
  });
}
