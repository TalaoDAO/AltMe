import 'package:ebsi/src/token_parameters.dart';
import 'package:flutter_test/flutter_test.dart';

import '../const_values.dart';

class TokenParameterTest {
  final tokenParameters = TokenParameters(privateKey);

  void publicKeyTest() {
    expect(tokenParameters.publicJWK, publicJWK);
  }

  void didTest() {
    expect(tokenParameters.didKey, didKey);
  }

  void keyIdTest() {
    expect(tokenParameters.kid, kid);
  }

  void algorithmIsES256KTest() {
    expect(tokenParameters.alg, ES256KAlg);
  }

  void algorithmIsES256Test() {
    final tokenParameters = TokenParameters(privateKey2);
    expect(tokenParameters.alg, ES256Alg);
  }

  void algorithmIsNotNullTest() {
    final tokenParameters = TokenParameters(keyWithAlg);
    expect(tokenParameters.alg, HS256Alg);
  }

  void thumprintOfKey() {
    expect(tokenParameters.thumbprint, thumbprint);
  }

  void thumprintOfKeyForrfc7638() {
    final tokenParameters = TokenParameters(rfc7638Jwk);
    expect(tokenParameters.thumbprint, expectedThumbprintForrfc7638Jwk);
  }
}
