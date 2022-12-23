import 'dart:convert';
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip393;
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:dart_web3/crypto.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secp256k1/secp256k1.dart';
// ignore: implementation_imports
import 'package:tezart/src/crypto/crypto.dart' as crypto hide Prefixes;
// ignore: implementation_imports, unnecessary_import
import 'package:tezart/src/crypto/crypto.dart' show Prefixes;
import 'package:tezart/tezart.dart';

/// tezos supports 3 types of keys (secp256k, ed25519, P-256)

/// solana supports only ed25519

/// ethereum and EVM blockchains supports only ES256K

/// SSI supports any asymetric key , all : RSA, secp256, P-256, P-512,
/// everything is possible

class KeyGenerator {
  static const Prefixes _seedPrefix = Prefixes.edsk2;

  /// Note: private key is also known as a secret key
  /// Ethereum ref - https://stackoverflow.com/questions/71406107/how-to-get-private-key-in-webdart

  Future<String> jwkFromMnemonic({
    required String mnemonic,
    required AccountType accountType,
    int derivePathIndex = 0,
  }) async {
    //notice photo opera keen climb agent soft parrot best joke field devote
    final seed = bip393.mnemonicToSeed(mnemonic);

    late Uint8List seedBytes;

    switch (accountType) {
      case AccountType.ssi:
        final child =
            await ED25519_HD_KEY.derivePath("m/44'/5467'/0'/0'", seed);
        seedBytes = Uint8List.fromList(child.key);
        break;

      case AccountType.tezos:
        final child = await ED25519_HD_KEY.derivePath(
          "m/44'/1729'/$derivePathIndex'/0'",
          seed,
        );
        seedBytes = Uint8List.fromList(child.key);
        break;

      case AccountType.ethereum:
      case AccountType.fantom:
      case AccountType.polygon:
      case AccountType.binance:
        final rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'
        // derive path for ethereum '60' see bip 44, first address
        final child = rootKey.derivePath(
          "m/44'/60'/0'/0/$derivePathIndex",
        ); //Instance of 'BIP32'
        final Iterable<int> iterable = child.privateKey!;
        seedBytes = Uint8List.fromList(List.from(iterable));
    }

    final key = jwkFromSeed(
      seedBytes: seedBytes,
      accountType: accountType,
    );
    return jsonEncode(key);
  }

  Map<String, String> jwkFromSeed({
    required Uint8List seedBytes,
    required AccountType accountType,
  }) {
    switch (accountType) {
      case AccountType.ssi:
      case AccountType.tezos:
        final mypk = crypto.publicKeyBytesFromSeedBytes(seedBytes);

        final sk = base64Url.encode(seedBytes);
        final pk = base64Url.encode(mypk);
        final jwk = {
          'kty': 'OKP',
          'crv': 'Ed25519',
          'd': sk,
          'x': pk,
        };
        return jwk;
      case AccountType.ethereum:
      case AccountType.fantom:
      case AccountType.polygon:
      case AccountType.binance:
        final epk = HEX.encode(seedBytes);
        final pk = PrivateKey.fromHex(epk); //Instance of 'PrivateKey'
        final pub = pk.publicKey.toHex().substring(2);
        final ad = HEX.decode(epk);
        final d = base64Url.encode(ad).substring(0, 43);
        // remove "=" padding 43/44
        final mx = pub.substring(0, 64);
        // first 32 bytes
        final ax = HEX.decode(mx);
        final x = base64Url.encode(ax).substring(0, 43);
        // remove "=" padding 43/44
        final my = pub.substring(64);
        // last 32 bytes
        final ay = HEX.decode(my);
        final y = base64Url.encode(ay).substring(0, 43);
        // ATTENTION !!!!!
        // alg "ES256K-R" for did:ethr
        // and did:tz2 "EcdsaSecp256k1RecoverySignature2020"
        // use alg "ES256K" for did:key
        final jwk = {
          'kty': 'EC',
          'crv': 'secp256k1',
          'd': d,
          'x': x,
          'y': y,
          'alg': 'ES256K-R' // or 'alg': "ES256K" for did:key
        };
        return jwk;
    }
  }

