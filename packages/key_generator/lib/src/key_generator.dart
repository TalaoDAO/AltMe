import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip393;
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:key_generator/key_generator.dart';
import 'package:pinenacl/ed25519.dart';
// ignore: implementation_imports
import 'package:tezart/src/crypto/crypto.dart' as crypto hide Prefixes;
// ignore: implementation_imports, unnecessary_import
import 'package:tezart/src/crypto/crypto.dart' show Prefixes;
import 'package:tezart/tezart.dart';

/// old key generation system
/// commit: 9214f120f6743997d6b466de53a9b65dfe634d88
///   derivation BIP32 "m/44'/60'/0'/0/0"
///       final key = {
//   'kty': 'EC',
//   'crv': 'secp256k1',
//   'd': d,
//   'x': x,
//   'y': y,
//   'alg': 'ES256K' // or 'alg': "ES256K-R" for did:tz
// };

/// tezos supports 3 types of keys (secp256k, ed25519, P-256)
/// solana supports only ed25519
/// ethereum and EVM blockchains supports only ES256K

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

    late KeyData child;

    switch (accountType) {
      case AccountType.ssi:
        child = await ED25519_HD_KEY.derivePath("m/44'/5467'/0'/0'", seed);
        break;

      case AccountType.tezos:
        child = await ED25519_HD_KEY.derivePath(
          "m/44'/1729'/$derivePathIndex'/0'",
          seed,
        );
        break;

      case AccountType.ethereum:
      case AccountType.fantom:
      case AccountType.polygon:
      case AccountType.binance:
        throw Exception();
    }

    final seedBytes = Uint8List.fromList(child.key);

    final key = jwkFromSeed(seedBytes);

    //{"kty":"OKP","crv":"Ed25519","d":"xmYPuZdc1LwVYshIUdto7I8psjb9zgPrUblAp5
    //w7qws=","x":"uCURp8D_ilizA32RCZi1UFoYdq0HmI_KE8RBbG19ZrU="}
    return jsonEncode(key);
  }

  Map<String, String> jwkFromSeed(Uint8List seedBytes) {
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
          accountType: AccountType.tezos,
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
        final seedHex = bip393.mnemonicToSeedHex(mnemonic);

        final chain = Chain.seed(seedHex);

        final key = chain.forPath("m/44'/60'/0'/0/$derivePathIndex");

        final keyHex = key.privateKeyHex();

        return '0x${keyHex.substring(2, keyHex.length)}';

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

  Future<String> jwkFromSecretKey({required String secretKey}) async {
    final newSeedBytes = Uint8List.fromList(
      crypto.decodeWithoutPrefix(secretKey).take(32).toList(),
    );

    final jwk = jwkFromSeed(newSeedBytes);
    return jsonEncode(jwk);
  }

  Keystore getKeystore({required String secretKey}) {
    final keystore = Keystore.fromSecretKey(secretKey);
    return keystore;
  }
}
