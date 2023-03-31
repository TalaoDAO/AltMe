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
  Future<PrivateIdentityEntity> addIdentity({required String mnemonic}) async {
    try {
      final sdk = PolygonIdSdk.I;
      final secret = bip393.mnemonicToEntropy(mnemonic);
      final identity = await sdk.identity.addIdentity(secret: secret);
      return identity;
    } catch (e) {
      if (e is IdentityAlreadyExistsException) {
        final privateKey =
            await keccak256privateKeyFromSecret(mnemonic: mnemonic);
        final identity = getIdentity(privateKey: privateKey);
        return identity;
      } else {
        throw Exception('STH_WENT_WRONG');
      }
    }
  }

  /// get private key from mnemonics
  Future<String> keccak256privateKeyFromSecret({
    required String mnemonic,
  }) async {
    final secret = bip393.mnemonicToEntropy(mnemonic);
    const accessMessage =
        r'PrivadoId account access.\n\nSign this message if you are in a trusted application only.';
    final privadoIdWallet = await PrivadoIdWallet.createPrivadoIdWallet(
      accessMessage: accessMessage,
      secret: Uint8List.fromList(secret.codeUnits),
    );

    final privateKey = privadoIdWallet.privateKey;
    final epk = HEX.encode(privateKey);
    return epk;
  }

  /// Return The Identity's did identifier with mnemonics
  Future<String> getDidFromMnemonics({required String mnemonic}) async {
    final sdk = PolygonIdSdk.I;
    final privateKey = await keccak256privateKeyFromSecret(mnemonic: mnemonic);
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

  /// Authenticate response from iden3Message sharing the needed
  /// (if any) proofs requested by it
  ///
  /// The message is the iden3comm message entity
  ///
  /// The did is the unique id of the identity
  ///
  /// The profileNonce is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The privateKey is the key used to access all the sensitive info from the identity
  /// and also to realize operations like generating proofs
  Future<bool> authenticate({
    required Iden3MessageEntity iden3MessageEntity,
    required String mnemonic,
  }) async {
    try {
      final sdk = PolygonIdSdk.I;

      final privateKey =
          await keccak256privateKeyFromSecret(mnemonic: mnemonic);
      final did = await sdk.identity.getDidIdentifier(
        blockchain: blockchain,
        network: network,
        privateKey: privateKey,
      );

      /// Authenticate response from iden3Message sharing the needed
      /// (if any) proofs requested by it
      await sdk.iden3comm.authenticate(
        message: iden3MessageEntity,
        did: did,
        privateKey: privateKey,
      );
      return true;
    } catch (e) {
      return false;
    }
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
    required Iden3MessageEntity iden3MessageEntity,
    required String mnemonic,
  }) async {
    final sdk = PolygonIdSdk.I;

    final privateKey = await keccak256privateKeyFromSecret(mnemonic: mnemonic);
    final did = await sdk.identity.getDidIdentifier(
      blockchain: blockchain,
      network: network,
      privateKey: privateKey,
    );

    final claimEntities = await sdk.iden3comm.fetchAndSaveClaims(
      message: iden3MessageEntity,
      did: did,
      privateKey: privateKey,
    );

    print(claimEntities);
  }
}
