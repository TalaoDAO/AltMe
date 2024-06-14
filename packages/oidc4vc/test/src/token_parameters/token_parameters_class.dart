import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

import '../const_values.dart';

class TokenParameterTest {
  final tokenParameters = TokenParameters(
    privateKey: privateKey,
    clientId: clientId,
    did: clientId,
    clientType: ClientType.did,
    mediaType: MediaType.proofOfOwnership,
    proofHeaderType: ProofHeaderType.kid,
    kid: '',
  );

  void publicKeyTest() {
    expect(tokenParameters.publicJWK, publicJWK);
  }

  void didTest() {
    expect(tokenParameters.did, clientId);
  }

  void keyIdTest() {
    expect(tokenParameters.kid, kid);
  }

  void algorithmIsES256KTest() {
    expect(tokenParameters.alg, ES256KAlg);
  }

  void algorithmIsES256Test() {
    final tokenParameters = TokenParameters(
      privateKey: privateKey2,
      clientId: clientId,
      did: clientId,
      clientType: ClientType.did,
      mediaType: MediaType.proofOfOwnership,
      proofHeaderType: ProofHeaderType.kid,
    );
    expect(tokenParameters.alg, ES256Alg);
  }

  void algorithmIsNotNullTest() {
    final tokenParameters = TokenParameters(
      privateKey: keyWithAlg,
      clientId: clientId,
      did: clientId,
      clientType: ClientType.did,
      mediaType: MediaType.proofOfOwnership,
      proofHeaderType: ProofHeaderType.kid,
    );
    expect(tokenParameters.alg, HS256Alg);
  }

  void thumprintOfKey() {
    expect(tokenParameters.thumbprint, thumbprint);
  }

  void thumprintOfKeyForrfc7638() {
    final tokenParameters = TokenParameters(
      privateKey: rfc7638Jwk,
      clientId: clientId,
      did: clientId,
      clientType: ClientType.did,
      mediaType: MediaType.proofOfOwnership,
      proofHeaderType: ProofHeaderType.kid,
    );
    expect(tokenParameters.thumbprint, expectedThumbprintForrfc7638Jwk);
  }
}
