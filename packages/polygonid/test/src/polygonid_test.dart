// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polygonid/polygonid.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';

class MockPolygonIdSdk extends Mock implements PolygonIdSdk {}

void main() {
  final MockPolygonIdSdk polygonIdSdk = MockPolygonIdSdk();
  final PolygonId polygonId = PolygonId(polygonIdSdk: polygonIdSdk);

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
  });
}
