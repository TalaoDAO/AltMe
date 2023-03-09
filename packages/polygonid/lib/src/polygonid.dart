import 'dart:convert';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip393;
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:secp256k1/secp256k1.dart';

/// {@template polygonid}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class PolygonId {
  /// {@macro polygonid}
  PolygonId();

  /// PolygonId SDK initialization
  /// Before you can start using the SDK, you need to initialise it, otherwise
  /// a PolygonIsSdkNotInitializedException exception will be thrown.

  Future<void> init() async {
    await PolygonIdSdk.init();
  }

  /// Create Identity
  ///
  /// blockchain and network are not optional, they are used to associate the
  /// identity to a specific blockchain network.
  ///
  /// it is recommended to securely save the privateKey generated with
  /// createIdentity(), this will often be used within the sdk methods as a
  /// security system, you can find the privateKey in the PrivateIdentityEntity
  /// object.
  ///

  Future<void> createIdentity() async {
    //we get the sdk instance previously initialized
    final sdk = PolygonIdSdk.I;
    final identity = await sdk.identity.createIdentity(
      blockchain: 'polygon',
      network: 'main',
    );
    print(identity.did);
  }

  /// create JWK from mnemonic
  Future<String> privateKeyFromMnemonic({required String mnemonic}) async {
    final seed = bip393.mnemonicToSeed(mnemonic);

    final rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'
    final child = rootKey.derivePath(
      "m/44'/5467'/0'/2'",
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
      'd': d,
      'kty': 'EC',
      'x': x,
      'y': y,
    };
    return jwk;
  }
}
