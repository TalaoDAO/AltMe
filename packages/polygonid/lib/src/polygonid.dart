import 'package:bip39/bip39.dart' as bip393;
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import 'package:polygonid/src/user_identity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/common/utils/hex_utils.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/proof/request/contract_function_call_body_request.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/proof/response/iden3comm_proof_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/private_identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/exceptions/identity_exceptions.dart';
import 'package:polygonid_flutter_sdk/identity/libs/bjj/bjj_wallet.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/download_info_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:web3dart/web3dart.dart';

/// {@template polygonid}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class PolygonId {
  factory PolygonId({PolygonIdSdk? sdk}) {
    if (sdk != null) {
      _instance.polygonIdSdk = sdk;
    }
    return _instance;
  }

  PolygonId._internal();

  late PolygonIdSdk polygonIdSdk;

  static final PolygonId _instance = PolygonId._internal();

  /// blockchain
  static const blockchain = 'polygon';

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
    required String network,
    required String ipfsUrl,
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
        ipfsUrl: ipfsUrl,
      ),
    );

    polygonIdSdk = PolygonIdSdk.I;
    isInitialized = true;
  }

  /// PolygonId SDK setEnv
  Future<void> setEnv({
    required String web3Url,
    required String web3RdpUrl,
    required String web3ApiKey,
    required String idStateContract,
    required String pushUrl,
    required String network,
    required String ipfsUrl,
  }) {
    return polygonIdSdk.setEnv(
      env: EnvEntity(
        blockchain: blockchain,
        network: network,
        web3Url: web3Url,
        web3RdpUrl: web3RdpUrl,
        web3ApiKey: web3ApiKey,
        idStateContract: idStateContract,
        pushUrl: pushUrl,
        ipfsUrl: ipfsUrl,
      ),
    );
  }

  /// PolygonId SDK getEnv
  Future<EnvEntity> getEnv() async {
    return polygonIdSdk.getEnv();
  }

  /// check if curcuit is already downloaded
  Future<bool> isCircuitsDownloaded() async {
    final isDownloaded =
        await polygonIdSdk.proof.isAlreadyDownloadedCircuitsFromServer();
    return isDownloaded;
  }

  /// init Circuits Download And Get Info Stream
  Stream<DownloadInfo> get initCircuitsDownloadAndGetInfoStream {
    return polygonIdSdk.proof.initCircuitsDownloadAndGetInfoStream;
  }

  /// get private key from mnemonics
  Future<String> getPrivateKey({
    required String mnemonic,
    Uint8List? private,
  }) async {
    late Uint8List privateKey;

    if (private == null) {
      final secret = bip393.mnemonicToEntropy(mnemonic);
      final privadoIdWallet = await BjjWallet.createBjjWallet(
        secret: Uint8List.fromList(secret.codeUnits),
      );
      privateKey = privadoIdWallet.privateKey;
    } else {
      privateKey = private;
    }

    final epk = HEX.encode(privateKey);
    return epk;
  }

  /// Return The Identity's did identifier with mnemonics
  Future<UserIdentity> getUserIdentity({
    required String mnemonic,
    required String network,
    Uint8List? private,
  }) async {
    final privateKey = await getPrivateKey(
      mnemonic: mnemonic,
      private: private,
    );
    final did = await polygonIdSdk.identity.getDidIdentifier(
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
    required String network,
    Uint8List? private,
  }) async {
    final userIdentity = await getUserIdentity(
      mnemonic: mnemonic,
      network: network,
      private: private,
    );
    final identity = await polygonIdSdk.identity.restoreIdentity(
      privateKey: userIdentity.privateKey,
      genesisDid: userIdentity.did,
    );
    return identity;
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
    required String network,
  }) async {
    try {
      final secret = bip393.mnemonicToEntropy(mnemonic);
      final identity = await polygonIdSdk.identity.addIdentity(secret: secret);
      return identity;
    } catch (e) {
      if (e is IdentityAlreadyExistsException) {
        final identity = await getIdentity(
          mnemonic: mnemonic,
          network: network,
        );
        return identity;
      } else {
        throw Exception('ISSUE_WHILE_ADDING_IDENTITY');
      }
    }
  }

  /// Remove the previously stored identity associated with the identifier
  Future<void> removeIdentity({
    required String genesisDid,
    required String privateKey,
    required String network,
  }) async {
    final genesisDid = await polygonIdSdk.identity.getDidIdentifier(
      blockchain: blockchain,
      network: network,
      privateKey: privateKey,
    );
    return polygonIdSdk.identity.removeIdentity(
      privateKey: privateKey,
      genesisDid: genesisDid,
    );
  }

  /// Get a list of public info of [IdentityEntity] associated
  /// to the identities stored in the Polygon ID Sdk.
  Future<List<IdentityEntity>> getIdentities() {
    return polygonIdSdk.identity.getIdentities();
  }

  /// Returns a [Iden3MessageEntity] from an iden3comm message string.
  ///
  /// The [message] is the iden3comm message in string format
  ///
  /// When communicating through iden3comm with an Issuer or Verifier,
  /// iden3comm message string needs to be parsed to a supported
  /// [Iden3MessageEntity] by the Polygon Id Sdk using this method.
  Future<Iden3MessageEntity> getIden3Message({required String message}) {
    return polygonIdSdk.iden3comm.getIden3Message(message: message);
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
    required String network,
    required String mnemonic,
    Uint8List? private,
  }) async {
    try {
      final privateKey = await getPrivateKey(
        mnemonic: mnemonic,
        private: private,
      );

      final did = await polygonIdSdk.identity.getDidIdentifier(
        blockchain: blockchain,
        network: network,
        privateKey: privateKey,
      );

      /// Authenticate response from iden3Message sharing the needed
      /// (if any) proofs requested by it
      await polygonIdSdk.iden3comm.authenticate(
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
    required String network,
    Uint8List? private,
  }) async {
    try {
      final privateKey = await getPrivateKey(
        mnemonic: mnemonic,
        private: private,
      );
      final did = await polygonIdSdk.identity.getDidIdentifier(
        blockchain: blockchain,
        network: network,
        privateKey: privateKey,
      );

      final claimEntities = await polygonIdSdk.iden3comm.fetchAndSaveClaims(
        message: iden3MessageEntity,
        genesisDid: did,
        privateKey: privateKey,
      );

      return claimEntities;
    } catch (e) {
      throw Exception('ISSUE_WHILE_GETTING_CLAIMS');
    }
  }

  /// Gets a list of [ClaimEntity] filtered by ids associated to the identity
  /// previously stored in the the Polygon ID Sdk
  ///
  /// The [claimId] is a claim ids to filter by
  Future<List<ClaimEntity>> getClaimById({
    required String claimId,
    required String mnemonic,
    required String network,
    Uint8List? private,
  }) async {
    final privateKey = await getPrivateKey(
      mnemonic: mnemonic,
      private: private,
    );
    final did = await polygonIdSdk.identity.getDidIdentifier(
      blockchain: blockchain,
      network: network,
      privateKey: privateKey,
    );

    return polygonIdSdk.credential.getClaimsByIds(
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
    required String network,
    Uint8List? private,
  }) async {
    final userIdentity = await getUserIdentity(
      mnemonic: mnemonic,
      network: network,
      private: private,
    );
    return polygonIdSdk.identity.backupIdentity(
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
    required String network,
    Uint8List? private,
  }) async {
    final userIdentity = await getUserIdentity(
      mnemonic: mnemonic,
      network: network,
      private: private,
    );
    final identity = await polygonIdSdk.identity.restoreIdentity(
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
      final claimEntities = await polygonIdSdk.credential.getClaims(
        genesisDid: privateIdentityEntity.did,
        privateKey: privateIdentityEntity.privateKey,
      );

      return claimEntities;
    } catch (e) {
      throw Exception('ISSUE_WHILE_RESTORING_CLAIMS');
    }
  }

  /// getSchemas
  Future<List<Map<String, dynamic>>> getSchemas({
    required Iden3MessageEntity message,
  }) async {
    return polygonIdSdk.iden3comm.getSchemas(message: message);
  }

  /// Get a list of [ClaimEntity] from iden3comm message
  /// stored in Polygon Id Sdk.
  ///
  /// The message is the iden3comm message entity
  ///
  /// The genesisDid is the unique id of the identity
  ///
  /// The profileNonce is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The privateKey is the key used to access all the sensitive info from the
  /// identityn and also to realize operations like generating proofs
  Future<List<ClaimEntity?>> getClaimsFromIden3Message({
    required Iden3MessageEntity iden3MessageEntity,
    required String mnemonic,
    required String network,
    Uint8List? private,
  }) async {
    try {
      final privateKey = await getPrivateKey(
        mnemonic: mnemonic,
        private: private,
      );

      final did = await polygonIdSdk.identity.getDidIdentifier(
        blockchain: blockchain,
        network: network,
        privateKey: privateKey,
      );

      final claimEntities =
          await polygonIdSdk.iden3comm.getClaimsFromIden3Message(
        message: iden3MessageEntity,
        genesisDid: did,
        privateKey: privateKey,
      );

      return claimEntities;
    } catch (e) {
      throw Exception('ISSUE_WHILE_GETTING_CLAIMS');
    }
  }

  /// generateProofByContractFunctionCall
  Future<String> generateProofByContractFunctionCall({
    required String walletAddress,
    required Iden3MessageEntity contractIden3messageEntity,
    required String mnemonic,
    required String network,
    Uint8List? private,
  }) async {
    var challenge = walletAddress;

    if (challenge.toLowerCase().startsWith('0x')) {
      challenge = challenge.substring(2);
    }

    final swappedHex =
        HEX.encode(Uint8List.fromList(HEX.decode(challenge).reversed.toList()));
    challenge = BigInt.parse(swappedHex, radix: 16).toString();

    final userIdentity = await getUserIdentity(
      mnemonic: mnemonic,
      network: network,
      private: private,
    );

    final List<Iden3commProofEntity> response =
        await polygonIdSdk.iden3comm.getProofs(
      message: contractIden3messageEntity,
      genesisDid: userIdentity.did,
      privateKey: userIdentity.privateKey,
      challenge: challenge,
    );

    final body =
        contractIden3messageEntity.body as ContractFunctionCallBodyRequest;

    // after the creation of the proof we send the transaction
    final String to = body.transactionData.contractAddress;
    final Iden3commProofEntity proof = response.first;

    // ignore: lines_longer_than_80_chars
    const ABI =
        // ignore: lines_longer_than_80_chars
        '[ { "inputs": [ { "internalType": "uint64", "name": "requestId", "type": "uint64" }, { "internalType": "uint256[]", "name": "inputs", "type": "uint256[]" }, { "internalType": "uint256[2]", "name": "a", "type": "uint256[2]" }, { "internalType": "uint256[2][2]", "name": "b", "type": "uint256[2][2]" }, { "internalType": "uint256[2]", "name": "c", "type": "uint256[2]" } ], "name": "submitZKPResponse", "outputs": [ { "internalType": "bool", "name": "", "type": "bool" } ], "stateMutability": "nonpayable", "type": "function" } ]';

    final ContractAbi cAbi = ContractAbi.fromJson(ABI, to);
    final DeployedContract dc =
        DeployedContract(cAbi, EthereumAddress.fromHex(to));

    final zkFun = dc.findFunctionsByName('submitZKPResponse');

    final List<BigInt> pubSig = proof.pubSignals.map(BigInt.parse).toList();

    final funcData = zkFun.first.encodeCall([
      BigInt.from(proof.id),
      pubSig,
      [BigInt.parse(proof.proof.piA[0]), BigInt.parse(proof.proof.piA[1])],
      [
        [
          BigInt.parse(proof.proof.piB[0][1]),
          BigInt.parse(proof.proof.piB[0][0]),
        ],
        [
          BigInt.parse(proof.proof.piB[1][1]),
          BigInt.parse(proof.proof.piB[1][0]),
        ]
      ],
      [BigInt.parse(proof.proof.piC[0]), BigInt.parse(proof.proof.piC[1])],
    ]);

    final hexData = HexUtils.bytesToHex(funcData.toList());

    return hexData;
  }
}
