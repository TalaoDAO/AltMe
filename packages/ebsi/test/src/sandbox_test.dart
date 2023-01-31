// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: unused_local_variable, lines_longer_than_80_chars

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:jose/jose.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  // const wellKnownContent =
  //     r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":false,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';
  // const initialQrCodeUrl = 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl';
  // const QRCodeContent =
  //     'openid://initiate_issuance?issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl&credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&op_stat=46cc5d84-9b29-11ed-ae36-0a1628958560';
  // const authorizationEndpoint =
  //     'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize';
  // const tokenEndpoint = 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token';
  // const credentialEndpoint =
  //     'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential';

  test('sandbox', () async {
    const cNonce = '4c7ef41a-a0c4-11ed-a524-0a1628958560';
    const issuer = 'issuer';

    const mnemonic =
        'scatter spread layer various cry limit trial excess normal bid stem foot';
    final ebsi = Ebsi(Dio());
    final jwk = await ebsi.privateFromMnemonic(mnemonic: mnemonic);
    final private = jsonDecode(jwk) as Map<String, dynamic>;
    final public = Map.of(private)..removeWhere((key, value) => key == 'd');

    /// preparation before getting credential
    final keyJwk = jsonEncode(public);

    final verifierKey = JsonWebKey.fromJson(private);
    final alg = private['crv'] == 'P-256' ? 'ES256' : 'ES256K';
    final did = ebsi.getDidFromPrivate(public);
    final kid = ebsi.getKidFromJwk(public);

    final payload = {
      'iss': did,
      'nonce': cNonce,
      'iat': DateTime.now().microsecondsSinceEpoch,
      'aud': issuer
    };
    final claims = JsonWebTokenClaims.fromJson(payload);
    // create a builder, decoding the JWT in a JWS, so using a
    // JsonWebSignatureBuilder
    final builder = JsonWebSignatureBuilder()
      // set the content
      ..jsonContent = claims.toJson()
      ..setProtectedHeader('typ', 'JWT')
      ..setProtectedHeader('alg', alg)
      ..setProtectedHeader('jwk', keyJwk)
      ..setProtectedHeader('kidverifierKey', kid)

      // add a key to sign, can only add one for JWT
      ..addRecipient(
        verifierKey,
        algorithm: alg,
      );
    // build the jws
    final jws = builder.build();

    // output the compact serialization
    final jwt = jws.toCompactSerialization();

    /// let's verify and validate this token

    final jwtForDecodeAndVerify = JsonWebToken.unverified(jwt);
    // output the claims

    // create key store to verify the signature
    final keyStore = JsonWebKeyStore()..addKey(JsonWebKey.fromJson(private));

    final verified = await jwtForDecodeAndVerify.verify(keyStore);

    // alternatively, create and verify the JsonWebToken together, this is also
    // applicable for JWT inside JWE
    // final jwtOneGo = await JsonWebToken.decodeAndVerify(jwt, keyStore);

    // // validate the claims
    // var violations = jwtOneGo.claims.validate(issuer: Uri.parse(issuer));
    // print("violations: $violations");
  });

  test('test vector', () {
    const expectedDid =
        'did:ebsi:ztMVxH9gTfWxLVePz348Rme8fZqNL5vn7wJ8Ets2fAgSX';
    const expectedKid =
        'did:ebsi:ztMVxH9gTfWxLVePz348Rme8fZqNL5vn7wJ8Ets2fAgSX#-wRjA5dN5TJvZH_epIsrzZvAt28DHwPXloQvMVWevqw';
    const key = {
      'crv': 'secp256k1',
      'd': 'btbbhfOMozv735FBv1vE7oajjrvgjOmFz0RPPrKGIhI',
      'kty': 'EC',
      'x': 'jueEqLxxzNYzjuitj-6wQVjMKHtbVkz336BWmrv2n5k',
      'y': 'fy-awzXPdLe_AzKvDHWMWxpVvDsXv_jZ3WcOxdaZ5CQ',
    };
    final ebsi = Ebsi(Dio());
    final public = Map.of(key)..removeWhere((key, value) => key == 'd');
    final did = ebsi.getDidFromPrivate(public);
    // public.removeWhere((key, value) => key == 'alg');
    final kid = ebsi.getKidFromJwk(public);
    expect(did, expectedDid);
    // expect(kid, expectedKid);
  });

  test('ES256K ou secp256k1', () {
    const key1 = {
      'crv': 'P-256K',
      'd': 'btbbhfOMozv735FBv1vE7oajjrvgjOmFz0RPPrKGIhI',
      'kty': 'EC',
      'x': 'jueEqLxxzNYzjuitj-6wQVjMKHtbVkz336BWmrv2n5k',
      'y': 'fy-awzXPdLe_AzKvDHWMWxpVvDsXv_jZ3WcOxdaZ5CQ',
    };
    final verifierKey1 = JsonWebKey.fromJson(key1);

    const key2 = {
      'crv': 'secp256k1',
      'd': 'btbbhfOMozv735FBv1vE7oajjrvgjOmFz0RPPrKGIhI',
      'kty': 'EC',
      'x': 'jueEqLxxzNYzjuitj-6wQVjMKHtbVkz336BWmrv2n5k',
      'y': 'fy-awzXPdLe_AzKvDHWMWxpVvDsXv_jZ3WcOxdaZ5CQ',
    };
    // final verifierKey2 = JsonWebKey.fromJson(key2);
  });

  test('jose example with example key', () async {
    const mnemonic =
        'scatter spread layer various cry limit trial excess normal bid stem foot';
    final ebsi = Ebsi(Dio());
    // final private = await ebsi.jwkFromMnemonic(mnemonic: mnemonic);
    final private = {
      'kty': 'oct',
      'k':
          'AyM1SysPpbyDfgZld3umj1qzKObwVMkoqQ-EstJQLr_T-1qS0gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr1Z9CAow'
    };
    final public = {
      'kty': 'oct',
      'k':
          'AyM1SysPpbyDfgZld3umj1qzKObwVMkoqQ-EstJQLr_T-1qS0gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr1Z9CAow'
    };
    await codeDecodeAndVerifyJwt(private, public, 'HS256');
  });
  test('jose example with P-256K key', () async {
    const mnemonic =
        'scatter spread layer various cry limit trial excess normal bid stem foot';
    final ebsi = Ebsi(Dio());
    final jwk = await ebsi.privateFromMnemonic(mnemonic: mnemonic);
    final private = jsonDecode(jwk) as Map<String, dynamic>;
    final public = Map.of(private)..removeWhere((key, value) => key == 'd');
    await codeDecodeAndVerifyJwt(private, public, 'ES256K');
  });
}

