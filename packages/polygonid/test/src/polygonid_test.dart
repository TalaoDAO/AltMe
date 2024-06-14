// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polygonid/polygonid.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/credential.dart';
import 'package:polygonid_flutter_sdk/sdk/iden3comm.dart';
import 'package:polygonid_flutter_sdk/sdk/identity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk/sdk/proof.dart';

class ConcreteIden3MessageEntity extends Iden3MessageEntity {
  const ConcreteIden3MessageEntity({
    required super.id,
    required super.typ,
    required super.type,
    super.messageType,
    required super.thid,
    required super.from,
    super.to,
    required this.body,
  });

  @override
  final dynamic body;
}

final iden3MessageEntity = ConcreteIden3MessageEntity(
  id: '123',
  typ: 'type',
  type: 'type',
  messageType: Iden3MessageType.authRequest,
  thid: 'thid',
  from: 'from',
  to: 'to',
  body: {'key': 'value'},
);

final downloadInfo = DownloadInfo.onDone(contentLength: 1, downloaded: 1);
const mnemonics =
    '''notice photo opera keen climb agent soft parrot best joke field devote''';

const privateIdentityEntity = PrivateIdentityEntity(
  did: '',
  privateKey: '',
  profiles: {},
  publicKey: [],
);

final privateKey = Uint8List.fromList([
  0x00,
  0x01,
  0x02,
  0x03,
  0x04,
  0x05,
  0x06,
  0x07,
  0x08,
  0x09,
  0x0a,
  0x0b,
  0x0c,
  0x0d,
  0x0e,
  0x0f,
  0x10,
  0x11,
  0x12,
  0x13,
  0x14,
  0x15,
  0x16,
  0x17,
  0x18,
  0x19,
  0x1a,
  0x1b,
  0x1c,
  0x1d,
  0x1e,
  0x1f,
]);

const stringPrivateKey =
    '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f';

const did = 'I am did';

class MockProof extends Mock implements Proof {
  @override
  Future<bool> isAlreadyDownloadedCircuitsFromServer() async {
    return true;
  }

  @override
  Stream<DownloadInfo> get initCircuitsDownloadAndGetInfoStream {
    return Stream.value(downloadInfo);
  }
}

class MockIdentity extends Mock implements Identity {
  @override
  Future<String> getDidIdentifier({
    required String privateKey,
    required String blockchain,
    required String network,
    BigInt? profileNonce,
  }) {
    return Future.value(did);
  }

  @override
  Future<PrivateIdentityEntity> addIdentity({String? secret}) async {
    return Future.value(privateIdentityEntity);
  }

  @override
  Future<void> removeIdentity({
    required String genesisDid,
    required String privateKey,
  }) {
    return Future.value();
  }

  @override
  Future<List<IdentityEntity>> getIdentities() {
    return Future.value([]);
  }

  @override
  Future<PrivateIdentityEntity> restoreIdentity({
    required String genesisDid,
    required String privateKey,
    String? encryptedDb,
  }) {
    return Future.value(privateIdentityEntity);
  }

  @override
  Future<String> backupIdentity({
    required String genesisDid,
    required String privateKey,
  }) {
    return Future.value('ok');
  }
}

class MockCredential extends Mock implements Credential {
  @override
  Future<List<ClaimEntity>> getClaims({
    List<FilterEntity>? filters,
    required String genesisDid,
    required String privateKey,
  }) {
    return Future.value([]);
  }

  @override
  Future<List<ClaimEntity>> getClaimsByIds({
    required List<String> claimIds,
    required String genesisDid,
    required String privateKey,
  }) {
    return Future.value([]);
  }
}

class MockIden3comm extends Mock implements Iden3comm {
  @override
  Future<Iden3MessageEntity> getIden3Message({required String message}) {
    return Future.value(iden3MessageEntity);
  }

  @override
  Future<List<Map<String, dynamic>>> getSchemas({
    required Iden3MessageEntity message,
  }) {
    return Future.value([]);
  }

  @override
  Future<void> authenticate({
    required Iden3MessageEntity message,
    required String genesisDid,
    BigInt? profileNonce,
    required String privateKey,
    String? pushToken,
    Map<int, Map<String, dynamic>>? nonRevocationProofs,
    String? challenge,
  }) {
    return Future.value();
  }

