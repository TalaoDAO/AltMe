import 'dart:convert';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip393;
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/private_identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/exceptions/identity_exceptions.dart';
import 'package:polygonid_flutter_sdk/identity/libs/bjj/privadoid_wallet.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/download_info_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:secp256k1/secp256k1.dart';

/// {@template polygonid}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class PolygonId {
  /// {@macro polygonid}
  PolygonId();

  /// blockchain
  static const blockchain = 'polygon';

  /// network
  static const network = 'mumbai';

  /// PolygonId SDK initialization
  /// Before you can start using the SDK, you need to initialise it, otherwise
  /// a PolygonIsSdkNotInitializedException exception will be thrown.
  Future<void> init({
    required String web3Url,
    required String web3RdpUrl,
    required String web3ApiKey,
    required String idStateContract,
    required String pushUrl,
  }) async {
    await PolygonIdSdk.init(
      env: EnvEntity(
        blockchain: blockchain,
        network: network,
        web3Url: web3Url,
        web3RdpUrl: web3RdpUrl,
        web3ApiKey: web3ApiKey,
        idStateContract: idStateContract,
        pushUrl: pushUrl,
      ),
    );
  }

  /// init Circuits Download And Get Info Stream
  Future<Stream<DownloadInfo>> get initCircuitsDownloadAndGetInfoStream {
    return PolygonIdSdk.I.proof.initCircuitsDownloadAndGetInfoStream;
  }

  /// create JWK from mnemonic
  Future<Uint8List> privateKeyUint8ListFromMnemonic({
    required String mnemonic,
  }) async {
    final seed = bip393.mnemonicToSeed(mnemonic);
    final rootKey = bip32.BIP32.fromSeed(seed);
    final child = rootKey.derivePath("m/44'/5467'/0'/2'");
    return child.privateKey!;
  }

  /// create JWK from mnemonic
  Future<String> privateKeyJWTFromMnemonic({required String mnemonic}) async {
    final seedBytes = await privateKeyUint8ListFromMnemonic(mnemonic: mnemonic);
    final key = jwkFromSeed(seedBytes: seedBytes);
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
  Future<PrivateIdentityEntity> addIdentity({
    required String mnemonic,
  }) async {
    final seedBytes = await privateKeyUint8ListFromMnemonic(mnemonic: mnemonic);
    final secret = String.fromCharCodes(seedBytes);
    try {
      final sdk = PolygonIdSdk.I;
      final identity = await sdk.identity.addIdentity(secret: secret);
      return identity;
    } catch (e) {
      if (e is IdentityAlreadyExistsException) {
        final privateKey =
            await keccak256privateKeyFromSecret(private: seedBytes);
        final identity = getIdentity(privateKey: privateKey);
        return identity;
      } else {
        throw Exception('STH_WENT_WRONG');
      }
    }
  }

  /// get private key from mnemonics
  Future<String> keccak256privateKeyFromSecret({
    required Uint8List private,
  }) async {
    const accessMessage =
        r'PrivadoId account access.\n\nSign this message if you are in a trusted application only.';
    final privadoIdWallet = await PrivadoIdWallet.createPrivadoIdWallet(
      accessMessage: accessMessage,
      secret: private,
    );

    final privateKey = privadoIdWallet.privateKey;
    final epk = HEX.encode(privateKey);
    return epk;
  }

  /// Return The Identity's did identifier with mnemonics
  Future<String> getDidFromMnemonics({
    required String mnemonic,
  }) async {
    final sdk = PolygonIdSdk.I;
    final seedBytes = await privateKeyUint8ListFromMnemonic(mnemonic: mnemonic);
    final privateKey = await keccak256privateKeyFromSecret(private: seedBytes);
    final did = await sdk.identity.getDidIdentifier(
      blockchain: blockchain,
      network: network,
      privateKey: privateKey,
    );
    return did;
  }

  /// Restores an IdentityEntity from a privateKey and encrypted backup databases
  /// associated to the identity
  Future<PrivateIdentityEntity> getIdentity({
    required String privateKey,
  }) async {
    final sdk = PolygonIdSdk.I;
    final identity = await sdk.identity.restoreIdentity(
      privateKey: privateKey,
    );
    return identity;
  }

  /// Remove the previously stored identity associated with the identifier
  Future<void> removeIdentity({
    required String genesisDid,
    required String privateKey,
  }) {
    final sdk = PolygonIdSdk.I;
    return sdk.identity.removeIdentity(privateKey: privateKey);
  }

  /// Get a list of public info of [IdentityEntity] associated
  /// to the identities stored in the Polygon ID Sdk.
  Future<List<IdentityEntity>> getIdentities() {
    final sdk = PolygonIdSdk.I;
    return sdk.identity.getIdentities();
  }

  /// Returns a [Iden3MessageEntity] from an iden3comm message string.
  ///
  /// The [message] is the iden3comm message in string format
  ///
  /// When communicating through iden3comm with an Issuer or Verifier,
  /// iden3comm message string needs to be parsed to a supported
  /// [Iden3MessageEntity] by the Polygon Id Sdk using this method.
  Future<Iden3MessageEntity> getIden3Message({required String message}) {
    final sdk = PolygonIdSdk.I;
    return sdk.iden3comm.getIden3Message(message: message);
  }

  /// Fetch a list of [ClaimEntity] from issuer using iden3comm message
  /// and stores them in Polygon Id Sdk.
  ///
  /// The [message] is the iden3comm message entity
  ///
  /// The did is the unique id of the identity
  ///
  /// The profileNonce is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The privateKe] is the key used to access all the sensitive info from the
  /// identity and also to realize operations like generating proofs
  Future<void> getClaims({
    required String message,
    required String mnemonic,
  }) async {
    final sdk = PolygonIdSdk.I;

    /// When communicating through iden3comm with an Issuer or Verifier,
    /// iden3comm message string needs to be parsed to a supported
    /// [Iden3MessageEntity] by the Polygon Id Sdk using this method.
    final iden3MessageEntity =
        await sdk.iden3comm.getIden3Message(message: message);

    final seedBytes = await privateKeyUint8ListFromMnemonic(mnemonic: mnemonic);
    final privateKey = await keccak256privateKeyFromSecret(private: seedBytes);
    final did = await sdk.identity.getDidIdentifier(
      blockchain: blockchain,
      network: network,
      privateKey: privateKey,
    );
    print('start');

    /// Authenticate response from iden3Message sharing the needed
    /// (if any) proofs requested by it
    await sdk.iden3comm.authenticate(
      message: iden3MessageEntity,
      did: did,
      privateKey: privateKey,
    );
    print('authentizted');

    final claimEntities = await sdk.iden3comm.fetchAndSaveClaims(
      message: iden3MessageEntity,
      did: did,
      privateKey: privateKey,
    );

    //hhttps://github.com/iden3/polygonid-flutter-sdk/issues/243
    //print(claimEntities);
  }
}