Future<void> codeDecodeAndVerifyJwt(
  Map<String, dynamic> private,
  Map<String, dynamic> public,
  String alg,
) async {
  final ebsi = Ebsi(Dio());
  final claims = JsonWebTokenClaims.fromJson({
    'exp': const Duration(hours: 4).inSeconds,
    'iss': ebsi.getDidFromPrivate(private),
  });
  final kid = ebsi.getKidFromJwk(private);
  public.addAll({'kid': kid});
  // create a builder, decoding the JWT in a JWS, so using a
  // JsonWebSignatureBuilder
  final builder = JsonWebSignatureBuilder()

    // set the content
    ..jsonContent = claims.toJson()
    ..setProtectedHeader('typ', 'JWT')
    ..setProtectedHeader('alg', alg)
    ..setProtectedHeader('jwk', private)
    ..setProtectedHeader('kid', kid)

    // add a key to sign, can only add one for JWT
    ..addRecipient(JsonWebKey.fromJson(private), algorithm: alg);

  // build the jws
  final jws = builder.build();

  // output the compact serialization
  final encoded = jws.toCompactSerialization();

  // decode the jwt, note: this constructor can only be used for JWT inside JWS
  // structures
  var jwt = JsonWebToken.unverified(encoded);

  // output the claims

  // create key store to verify the signature
  final keyStore = JsonWebKeyStore()..addKey(JsonWebKey.fromJson(public));
  final verified = await jwt.verify(keyStore);

  // alternatively, create and verify the JsonWebToken together, this is also
  // applicable for JWT inside JWE
  jwt = await JsonWebToken.decodeAndVerify(encoded, keyStore);

  // validate the claims
  final violations =
      jwt.claims.validate(issuer: Uri.parse(ebsi.getDidFromPrivate(private)));
}
