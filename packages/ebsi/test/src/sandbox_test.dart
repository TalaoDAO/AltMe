// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip393;

import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:fast_base58/fast_base58.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:jose/jose.dart';
import 'package:json_path/json_path.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  const wellKnownContent =
      r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":false,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';
  const initialQrCodeUrl = 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl';
  const QRCodeContent =
      'openid://initiate_issuance?issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl&credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&op_stat=46cc5d84-9b29-11ed-ae36-0a1628958560';
  const authorizationEndpoint =
      'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize';
  const tokenEndpoint = 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token';
  const credentialEndpoint =
      'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential';

  test('sandbox', () async {
    const cNonce = 'cNonce';
    var did1 = 'did';
    var issuer = 'issuer';
    final payload1 = {
      'iss': did1,
      'nonce': cNonce,
      'iat': DateTime.now().microsecondsSinceEpoch,
      'aud': issuer
    };

    final jwt1 = JWT(
      // Payload
      payload1,

      issuer: issuer,
    );

    const mnemonic =
        'jambon fromage comte camembert pain fleur voiture bac pere mere fille fils';
    final Ebsi ebsi = Ebsi(Dio());
    final Jwk = await ebsi.jwkFromMnemonic(mnemonic: mnemonic);
    final private = jsonDecode(Jwk) as Map<String, dynamic>;
    final public = Map.from(private);
    public.removeWhere((key, value) => key == 'd');

    final hexEncodedNewKey =
        '5AgHMMkzfDxdAHHHmpqjQYLqaKnrXTddWGpMQW8Dsj4391Fm7G79ZutmKwZousSvUWbYsf1W8Q12RAMFjXjDcDs6';
    final newKey = Base58Decode(hexEncodedNewKey);
// Sign it (default with HS256 algorithm)
    final token =
        jwt1.sign(EdDSAPrivateKey(newKey), algorithm: JWTAlgorithm.EdDSA);
// EdDSAPrivateKey
    print('Signed token: $token\n');
    print('toto');

    /// preparation before getting credential
    final keyDict = private;

    final keyJwk = jsonEncode(public);

    final verifierKey = JsonWebKey.fromJson(keyDict);
    final alg = keyDict['crv'] == 'P-256' ? 'ES256' : 'ES256K';
    final did = 'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya';
    final kid =
        'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya#lD7U7tcVLZWmqECJYRyGeLnDcU4ETX3reBN3Zdd0iTU';

    final payload = {
      'iss': did,
      'nonce': cNonce,
      'iat': DateTime.now().microsecondsSinceEpoch,
      'aud': issuer
    };
    final claims = new JsonWebTokenClaims.fromJson(payload);
    // create a builder, decoding the JWT in a JWS, so using a
    // JsonWebSignatureBuilder
    final builder = new JsonWebSignatureBuilder();
    // set the content
    builder.jsonContent = claims.toJson();

    builder.setProtectedHeader('typ', 'JWT');
    builder.setProtectedHeader('alg', alg);
    builder.setProtectedHeader('jwk', keyJwk);
    builder.setProtectedHeader('kid', kid);

    // add a key to sign, can only add one for JWT
    builder.addRecipient(
      verifierKey,
      algorithm: alg,
    );
    // build the jws
    var jws = builder.build();

    // output the compact serialization
    print('jwt compact serialization: ${jws.toCompactSerialization()}');
    final jwt = jws.toCompactSerialization();
    return jwt;
  });
}
