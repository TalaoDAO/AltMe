// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';

import '../test_class.dart';

void main() {
  group('override test', () {
    final issuerTokenParameterTest = IssuerTokenParameterTest();

    test(
      'public key is P-256K private key without d parameter',
      issuerTokenParameterTest.publicKeyTest,
    );

    test('did EBSI', issuerTokenParameterTest.didTest);

    test('kID EBSI', issuerTokenParameterTest.keyIdTest);

    group('algorithm test', () {
      test(
        "algorithm is ES256K when key's curve is not P-256",
        issuerTokenParameterTest.algorithmIsES256KTest,
      );

      test(
        "algorithm is ES256 when key's curve is P-256",
        issuerTokenParameterTest.algorithmIsES256Test,
      );
    });

    group('thumbprint test', () {
      test(
        'thumbprint of the public Key',
        issuerTokenParameterTest.thumprintOfKey,
      );

      test(
        'thumbrprint of the Key from exemple in rfc 7638',
        issuerTokenParameterTest.thumprintOfKeyForrfc7638,
      );
    });
  });
}
