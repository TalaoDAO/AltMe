import 'dart:convert';
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip393;
import 'package:elliptic/elliptic.dart' as elliptic;
import 'package:hex/hex.dart';
import 'package:secp256k1/secp256k1.dart';


 /// create JWK from mnemonic
  String privateKeyFromMnemonic({
    required String mnemonic,
    required int indexValue,
  }) {
    final seed = bip393.mnemonicToSeed(mnemonic);

    final rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'
    final child = rootKey.derivePath(
      "m/44'/5467'/0'/$indexValue'",
    ); //Instance of 'BIP32'
    final Iterable<int> iterable = child.privateKey!;
    final seedBytes = Uint8List.fromList(List.from(iterable));

    final key = jwkFromSeed(
      seedBytes: seedBytes,
    );

    return jsonEncode(key);
  }

 /// create JWK from seed
  Map<String, String> jwkFromSeed({required Uint8List seedBytes}) {
    // generate JWK for secp256k from bip39 mnemonic
    // see https://iancoleman.io/bip39/
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
    /// we were using P-256K for dart library conformance which is
    /// the same as secp256k1, but we are using secp256k1 now
    final jwk = {
      'crv': 'secp256k1',
      'd': d.replaceAll('=', ''),
      'kty': 'EC',
      'x': x.replaceAll('=', ''),
      'y': y.replaceAll('=', ''),
    };
    return jwk;
  }

  String p256PrivateKeyFromMnemonics({
    required String mnemonic,
    required int indexValue,
  }) {
    final seed = bip393.mnemonicToSeed(mnemonic);
    final rootKey = bip32.BIP32.fromSeed(seed);

    final child = rootKey.derivePath("m/44'/5467'/0'/$indexValue'");

    final iterable = child.privateKey!;
    final keySeed = HEX.encode(List.from(iterable));

    // calculate teh pub key
    final ec = elliptic.getP256();
    final priv = elliptic.PrivateKey.fromHex(ec, keySeed);
    final pub = priv.publicKey.toString();

    // format the "d"
    final ad = HEX.decode(priv.toString());
    final d = base64Url.encode(ad);

    // extract the "x"
    final mx = pub.substring(2, 66);

    /// start at 2 to remove first byte of the pub key
    final ax = HEX.decode(mx);
    final x = base64Url.encode(ax);
    // extract the "y"
    final my = pub.substring(66, 130); // last 32 bytes
    final ay = HEX.decode(my);
    final y = base64Url.encode(ay);

    final key = {
      'kty': 'EC',
      'crv': 'P-256',
      'd': d.replaceAll('=', ''),
      'x': x.replaceAll('=', ''),
      'y': y.replaceAll('=', ''),
    };

    return jsonEncode(key);
  }
