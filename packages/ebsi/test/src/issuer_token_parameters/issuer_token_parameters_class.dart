import 'package:ebsi/ebsi.dart';
import 'package:flutter_test/flutter_test.dart';

import '../const_values.dart';
import '../token_parameters/token_parameters_class.dart';

class IssuerTokenParameterTest extends TokenParameterTest {
  final issuerTokenParameters = IssuerTokenParameters(privateKey, '');

  @override
  void publicKeyTest() {
    expect(issuerTokenParameters.publicJWK, publicJWK);
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
    final tokenParameters = IssuerTokenParameters(privateKey2, '');
    expect(tokenParameters.alg, ES256Alg);
  }

  @override
  void algorithmIsNotNullTest() {
    final tokenParameters = IssuerTokenParameters(keyWithAlg, '');
    expect(tokenParameters.alg, HS256Alg);
  }

  @override
  void thumprintOfKey() {
    expect(tokenParameters.thumbprint, thumbprint);
  }

  @override
  void thumprintOfKeyForrfc7638() {
    final tokenParameters2 = IssuerTokenParameters(rfc7638Jwk, '');
    expect(tokenParameters2.thumbprint, expectedThumbprintForrfc7638Jwk);
  }
}