  Future<String> secretKeyFromMnemonic({
    required String mnemonic,
    required AccountType accountType,
    int derivePathIndex = 0,
  }) async {
    switch (accountType) {
      case AccountType.tezos:
        final key = await jwkFromMnemonic(
          mnemonic: mnemonic,
          accountType: accountType,
          derivePathIndex: derivePathIndex,
        );

        // ignore: avoid_dynamic_calls
        final d = jsonDecode(key)['d'] as String;

        final dBytes = base64Url.decode(d);

        final tezosSeed =
            crypto.encodeWithPrefix(prefix: _seedPrefix, bytes: dBytes);

        final tezosSecretKey = crypto.seedToSecretKey(tezosSeed);

        return tezosSecretKey;
      case AccountType.ethereum:
      case AccountType.fantom:
      case AccountType.polygon:
      case AccountType.binance:
        final seed = bip393.mnemonicToSeed(mnemonic);
        final rootKey = bip32.BIP32.fromSeed(seed);
        final child = rootKey.derivePath(
          "m/44'/60'/0'/0/$derivePathIndex",
        );
        final Iterable<int> iterable = child.privateKey!;
        final epk = HEX.encode(List.from(iterable));
        return '0x$epk';

      case AccountType.ssi:
        throw Exception();
    }
  }

  Future<String> walletAddressFromMnemonic({
    required String mnemonic,
    required AccountType accountType,
    int derivePathIndex = 0,
  }) async {
    switch (accountType) {
      case AccountType.tezos:
        final key = await jwkFromMnemonic(
          mnemonic: mnemonic,
          accountType: AccountType.tezos,
          derivePathIndex: derivePathIndex,
        );

        // ignore: avoid_dynamic_calls
        final d = jsonDecode(key)['d'] as String;

        final dBytes = base64Url.decode(d);

        final tezosSeed =
            crypto.encodeWithPrefix(prefix: _seedPrefix, bytes: dBytes);

        final tezosSecretKey = crypto.seedToSecretKey(tezosSeed);

        return walletAddressFromSecretKey(
          secretKey: tezosSecretKey,
          accountType: AccountType.tezos,
        );

      case AccountType.ethereum:
      case AccountType.fantom:
      case AccountType.polygon:
      case AccountType.binance:
        final seedHex = bip393.mnemonicToSeedHex(mnemonic);

        final chain = Chain.seed(seedHex);

        final key = chain.forPath("m/44'/60'/0'/0/$derivePathIndex");
        final Credentials credentials =
            EthPrivateKey.fromHex(key.privateKeyHex());

        final walletAddress = await credentials.extractAddress();

        return walletAddress.hex;

      case AccountType.ssi:
        throw Exception();
    }
  }

  Future<String> walletAddressFromSecretKey({
    required String secretKey,
    required AccountType accountType,
  }) async {
    switch (accountType) {
      case AccountType.tezos:
        final keystore = Keystore.fromSecretKey(secretKey);

        return keystore.address;

      case AccountType.ethereum:
      case AccountType.fantom:
      case AccountType.polygon:
      case AccountType.binance:
        final ethPrivateKey = EthPrivateKey.fromHex(secretKey);
        final walletAddress = await ethPrivateKey.extractAddress();
        return walletAddress.hex;

      case AccountType.ssi:
        throw Exception();
    }
  }

  Future<String> jwkFromSecretKey({
    required String secretKey,
    required AccountType accountType,
  }) async {
    late Uint8List seedBytes;
    switch (accountType) {
      case AccountType.tezos:
        seedBytes = Uint8List.fromList(
          crypto.decodeWithoutPrefix(secretKey).take(32).toList(),
        );
        break;
      case AccountType.ethereum:
      case AccountType.fantom:
      case AccountType.polygon:
      case AccountType.binance:
      case AccountType.ssi:
        seedBytes = Uint8List.fromList(hexToBytes(secretKey));
    }
    final jwk = jwkFromSeed(
      seedBytes: seedBytes,
      accountType: accountType,
    );
    return jsonEncode(jwk);
  }

  Keystore getKeystore({required String secretKey}) {
    final keystore = Keystore.fromSecretKey(secretKey);
    return keystore;
  }
}
