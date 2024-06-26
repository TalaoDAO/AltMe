import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

import '../const_values.dart';
import '../token_parameters/token_parameters_class.dart';

class VerifierTokenParametersTest extends TokenParameterTest {
  final verifierTokenParameters = VerifierTokenParameters(
    privateKey: privateKey,
    clientId: clientId,
    did: clientId,
    clientType: ClientType.did,
    mediaType: MediaType.proofOfOwnership,
    proofHeaderType: ProofHeaderType.kid,
    audience: '',
    credentials: [],
    kid: '',
    nonce: '',
  );

  @override
  void publicKeyTest() {
    expect(verifierTokenParameters.publicJWK, publicJWK);
  }

  @override
  void didTest() {
    expect(tokenParameters.did, clientId);
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
    final tokenParameters = VerifierTokenParameters(
      privateKey: privateKey2,
      clientId: clientId,
      did: clientId,
      clientType: ClientType.did,
      mediaType: MediaType.proofOfOwnership,
      proofHeaderType: ProofHeaderType.kid,
      audience: '',
      credentials: [],
      kid: '',
      nonce: '',
    );
    expect(tokenParameters.alg, ES256Alg);
  }

  @override
  void algorithmIsNotNullTest() {
    final tokenParameters = VerifierTokenParameters(
      privateKey: keyWithAlg,
      clientId: clientId,
      did: clientId,
      clientType: ClientType.did,
      mediaType: MediaType.proofOfOwnership,
      proofHeaderType: ProofHeaderType.kid,
      audience: '',
      credentials: [],
      kid: '',
      nonce: '',
    );
    expect(tokenParameters.alg, HS256Alg);
  }

  @override
  void thumprintOfKey() {
    expect(tokenParameters.thumbprint, thumbprint);
  }

  @override
  void thumprintOfKeyForrfc7638() {
    final tokenParameters2 = VerifierTokenParameters(
      privateKey: rfc7638Jwk,
      clientId: clientId,
      did: clientId,
      clientType: ClientType.did,
      mediaType: MediaType.proofOfOwnership,
      proofHeaderType: ProofHeaderType.kid,
      audience: '',
      credentials: [],
      kid: '',
      nonce: '',
    );
    expect(tokenParameters2.thumbprint, expectedThumbprintForrfc7638Jwk);
  }
}