  @override
  Future<List<ClaimEntity>> fetchAndSaveClaims({
    required Iden3MessageEntity message,
    required String genesisDid,
    BigInt? profileNonce,
    required String privateKey,
  }) {
    return Future.value([]);
  }

  @override
  Future<List<ClaimEntity?>> getClaimsFromIden3Message({
    required Iden3MessageEntity message,
    required String genesisDid,
    BigInt? profileNonce,
    required String privateKey,
    Map<int, Map<String, dynamic>>? nonRevocationProofs,
  }) {
    return Future.value([]);
  }
}

class MockPolygonIdSdk extends Mock implements PolygonIdSdk {}

void main() {
  final MockPolygonIdSdk polygonIdSdk = MockPolygonIdSdk();
  final PolygonId polygonId = PolygonId(sdk: polygonIdSdk);

  final proof = MockProof();
  final identity = MockIdentity();
  final credential = MockCredential();
  final iden3comm = MockIden3comm();

  final env = EnvEntity(
    blockchain: 'polygon',
    network: 'network',
    web3Url: 'web3Url',
    web3RdpUrl: 'web3RdpUrl',
    web3ApiKey: 'web3ApiKey',
    idStateContract: 'idStateContract',
    pushUrl: 'pushUrl',
    ipfsUrl: 'ipfsUrl',
  );

  group('PolygonId', () {
    test('can be instantiated', () {
      expect(polygonId, isNotNull);
    });

    test('initialised default value is correct', () {
      expect(PolygonId.blockchain, 'polygon');
      expect(polygonId.isInitialized, false);
    });

    test('setEnv works correctly', () async {
      when(() => polygonIdSdk.setEnv(env: env)).thenAnswer((_) async => {});
      await polygonId.setEnv(
        network: 'network',
        web3Url: 'web3Url',
        web3RdpUrl: 'web3RdpUrl',
        web3ApiKey: 'web3ApiKey',
        idStateContract: 'idStateContract',
        pushUrl: 'pushUrl',
        ipfsUrl: 'ipfsUrl',
      );
      verify(() => polygonIdSdk.setEnv(env: env)).called(1);
    });

    test('getEnv works correctly', () async {
      when(polygonIdSdk.getEnv).thenAnswer((_) async => env);
      final data = await polygonId.getEnv();
      expect(data, env);
      verify(polygonIdSdk.getEnv).called(1);
    });

    test('isCircuitsDownloaded works correctly', () async {
      when(() => polygonIdSdk.proof).thenReturn(proof);
      final data = await polygonId.isCircuitsDownloaded();
      expect(data, true);
    });

    test('initCircuitsDownloadAndGetInfoStream works correctly', () async {
      when(() => polygonIdSdk.proof).thenReturn(proof);
      final stream = polygonId.initCircuitsDownloadAndGetInfoStream;
      final emittedValues = await stream.toList();
      expect(emittedValues, [downloadInfo]);
    });

    test('getPrivateKey returns correct value', () async {
      final data = await polygonId.getPrivateKey(
        mnemonic: mnemonics,
        private: privateKey,
      );
      expect(data, stringPrivateKey);
    });

    test('getUserIdentity returns correct value', () async {
      when(() => polygonIdSdk.identity).thenReturn(identity);
      final data = await polygonId.getUserIdentity(
        mnemonic: mnemonics,
        private: privateKey,
        network: 'polygon',
      );
      expect(data.did, did);
      expect(data.privateKey, stringPrivateKey);
    });

    test('getIdentity returns correct value', () async {
      when(() => polygonIdSdk.identity).thenReturn(identity);
      final data = await polygonId.getIdentity(
        mnemonic: mnemonics,
        private: privateKey,
        network: 'polygon',
      );

      expect(data, privateIdentityEntity);
    });

    test('addIdentity works correctly', () async {
      when(() => polygonIdSdk.identity).thenReturn(identity);
      final data =
          await polygonId.addIdentity(mnemonic: mnemonics, network: 'polygon');
      expect(data, privateIdentityEntity);
    });

    test('getIden3Message works correctly', () async {
      when(() => polygonIdSdk.iden3comm).thenReturn(iden3comm);

      final data = await polygonId.getIden3Message(message: '');
      expect(data, iden3MessageEntity);
    });

    test('removeIdentity works correctly', () async {
      when(() => polygonIdSdk.identity).thenReturn(identity);

      await polygonId.removeIdentity(
        genesisDid: '',
        network: '',
        privateKey: '',
      );
      verify(() => polygonIdSdk.identity.removeIdentity);
    });

    test('authenticate works correctly', () async {
      when(() => polygonIdSdk.iden3comm).thenReturn(iden3comm);
      when(() => polygonIdSdk.identity).thenReturn(identity);

      final data = await polygonId.authenticate(
        iden3MessageEntity: iden3MessageEntity,
        network: 'polygon',
        mnemonic: mnemonics,
        private: privateKey,
      );

      expect(data, true);
    });

    test('authenticate throws Exception', () async {
      when(() => polygonIdSdk.iden3comm).thenReturn(iden3comm);
      when(() => polygonIdSdk.identity).thenReturn(identity);

      final data = await polygonId.authenticate(
        iden3MessageEntity: iden3MessageEntity,
        network: 'polygon',
        mnemonic: mnemonics,
      );

      expect(data, false);
    });

    test('getClaims works correctly', () async {
      when(() => polygonIdSdk.iden3comm).thenReturn(iden3comm);
      when(() => polygonIdSdk.identity).thenReturn(identity);
      final data = await polygonId.getClaims(
        iden3MessageEntity: iden3MessageEntity,
        network: 'polygon',
        mnemonic: mnemonics,
        private: privateKey,
      );
      expect(data, <ClaimEntity>[]);
    });

    test('getClaims throws Exception', () async {
      when(() => polygonIdSdk.iden3comm).thenReturn(iden3comm);
      when(() => polygonIdSdk.identity).thenReturn(identity);
      expect(
        () => polygonId.getClaims(
          iden3MessageEntity: iden3MessageEntity,
          network: 'polygon',
          mnemonic: mnemonics,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getClaimById works correctly', () async {
      when(() => polygonIdSdk.credential).thenReturn(credential);
      when(() => polygonIdSdk.identity).thenReturn(identity);
      final data = await polygonId.getClaimById(
        network: 'polygon',
        mnemonic: mnemonics,
        private: privateKey,
        claimId: '',
      );
      expect(data, <ClaimEntity>[]);
    });

    test('backupIdentity works correctly', () async {
      when(() => polygonIdSdk.identity).thenReturn(identity);
      final data = await polygonId.backupIdentity(
        network: 'polygon',
        mnemonic: mnemonics,
        private: privateKey,
      );
      expect(data, 'ok');
    });

    test('backupIdrestoreIdentityentity works correctly', () async {
      when(() => polygonIdSdk.identity).thenReturn(identity);
      final data = await polygonId.restoreIdentity(
        network: 'polygon',
        mnemonic: mnemonics,
        encryptedDb: '',
        private: privateKey,
      );
      expect(data, privateIdentityEntity);
    });

    test('restoreClaims works correctly', () async {
      when(() => polygonIdSdk.credential).thenReturn(credential);

      final data = await polygonId.restoreClaims(
        privateIdentityEntity: PrivateIdentityEntity(
          did: '',
          privateKey: '',
          profiles: {},
          publicKey: [],
        ),
      );
      expect(data, <ClaimEntity>[]);
    });

    test('getSchemas works correctly', () async {
      when(() => polygonIdSdk.iden3comm).thenReturn(iden3comm);

      final data = await polygonId.getSchemas(message: iden3MessageEntity);
      expect(data, <Map<String, dynamic>>[]);
    });

    test('getClaimsFromIden3Message throws Exception', () async {
      when(() => polygonIdSdk.iden3comm).thenReturn(iden3comm);
      when(() => polygonIdSdk.identity).thenReturn(identity);
      expect(
        () => polygonId.getClaimsFromIden3Message(
          iden3MessageEntity: iden3MessageEntity,
          network: 'polygon',
          mnemonic: mnemonics,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getClaimsFromIden3Message works correctly', () async {
      when(() => polygonIdSdk.iden3comm).thenReturn(iden3comm);
      when(() => polygonIdSdk.identity).thenReturn(identity);
      final data = await polygonId.getClaimsFromIden3Message(
        iden3MessageEntity: iden3MessageEntity,
        network: 'polygon',
        mnemonic: mnemonics,
        private: privateKey,
      );
      expect(data, <ClaimEntity>[]);
    });
  });
}
