import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:tezart/src/crypto/crypto.dart' as crypto hide Prefixes;
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

class KeyGenerator {
  static const Prefixes _seedPrefix = Prefixes.edsk2;

  Future<String> jwkFromMnemonic(String mnemonic) async {
    //notice photo opera keen climb agent soft parrot best joke field devote
    final seed = bip39.mnemonicToSeed(mnemonic);

    /// Here we use same derivation as temple
    final child = await ED25519_HD_KEY.derivePath("m/44'/1729'/0'/0'", seed);

    // TODO(hawkbee): create ticket: change derivation
    // depending on user selection.
    // Will be used for kukai key import by example

    // TODO(@all): Multiple account preparation:
    // derivation example with 3 accounts
    //    final child = await ED25519_HD_KEY.derivePath("m/44'/1729'/0'/0'", seed);
    //    final child = await ED25519_HD_KEY.derivePath("m/44'/1729'/1'/0'", seed);
    //  final child = await ED25519_HD_KEY.derivePath("m/44'/1729'/2'/0'", seed);

    final seedBytes = Uint8List.fromList(child.key);

    final key = jwkFromSeed(seedBytes);

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

  Future<String> secretKeyFromMnemonic(String mnemonic) async {
    final key = await jwkFromMnemonic(mnemonic);

    // ignore: avoid_dynamic_calls
    final d = jsonDecode(key)['d'] as String;

    final dBytes = base64Url.decode(d);

    final tezosSeed =
        crypto.encodeWithPrefix(prefix: _seedPrefix, bytes: dBytes);

    final tezosSecretKey = crypto.seedToSecretKey(tezosSeed);

    return tezosSecretKey;
  }

  Future<String> tz1AddressFromMnemonic(String mnemonic) async {
    final key = await jwkFromMnemonic(mnemonic);

    // ignore: avoid_dynamic_calls
    final d = jsonDecode(key)['d'] as String;

    final dBytes = base64Url.decode(d);

    final tezosSeed =
        crypto.encodeWithPrefix(prefix: _seedPrefix, bytes: dBytes);

    final tezosSecretKey = crypto.seedToSecretKey(tezosSeed);

    return tz1AddressFromSecretKey(tezosSecretKey);
  }

  Future<String> jwkFromSecretKey(String secretKey) async {
    final newSeedBytes = Uint8List.fromList(
      crypto.decodeWithoutPrefix(secretKey).take(32).toList(),
    );

    final jwk = jwkFromSeed(newSeedBytes);

    return jsonEncode(jwk);
  }

  Future<String> tz1AddressFromSecretKey(String secretKey) async {
    final keystore = Keystore.fromSecretKey(secretKey);

    return keystore.address;
  }
}
