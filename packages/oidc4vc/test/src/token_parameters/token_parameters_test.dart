// ignore: unnecessary_lambdas

// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: lines_longer_than_80_chars

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';

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

    test('get alg', () {
      const keyWithAlg = {
        'crv': 'P-256K',
        'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
        'kty': 'EC',
        'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
        'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE',
        'alg': 'HS256',
      };

      final tokenParameters = TokenParameters(
        privateKey: keyWithAlg,
        clientId: '',
        did: '',
        clientType: ClientType.did,
        mediaType: MediaType.proofOfOwnership,
        proofHeaderType: ProofHeaderType.kid,
      );
      expect(tokenParameters.alg, 'HS256');
    });
  });
}
