// ignore: unnecessary_lambdas

// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'token_parameters_class.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('TokenParameters', () {
    final tokenParametersTest = TokenParameterTest();

    test(
      'public key is P-256K private key without d parameter',
      tokenParametersTest.publicKeyTest,
    );

    test('did EBSI', tokenParametersTest.didTest);

    test('kID EBSI', tokenParametersTest.keyIdTest);

    group('algorithm test', () {
      test(
        "algorithm is ES256K when key's curve is not P-256",
        tokenParametersTest.algorithmIsES256KTest,
      );

      test(
        "algorithm is ES256 when key's curve is P-256",
        tokenParametersTest.algorithmIsES256Test,
      );

      test(
        'if alg is not null then return as it is',
        tokenParametersTest.algorithmIsNotNullTest,
      );
    });

    group('thumbprint test', () {
      test('thumbprint of the public Key', tokenParametersTest.thumprintOfKey);

      test(
        'thumbrprint of the Key from exemple in rfc 7638',
        tokenParametersTest.thumprintOfKeyForrfc7638,
      );
    });

    group('more didKey test', () {
      test('did EBSI from Thierry s key', () {
        final thierryPrivate1 = {
          'crv': 'secp256k1',
          'kty': 'EC',
          'x': 'XMO-urq7MgxkcpQDAJQY84lIO7sTo1Ab-_cqvUyreno',
          'y': 'sRnukSTqSCXUShUyDitq6MvTLr5F1ETs6xnR455WW_g'
        };

        const expectedDid =
            'did:ebsi:zkEcb5YVNX5ZRq3nZVH3FVWePLE6vxbqDattYsGan6iLi';
        final tokenParameters = TokenParameters(thierryPrivate1);
        expect(tokenParameters.didKey, expectedDid);
      });

      test('did EBSI 1 from Thierry vectors', () {
        final thierryPrivate = {
          'crv': 'secp256k1',
          'd': '5DCgRx7Snk-ltE3exxHy94L6LPf8gBSb5_-U8NgRH10',
          'kty': 'EC',
          'x': 'XMO-urq7MgxkcpQDAJQY84lIO7sTo1Ab-_cqvUyreno',
          'y': 'sRnukSTqSCXUShUyDitq6MvTLr5F1ETs6xnR455WW_g'
        };
        const expectedDid =
            'did:ebsi:zkEcb5YVNX5ZRq3nZVH3FVWePLE6vxbqDattYsGan6iLi';
        final tokenParameters = TokenParameters(thierryPrivate);
        expect(tokenParameters.didKey, expectedDid);
      });
      test('did EBSI 2 from Thierry vectors', () {
        final thierryPrivate = {
          'crv': 'secp256k1',
          'd': '2CYcyeeIGExqssjp0W3jzHdoEzSWHGBr0ukO66r0h2g',
          'kty': 'EC',
          'x': 'sg-ra2GWe8qoBIsBL2ZF7HjV71PP02nWuJLnTL2bn7E',
          'y': 'h8F81NtkFSHgyY_KCEjXhDfQEU_Jv0AEHMvR9EW65xs'
        };
        const expectedDid =
            'did:ebsi:zcpweJw1cLnMM4yaWHRGjSKpuyGNq7SSTuQrBLp5tCpEz';
        final tokenParameters = TokenParameters(thierryPrivate);
        expect(tokenParameters.didKey, expectedDid);
      });
      test('did EBSI 3 from Thierry vectors', () {
        final thierryPrivate = {
          'crv': 'secp256k1',
          'd': 'zlZrsHYH8aeaJWu4ptTjNnDhgBGyFc0UguJ8N4zbsdA',
          'kty': 'EC',
          'x': 'hdEzHBKnhigtNoU7nIaxQJWIVTqVcuEZdpOKUzkAfkA',
          'y': 'Gq1zCf9H0_Wyo5nNyjR8IA-XgTkX1PYaBYb2WKYF3PQ'
        };
        const expectedDid =
            'did:ebsi:zgfaTZiwnaK7k4Zf9ce9ydcYQKh76QJcpf2MFDeKYSj1c';
        final tokenParameters = TokenParameters(thierryPrivate);
        expect(tokenParameters.didKey, expectedDid);
      });

      test('did EBSI  from Alice s key', () {
        final aliceKey = {
          'crv': 'P-256',
          'd': 'd_PpSCGQWWgUc1t4iLLH8bKYlYfc9Zy_M7TsfOAcbg8',
          'kty': 'EC',
          'x': 'ngy44T1vxAT6Di4nr-UaM9K3Tlnz9pkoksDokKFkmNc',
          'y': 'QCRfOKlSM31GTkb4JHx3nXB4G_jSPMsbdjzlkT_UpPc',
        };

        const expectedDid =
            'did:ebsi:znxntxQrN369GsNyjFjYb8fuvU7g3sJGyYGwMTcUGdzuy';
        final tokenParameters = TokenParameters(aliceKey);
        expect(tokenParameters.didKey, expectedDid);
      });
    });
  });
}
