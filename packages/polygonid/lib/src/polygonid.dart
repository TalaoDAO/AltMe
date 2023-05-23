import 'package:bip39/bip39.dart' as bip393;
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import 'package:polygonid/polygonid.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/exceptions/identity_exceptions.dart';
import 'package:polygonid_flutter_sdk/identity/libs/bjj/bjj_wallet.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';

/// {@template polygonid}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class PolygonId {
  /// {@macro polygonid}
  factory PolygonId() {
    return _instance ??= PolygonId._();
  }

  /// private contructor
  PolygonId._();

  /// _instance
  static PolygonId? _instance;

  /// blockchain
  static const blockchain = 'polygon';

  /// network
  static const network = 'mumbai';

  /// isInitialized
  bool isInitialized = false;

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
    if (isInitialized) return;
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
    isInitialized = true;
  }

  /// check if curcuit is already downloaded
  Future<bool> isCircuitsDownloaded() async {
    final isDownloaded =
        await PolygonIdSdk.I.proof.isAlreadyDownloadedCircuitsFromServer();
    return isDownloaded;
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
        final identity = getIdentity(mnemonic: mnemonic);
        return identity;
      } else {
        throw Exception('STH_WENT_WRONG - $e');
      }
    }
  }

  /// get private key from mnemonics
  Future<String> getPrivateKey({
    required String mnemonic,
  }) async {
    final secret = bip393.mnemonicToEntropy(mnemonic);

    final privadoIdWallet = await BjjWallet.createBjjWallet(
      secret: Uint8List.fromList(secret.codeUnits),
    );

    final privateKey = privadoIdWallet.privateKey;
    final epk = HEX.encode(privateKey);
    return epk;
  }

  /// Return The Identity's did identifier with mnemonics
  Future<UserIdentity> getUserIdentity({required String mnemonic}) async {
    final sdk = PolygonIdSdk.I;
    final privateKey = await getPrivateKey(mnemonic: mnemonic);
    final did = await sdk.identity.getDidIdentifier(
      blockchain: blockchain,
      network: network,
      privateKey: privateKey,
    );
    return UserIdentity(did: did, privateKey: privateKey);
  }

  /// Restores an IdentityEntity from a privateKey and encrypted backup
  /// databases associated to the identity
  Future<PrivateIdentityEntity> getIdentity({
    required String mnemonic,
  }) async {
    final sdk = PolygonIdSdk.I;
    final userIdentity = await getUserIdentity(mnemonic: mnemonic);
    final identity = await sdk.identity.restoreIdentity(
      privateKey: userIdentity.privateKey,
      genesisDid: userIdentity.did,
    );
    return identity;
  }

  /// Remove the previously stored identity associated with the identifier
  Future<void> removeIdentity({
    required String genesisDid,
    required String privateKey,
  }) async {
    final sdk = PolygonIdSdk.I;
    final genesisDid = await sdk.identity.getDidIdentifier(
      blockchain: blockchain,
      network: network,
      privateKey: privateKey,
    );
    return sdk.identity.removeIdentity(
      privateKey: privateKey,
      genesisDid: genesisDid,
    );
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
  /// The iden3MessageEntity is the iden3comm message entity
  ///
  /// The did is the unique id of the identity
  ///
  /// The profileNonce is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The privateKey is the key used to access all the sensitive info from the
  /// identity and also to realize operations like generating proofs
  Future<bool> authenticate({
    required Iden3MessageEntity iden3MessageEntity,
    required String mnemonic,
  }) async {
    try {
      final sdk = PolygonIdSdk.I;

      final privateKey = await getPrivateKey(mnemonic: mnemonic);
      final did = await sdk.identity.getDidIdentifier(
        blockchain: blockchain,
        network: network,
        privateKey: privateKey,
      );

      /// Authenticate response from iden3Message sharing the needed
      /// (if any) proofs requested by it
      await sdk.iden3comm.authenticate(
        message: iden3MessageEntity,
        genesisDid: did,
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
  /// The iden3MessageEntity is the iden3comm message entity
  ///
  /// The did is the unique id of the identity
  ///
  /// The profileNonce is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The privateKe] is the key used to access all the sensitive info from the
  /// identity and also to realize operations like generating proofs
  Future<List<ClaimEntity>> getClaims({
    required Iden3MessageEntity iden3MessageEntity,
    required String mnemonic,
  }) async {
    try {
      final sdk = PolygonIdSdk.I;

      final privateKey = await getPrivateKey(mnemonic: mnemonic);
      final did = await sdk.identity.getDidIdentifier(
        blockchain: blockchain,
        network: network,
        privateKey: privateKey,
      );

      final claimEntities = await sdk.iden3comm.fetchAndSaveClaims(
        message: iden3MessageEntity,
        genesisDid: did,
        privateKey: privateKey,
      );

      return claimEntities;
    } catch (e) {
      throw Exception();
    }
  }

  /// Gets a list of [ClaimEntity] filtered by ids associated to the identity
  /// previously stored in the the Polygon ID Sdk
  ///
  /// The [claimId] is a claim ids to filter by
  Future<List<ClaimEntity>> getClaimById({
    required String claimId,
    required String mnemonic,
  }) async {
    final sdk = PolygonIdSdk.I;

    final privateKey = await getPrivateKey(mnemonic: mnemonic);
    final did = await sdk.identity.getDidIdentifier(
      blockchain: blockchain,
      network: network,
      privateKey: privateKey,
    );

    return sdk.credential.getClaimsByIds(
      claimIds: [claimId],
      genesisDid: did,
      privateKey: privateKey,
    );
  }

  /// Backup a previously stored [IdentityEntity] from a privateKey
  /// associated to the identity
  ///
  /// Identity privateKey is the key used to access all the sensitive info from
  /// the identity and also to realize operations like generating proofs
  /// using the claims associated to the identity
  ///
  /// Returns a map of profile nonces and
  /// associated encrypted Identity's Databases.
  ///
  /// Throws [IdentityException] if an error occurs.
  ///
  /// The identity will be backed up using the current env set with
  /// [PolygonIdSdk.setEnv]
  Future<String?> backupIdentity({
    required String mnemonic,
  }) async {
    final sdk = PolygonIdSdk.I;
    final userIdentity = await getUserIdentity(mnemonic: mnemonic);
    return sdk.identity.backupIdentity(
      privateKey: userIdentity.privateKey,
      genesisDid: userIdentity.did,
    );
  }

  /// Restores an [IdentityEntity] from a privateKey and encrypted backup
  /// databases associated to the identity
  /// Return an identity as a [PrivateIdentityEntity].
  /// Throws [IdentityException] if an error occurs.
  ///
  /// Identity privateKey is the key used to access all the sensitive info from
  /// the identity and also to realize operations like generating proofs
  /// using the claims associated to the identity
  ///
  ///  The [encryptedDb] is a map of profile nonces and
  ///  associated encrypted Identity's Databases
  ///
  /// The identity will be restored using the current env set with
  /// [PolygonIdSdk.setEnv]
  Future<PrivateIdentityEntity> restoreIdentity({
    required String mnemonic,
    required String encryptedDb,
  }) async {
    final sdk = PolygonIdSdk.I;
    final userIdentity = await getUserIdentity(mnemonic: mnemonic);
    final identity = await sdk.identity.restoreIdentity(
      privateKey: userIdentity.privateKey,
      genesisDid: userIdentity.did,
      encryptedDb: encryptedDb,
    );
    return identity;
  }

  /// Gets a list of [ClaimEntity] associated to the identity previously stored
  /// in the the Polygon ID Sdk
  ///
  /// The list can be filtered by filters
  ///
  /// The genesisDid is the unique id of the identity
  ///
  /// The privateKey is the key used to access all the sensitive info from the
  /// identity and also to realize operations like generating proofs
  Future<List<ClaimEntity>> restoreClaims({
    required PrivateIdentityEntity privateIdentityEntity,
  }) async {
    try {
      final sdk = PolygonIdSdk.I;

      final claimEntities = await sdk.credential.getClaims(
        genesisDid: privateIdentityEntity.did,
        privateKey: privateIdentityEntity.privateKey,
      );

      return claimEntities;
    } catch (e) {
      throw Exception();
    }
  }

  /// getSchemas
  Future<List<Map<String, dynamic>>> getSchemas({
    required Iden3MessageEntity message,
  }) async {
    final sdk = PolygonIdSdk.I;
    return sdk.iden3comm.getSchemas(message: message);
  }

  /// Gets a list of [ClaimEntity] associated to the identity previously stored
  /// in the the Polygon ID Sdk
  ///
  /// The list is be filtered by filters
  ///
  /// The genesisDid is the unique id of the identity
  ///
  /// The privateKey is the key used to access all the sensitive info from the
  /// identity and also to realize operations like generating proofs
  Future<List<ClaimEntity>> getFilteredClaims({
    required Iden3MessageEntity iden3MessageEntity,
    required String mnemonic,
  }) async {
    try {
      final sdk = PolygonIdSdk.I;

      final filters =
          await sdk.iden3comm.getFilters(message: iden3MessageEntity);

      final privateKey = await getPrivateKey(mnemonic: mnemonic);

      final did = await sdk.identity.getDidIdentifier(
        blockchain: blockchain,
        network: network,
        privateKey: privateKey,
      );

      final claimEntities = await sdk.credential.getClaims(
        filters: filters,
        genesisDid: did,
        privateKey: privateKey,
      );

      return claimEntities;
    } catch (e) {
      throw Exception();
    }
  }
}
