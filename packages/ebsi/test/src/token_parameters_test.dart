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

class MockDio extends Mock implements Dio {}

void main() {
  group('TokenParameters', () {
    const privateKey = {
      'crv': 'P-256K',
      'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
      'kty': 'EC',
      'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
      'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
    };

    const publicJWK = {
      'crv': 'P-256K',
      'kty': 'EC',
      'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
      'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
    };

    const didKey = 'did:ebsi:zo9FR1YfAKFP3Q6dvqhxcXxnfeDiJDP97kmnqhyAUSACj';

    const kid =
        '''did:ebsi:zo9FR1YfAKFP3Q6dvqhxcXxnfeDiJDP97kmnqhyAUSACj#Cgcg1y9xj9uWFw56PMc29XBd9EReixzvnftBz8JwQFiB''';

    const ES256Alg = 'ES256';

    const ES256KAlg = 'ES256K';

    const thumbprint = [
      173,
      150,
      139,
      1,
      202,
      186,
      32,
      132,
      51,
      6,
      216,
      230,
      103,
      154,
      26,
      196,
      52,
      23,
      248,
      132,
      91,
      7,
      58,
      174,
      149,
      38,
      148,
      157,
      199,
      122,
      118,
      36,
    ];

    final tokenParameters = TokenParameters(privateKey);

    test('public key is P-256K private key without d parameter', () {
      expect(tokenParameters.publicJWK, publicJWK);
    });

    test('did EBSI', () {
      expect(tokenParameters.didKey, didKey);
    });

    test('kid EBSI', () {
      expect(tokenParameters.kid, kid);
    });

    group('algorithm test', () {
      test("algorithm is ES256K when key's curve is not P-256", () {
        expect(tokenParameters.alg, ES256KAlg);
      });

      test("algorithm is ES256 when key's curve is P-256", () {
        const privateKey2 = {
          'crv': 'P-256',
          'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
          'kty': 'EC',
          'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
          'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
        };
        final tokenParameters2 = TokenParameters(privateKey2);
        expect(tokenParameters2.alg, ES256Alg);
      });
    });

    group('thumbprint test', () {
      test('thumbprint of the public Key', () {
        expect(tokenParameters.thumbprint, thumbprint);
      });

      test('thumbrprint of the Key from exemple in rfc 7638', () {
        const rfc7638Jwk = {
          'e': 'AQAB',
          'kty': 'RSA',
          'n':
              // ignore: lines_longer_than_80_chars
              '0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw'
        };
        const expectedThumbprint = [
          55,
          54,
          203,
          177,
          120,
          124,
          184,
          48,
          156,
          119,
          238,
          140,
          55,
          5,
          197,
          225,
          111,
          251,
          158,
          133,
          151,
          21,
          144,
          31,
          30,
          76,
          89,
          177,
          17,
          130,
          245,
          123
        ];
        final tokenParameters2 = TokenParameters(rfc7638Jwk);
        expect(tokenParameters2.thumbprint, expectedThumbprint);
      });
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
