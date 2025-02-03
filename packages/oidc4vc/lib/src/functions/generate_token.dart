 import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jose_plus/jose.dart';
import 'package:oidc4vc/src/media_type.dart';
import 'package:oidc4vc/src/proof_header_type.dart';
import 'package:oidc4vc/src/token_parameters.dart';

String generateTokenEdDSA({
    required Map<String, dynamic> payload,
    required Map<String, dynamic> privateKey,
    required String kid,
    required MediaType mediaType,
  }) {
    final d = base64Url.decode(privateKey['d'].toString());
    final x = base64Url.decode(privateKey['x'].toString());

    final secretKey = [...d, ...x];

    final jwt = JWT(
      payload,
      header: {
        'typ': mediaType.typ,
        'alg': 'EdDSA',
        'kid': kid,
      },
    );

    final token = jwt.sign(
      EdDSAPrivateKey(secretKey),
      algorithm: JWTAlgorithm.EdDSA,
    );

    return token;
  }
/// getSignedJwt
  String generateToken({
    required Map<String, dynamic> payload,
    required TokenParameters tokenParameters,
    bool ignoreProofHeaderType = false,
  }) {
    final kty = tokenParameters.privateKey['kty'].toString();

    if (kty == 'OKP') {
      final jwt = generateTokenEdDSA(
        payload: payload,
        privateKey: tokenParameters.privateKey,
        kid: tokenParameters.kid ?? tokenParameters.thumbprint,
        mediaType: tokenParameters.mediaType,
      );

      return jwt;
    } else {
      final vpVerifierClaims = JsonWebTokenClaims.fromJson(payload);
      // create a builder, decoding the JWT in a JWS, so using a
      // JsonWebSignatureBuilder
      final privateKey = Map<String, dynamic>.from(tokenParameters.privateKey);

      if (tokenParameters.privateKey['crv'] == 'secp256k1') {
        privateKey['crv'] = 'P-256K';
      }

      final key = JsonWebKey.fromJson(privateKey);

      final vpBuilder = JsonWebSignatureBuilder()
        // set the content
        ..jsonContent = vpVerifierClaims.toJson()
        ..setProtectedHeader('alg', tokenParameters.alg)

        // add a key to sign, can only add one for JWT
        ..addRecipient(key, algorithm: tokenParameters.alg)
        ..setProtectedHeader('typ', tokenParameters.mediaType.typ);

      if (!ignoreProofHeaderType) {
        /// Proof Header Type is ignored for KB jwt

        switch (tokenParameters.proofHeaderType) {
          case ProofHeaderType.kid:
            vpBuilder.setProtectedHeader(
              'kid',
              tokenParameters.kid ?? tokenParameters.thumbprint,
            );

          case ProofHeaderType.jwk:
            vpBuilder.setProtectedHeader(
              'jwk',
              tokenParameters.publicJWK
                ..removeWhere((key, value) => key == 'use')
                ..removeWhere((key, value) => key == 'alg'),
            );
        }
      }

      // build the jws
      final vpJws = vpBuilder.build();

      // output the compact serialization
      final verifierVpJwt = vpJws.toCompactSerialization();
      return verifierVpJwt;
    }
  }
