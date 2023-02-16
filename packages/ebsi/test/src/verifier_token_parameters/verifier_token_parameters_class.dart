import 'package:ebsi/ebsi.dart';
import 'package:flutter_test/flutter_test.dart';

import '../const_values.dart';
import '../token_parameters/token_parameters_class.dart';

class VerifierTokenParametersTest extends TokenParameterTest {
  final verifierTokenParameters =
      VerifierTokenParameters(privateKey, Uri.parse(''), []);

  @override
  void publicKeyTest() {
    expect(verifierTokenParameters.publicJWK, publicJWK);
  }

  @override
  void didTest() {
    expect(tokenParameters.didKey, didKey);
  }

  @override
  void keyIdTest() {
    expect(tokenParameters.kid, kid);
  }

  @override
  void algorithmIsES256KTest() {
    expect(tokenParameters.alg, ES256KAlg);
  }

  @override
  void algorithmIsES256Test() {
    final tokenParameters =
        VerifierTokenParameters(privateKey2, Uri.parse(''), []);
    expect(tokenParameters.alg, ES256Alg);
  }

  @override
  void algorithmIsNotNullTest() {
    final tokenParameters =
        VerifierTokenParameters(keyWithAlg, Uri.parse(''), []);
    expect(tokenParameters.alg, HS256Alg);
  }

  @override
  void thumprintOfKey() {
    expect(tokenParameters.thumbprint, thumbprint);
  }

  @override
  void thumprintOfKeyForrfc7638() {
    final tokenParameters2 =
        VerifierTokenParameters(rfc7638Jwk, Uri.parse(''), []);
    expect(tokenParameters2.thumbprint, expectedThumbprintForrfc7638Jwk);
  }
}
