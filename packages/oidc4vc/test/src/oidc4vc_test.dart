//ignore_for_file: lines_longer_than_80_chars
// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';

class MockDio extends Mock implements Dio {}

class MockPkcePair extends Mock implements PkcePair {}

void main() {
  final client = Dio();
  final dioAdapter =
      DioAdapter(dio: Dio(BaseOptions()), matcher: const UrlRequestMatcher());

  client.httpClientAdapter = dioAdapter;

  const mnemonic =
      'position taste mention august skin taste best air sure acoustic poet ritual';

  final oidc4vc = OIDC4VC();
  test('OIDC4VC class can be instantiated', () {
    expect(oidc4vc, isNotNull);
  });

  group('OIDC4VC DID and JWK', () {
    const seedBytes = [
      179,
      252,
      27,
      232,
      71,
      245,
      106,
      183,
      70,
      177,
      62,
      72,
      151,
      165,
      139,
      70,
      244,
      61,
      102,
      237,
      37,
      167,
      178,
      54,
      57,
      92,
      45,
      205,
      62,
      98,
      66,
      154,
    ];

    const expectedECJwk = {
      'crv': 'secp256k1',
      'd': 's_wb6Ef1ardGsT5Il6WLRvQ9Zu0lp7I2OVwtzT5iQpo',
      'kty': 'EC',
      'x': 'qs4JLbsmA-7L-3o9V4BoNVrDtYoWE2OOZIvujoVJZ1U',
      'y': '8PLGROkTALZP3YHY5pm0yrMVCjQoctHM3uaxug70mq8',
    };

    const index = 0;
    test('JWK from mnemonic', () {
      final jwk = oidc4vc.privateKeyFromMnemonic(
        mnemonic: mnemonic,
        indexValue: index,
      );
      expect(jsonDecode(jwk), expectedECJwk);
    });

    test('JWK from seeds', () {
      final jwk = oidc4vc.jwkFromSeed(seedBytes: Uint8List.fromList(seedBytes));
      expect(jwk, expectedECJwk);
    });
  });

  test('P256 JWK from mnemonics', () {
    final jwk = oidc4vc.p256PrivateKeyFromMnemonics(
      mnemonic: mnemonic,
      indexValue: 0,
    );
    final expectedP256Jwk = {
      'kty': 'EC',
      'crv': 'P-256',
      'd': 's_wb6Ef1ardGsT5Il6WLRvQ9Zu0lp7I2OVwtzT5iQpo',
      'x': 'MZZjpNhZGGxqBcPXq499FVC2iu5FcZWwti5u8hgMUaI',
      'y': 'KD4zffV54PZUsQzTzVgoVlWHwKqogRF3JpKQnIGwIRM',
    };

    expect(jsonDecode(jwk), expectedP256Jwk);
  });

  group('edSSA sign and verify test', () {
    const privateKey = {
      'kty': 'OKP',
      'crv': 'Ed25519',
      'd': 'lIxdBQu5EHleLsQRF8JOXAImgNu4FXrUs5SOcyrqvO0=',
      'x': 'r_HVGgBwEcVShl1Xt0C_Anc7Qhs4mS5ZUxsR4kq7Qe4=',
    };

    const payload = {
      'name': 'Bibash',
      'surname': 'Shrestha',
    };

    const kid = '3623b877bbb24b08ba390f3585418f53';

    test('sign and verify with edDSA', () async {
      final token = oidc4vc.generateTokenEdDSA(
        payload: payload,
        privateKey: privateKey,
        kid: kid,
      );

      final value = oidc4vc.verifyTokenEdDSA(
        token: token,
        publicKey: privateKey, // public is private key with d
      );

      expect(value, true);
    });
  });

  group('selective disclosure', () {
    const content =
        '["Qg_O64zqAxe412a108iroA", "phone_number", "+81-80-1234-5678"]';

    const expectedDisclosure =
        'WyJRZ19PNjR6cUF4ZTQxMmExMDhpcm9BIiwgInBob25lX251bWJlciIsICIrODEtODAtMTIzNC01Njc4Il0';

    const expectedHash = 's0BKYsLWxQQeU8tVlltM7MKsIRTrEIa1PkJmqxBBf5U';

    test('get disclosure', () {
      final disclosure = oidc4vc.getDisclosure(content);
      expect(disclosure, expectedDisclosure);
    });

    test('sh256 hash of Disclosure test', () {
      final sha256Hash = oidc4vc.sh256HashOfContent(content);
      expect(sha256Hash, expectedHash);
    });
  });

  group('publicKeyBase58ToPublicJwk', () {
    const publicKeyBase58 = '2S73k5pn5umfnaW31qx6dXFndEn6SmWw7LpgSjNNC5BF';

    final expectedPublicJWK = {
      'crv': 'Ed25519',
      'kty': 'OKP',
      'x': 'FUoLewH4w4-KdaPH2cjZbL--CKYxQRWR05Yd_bIbhQo',
    };

    test('convert publicKeyBase58 to PublicJwk', () {
      final publicKey = oidc4vc.publicKeyBase58ToPublicJwk(publicKeyBase58);
      expect(publicKey, expectedPublicJWK);
    });
  });

  group('EBSI: getAuthorizationUriForIssuer', () {
    const selectedCredentials = ['EmailPass'];
    const clientId =
        'did:jwk:eyJjcnYiOiJQLTI1NiIsImt0eSI6IkVDIiwieCI6IjZka1U2Wk1GSzc5V3dpY3dKNXJieEUxM3pTdWtCWTJPb0VpVlVFanFNRWMiLCJ5IjoiUm5Iem55VmxyUFNNVDdpckRzMTVEOXd4Z01vamlTREFRcGZGaHFUa0xSWSJ9';
    const redirectUri = 'https://app.altme.io/app/download/oidc4vc';

    const issuer = 'https://talao.co/issuer/mfyttabosy';

    const issuerState = 'test7';
    const nonce = '8b60e2fb-87f3-4401-8107-0f0128ea01ab';

    const pkcePair = PkcePair(
      'Pzy4U_sJ0J7VdIAR6JCwL5hbecv30egmJVP81VDFAnk',
      '4KorCwmYyO-_t4i_hva7F3aHGpT_2WqqDh6erimepOA',
    );

    const state =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlVmVyaWZpZXIiOiI0S29yQ3dtWXlPLV90NGlfaHZhN0YzYUhHcFRfMldxcURoNmVyaW1lcE9BIiwiY3JlZGVudGlhbHMiOlsiRW1haWxQYXNzIl0sImlzc3VlciI6Imh0dHBzOi8vdGFsYW8uY28vaXNzdWVyL21meXR0YWJvc3kiLCJpc0VCU0lWMyI6ZmFsc2UsImNsaWVudF9pZCI6ImRpZDpqd2s6ZXlKamNuWWlPaUpRTFRJMU5pSXNJbXQwZVNJNklrVkRJaXdpZUNJNklqWmthMVUyV2sxR1N6YzVWM2RwWTNkS05YSmllRVV4TTNwVGRXdENXVEpQYjBWcFZsVkZhbkZOUldNaUxDSjVJam9pVW01SWVtNTVWbXh5VUZOTlZEZHBja1J6TVRWRU9YZDRaMDF2YW1sVFJFRlJjR1pHYUhGVWEweFNXU0o5IiwiaWF0IjoxNzE0NTQ5OTUxfQ.JJtv8H52NTvPzR3IPET1sXGALdt0yXaQBQbGvDLKNlM';

    const authorizationEndPoint = 'https://app.altme.io/app/download/authorize';

    const openIdConfiguration =
        '{"authorization_server":null,"credential_endpoint":"https://talao.co/issuer/mfyttabosy/credential","credential_issuer":"https://talao.co/issuer/mfyttabosy","subject_syntax_types_supported":["urn:ietf:params:oauth:jwk-thumbprint","did:key","did:ebsi","did:tz","did:pkh","did:hedera","did:key","did:ethr","did:web","did:jwk"],"token_endpoint":"https://talao.co/issuer/mfyttabosy/token","batch_endpoint":null,"authorization_endpoint":"https://talao.co/issuer/mfyttabosy/authorize","subject_trust_frameworks_supported":["ebsi"],"credentials_supported":null,"credential_configurations_supported":{"DBCGuest":{"credential_definition":{"type":["VerifiableCredential","DBCGuest"]},"display":[{"background_color":"#3B6F6D","background_image":{"alt_text":"Connected open cubes in blue with one orange cube as a background of the card","url":"https://i.ibb.co/CHqjxrJ/dbc-card-hig-res.png"},"description":"The DBC Guest credential is a DIIP example.","logo":{"alt_text":"An orange block shape, with the text Dutch Blockchain Coalition next to it, portraying the logo of the Dutch Blockchain Coalition.","url":"https://dutchblockchaincoalition.org/assets/images/icons/Logo-DBC.png"},"name":"DBC Guest (DIIP)","text_color":"#FFFFFF"},{"background_color":"#3B6F6D","background_image":{"alt_text":"Connected open cubes in blue with one orange cube as a background of the card","url":"https://i.ibb.co/CHqjxrJ/dbc-card-hig-res.png"},"description":"The DBC guest credential is a DIIP example.","locale":"en-US","logo":{"alt_text":"An orange block shape, with the text Dutch Blockchain Coalition next to it, portraying the logo of the Dutch Blockchain Coalition.","url":"https://dutchblockchaincoalition.org/assets/images/icons/Logo-DBC.png"},"name":"DBC Guest (DIIP)","text_color":"#FFFFFF"},{"background_color":"#3B6F6D","background_image":{"alt_text":"Connected open cubes in blue with one orange cube as a background of the card","url":"https://i.ibb.co/CHqjxrJ/dbc-card-hig-res.png"},"description":"De DBC gast credential is een DIIP voorbeeld.","locale":"nl-NL","logo":{"alt_text":"Aaneengesloten open blokken in de kleur blauw, met een blok in de kleur oranje, die tesamen de achtergrond van de kaart vormen.","url":"https://dutchblockchaincoalition.org/assets/images/icons/Logo-DBC.png"},"name":"DBC gast (DIIP)","text_color":"#FFFFFF"}],"format":"jwt_vc_json","scope":"DBCGuest_scope"},"EmailPass":{"credential_definition":{"type":["VerifiableCredential","EmailPass"]},"credential_signing_alg_values_supported":["ES256K","ES256","ES384","RS256"],"cryptographic_binding_methods_supported":["DID","jwk"],"display":[{"locale":"en-GB","name":"Proof of Email"}],"format":"jwt_vc_json","scope":"EmailPass_scope"},"EmployeeCredential":{"credential_definition":{"type":["VerifiableCredential","EmployeeCredential"]},"credential_signing_alg_values_supported":["ES256K","ES256","ES384","RS256"],"cryptographic_binding_methods_supported":["DID","jwk"],"display":[{"background_color":"#12107c","locale":"en-US","logo":{"alt_text":"a square logo of a university","url":"https://exampleuniversity.com/public/logo.png"},"name":"Employee Credential","text_color":"#FFFFFF"}],"format":"jwt_vc_json","scope":"EmployeeCredential_scope"},"Over18":{"credential_definition":{"type":["VerifiableCredential","Over18"]},"credential_signing_alg_values_supported":["ES256K","ES256","ES384","RS256"],"cryptographic_binding_methods_supported":["DID","jwk"],"display":[{"locale":"en-GB","name":"Over 18yo proof"},{"locale":"fr-GB","name":"Preuve de majorité"}],"format":"jwt_vc_json","scope":"Over18_scope"},"PhoneProof":{"credential_definition":{"type":["VerifiableCredential","PhoneProof"]},"credential_signing_alg_values_supported":["ES256K","ES256","ES384","RS256"],"cryptographic_binding_methods_supported":["DID","jwk"],"display":[{"locale":"en-GB","name":"Proof of phone number"}],"format":"jwt_vc_json","scope":"PhoneProof_scope"},"VerifiableId":{"credential_definition":{"credentialSubject":{"dateIssued":{"display":[{"locale":"en-US","name":"Issuance date"},{"locale":"fr-FR","name":"Délivré le"}],"mandatory":true},"dateOfBirth":{"display":[{"locale":"en-US","name":"Date of birth"},{"locale":"fr-FR","name":"Né(e) le"}],"mandatory":true},"email":{"display":[{"locale":"en-US","name":"Email"},{"locale":"fr-FR","name":"Email"}],"mandatory":true},"familyName":{"display":[{"locale":"en-US","name":"Family name"},{"locale":"fr-FR","name":"Nom"}],"mandatory":true},"firstName":{"display":[{"locale":"en-US","name":"First name"},{"locale":"fr-FR","name":"Prénom(s)"}],"mandatory":true},"gender":{"display":[{"locale":"en-US","name":"Gender"},{"locale":"fr-FR","name":"Sexe"}],"mandatory":true},"issuing_country":{"display":[{"locale":"en-US","name":"Issuing country"},{"locale":"fr-FR","name":"Délivré par"}],"mandatory":true},"phone_number":{"display":[{"locale":"en-US","name":"Phone number"},{"locale":"fr-FR","name":"Téléphone"}],"mandatory":true}},"order":["firstName","familyName","dateOfBirth","gender","dateIssued","issuing_country","email","phone_number"],"type":["VerifiableCredential","VerifiableId"]},"credential_signing_alg_values_supported":["ES256K","ES256","ES384","RS256"],"cryptographic_binding_methods_supported":["DID","jwk"],"display":[{"background_color":"#12107c","locale":"en-US","name":"Verifiable Id","text_color":"#FFFFFF"}],"format":"jwt_vc_json","scope":"VerifiableId_scope"}},"deferred_credential_endpoint":"https://talao.co/issuer/mfyttabosy/deferred","service_documentation":null,"credential_manifest":null,"credential_manifests":null,"issuer":null,"jwks_uri":"https://talao.co/issuer/mfyttabosy/jwks","grant_types_supported":["authorization_code","urn:ietf:params:oauth:grant-type:pre-authorized_code"]}';

    test(
      'given Url of openid request we return Uri for authentication endpoint',
      () async {
        const expectedAuthorizationEndpoint =
            'https://talao.co/issuer/mfyttabosy/authorize';

        const expectedAuthorizationRequestParemeters = {
          'response_type': 'code',
          'redirect_uri': 'https://app.altme.io/app/download/oidc4vc',
          'state':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlVmVyaWZpZXIiOiI0S29yQ3dtWXlPLV90NGlfaHZhN0YzYUhHcFRfMldxcURoNmVyaW1lcE9BIiwiY3JlZGVudGlhbHMiOlsiRW1haWxQYXNzIl0sImlzc3VlciI6Imh0dHBzOi8vdGFsYW8uY28vaXNzdWVyL21meXR0YWJvc3kiLCJpc0VCU0lWMyI6ZmFsc2UsImNsaWVudF9pZCI6ImRpZDpqd2s6ZXlKamNuWWlPaUpRTFRJMU5pSXNJbXQwZVNJNklrVkRJaXdpZUNJNklqWmthMVUyV2sxR1N6YzVWM2RwWTNkS05YSmllRVV4TTNwVGRXdENXVEpQYjBWcFZsVkZhbkZOUldNaUxDSjVJam9pVW01SWVtNTVWbXh5VUZOTlZEZHBja1J6TVRWRU9YZDRaMDF2YW1sVFJFRlJjR1pHYUhGVWEweFNXU0o5IiwiaWF0IjoxNzE0NTQ5OTUxfQ.JJtv8H52NTvPzR3IPET1sXGALdt0yXaQBQbGvDLKNlM',
          'nonce': '8b60e2fb-87f3-4401-8107-0f0128ea01ab',
          'code_challenge': '4KorCwmYyO-_t4i_hva7F3aHGpT_2WqqDh6erimepOA',
          'code_challenge_method': 'S256',
          'issuer_state': 'test7',
          'client_metadata':
              '{\"authorization_endpoint\":\"https://app.altme.io/app/download/authorize\",\"scopes_supported\":[\"openid\"],\"response_types_supported\":[\"vp_token\",\"id_token\"],\"client_id_schemes_supported\":[\"redirect_uri\",\"did\"],\"grant_types_supported\":[\"authorization_code\",\"pre-authorized_code\"],\"subject_types_supported\":[\"public\"],\"id_token_signing_alg_values_supported\":[\"ES256\",\"ES256K\"],\"request_object_signing_alg_values_supported\":[\"ES256\",\"ES256K\"],\"request_parameter_supported\":true,\"request_uri_parameter_supported\":true,\"request_authentication_methods_supported\":{\"authorization_endpoint\":[\"request_object\"]},\"vp_formats_supported\":{\"jwt_vp\":{\"alg_values_supported\":[\"ES256\",\"ES256K\"]},\"jwt_vc\":{\"alg_values_supported\":[\"ES256\",\"ES256K\"]}},\"subject_syntax_types_supported\":[\"urn:ietf:params:oauth:jwk-thumbprint\",\"did:key\",\"did:pkh\",\"did:key\",\"did:polygonid\"],\"subject_syntax_types_discriminations\":[\"did:key:jwk_jcs-pub\",\"did:ebsi:v1\"],\"subject_trust_frameworks_supported\":[\"ebsi\"],\"id_token_types_supported\":[\"subject_signed_id_token\"],\"token_endpoint_auth_method\":\"client_id\"}',
          'client_id':
              'did:jwk:eyJjcnYiOiJQLTI1NiIsImt0eSI6IkVDIiwieCI6IjZka1U2Wk1GSzc5V3dpY3dKNXJieEUxM3pTdWtCWTJPb0VpVlVFanFNRWMiLCJ5IjoiUm5Iem55VmxyUFNNVDdpckRzMTVEOXd4Z01vamlTREFRcGZGaHFUa0xSWSJ9',
          'scope': 'openid',
          'authorization_details':
              '[{\"type\":\"openid_credential\",\"credential_configuration_id\":\"EmailPass\"}]',
        };

        dioAdapter.onGet(
          'https://talao.co/issuer/mfyttabosy/.well-known/openid-credential-issuer',
          (request) => request.reply(200, jsonDecode(openIdConfiguration)),
        );

        final (authorizationEndpoint, authorizationRequestParemeters) =
            await oidc4vc.getAuthorizationData(
          selectedCredentials: selectedCredentials,
          clientId: clientId,
          clientSecret: null,
          redirectUri: redirectUri,
          issuerState: issuerState,
          nonce: nonce,
          pkcePair: pkcePair,
          state: state,
          authorizationEndPoint: authorizationEndPoint,
          scope: false,
          clientAuthentication: ClientAuthentication.clientId,
          oidc4vciDraftType: OIDC4VCIDraftType.draft13,
          vcFormatType: VCFormatType.jwtVcJson,
          clientAssertion: null,
          secureAuthorizedFlow: false,
          issuer: issuer,
          dio: client,
        );

        expect(authorizationEndpoint, expectedAuthorizationEndpoint);
        expect(authorizationRequestParemeters,
            expectedAuthorizationRequestParemeters);
      },
    );

    test(
      'throw Exception with when request is not valid',
      () async {
        expect(
          () async => oidc4vc.getAuthorizationData(
            selectedCredentials: [],
            clientId: '',
            issuer: '',
            issuerState: '',
            nonce: '',
            state: '',
            pkcePair: const PkcePair(
              '',
              '',
            ),
            authorizationEndPoint: '',
            clientAssertion: '',
            clientAuthentication: ClientAuthentication.clientId,
            clientSecret: '',
            oidc4vciDraftType: OIDC4VCIDraftType.draft11,
            redirectUri: '',
            scope: false,
            secureAuthorizedFlow: false,
            vcFormatType: VCFormatType.jwtVc,
            dio: client,
          ),
          throwsA(
            isA<Exception>().having(
              (p0) => p0.toString(),
              'toString()',
              'Exception: NOT_A_VALID_OPENID_URL',
            ),
          ),
        );
      },
    );

    test(
      'given correct authorization request parameter',
      () async {
        const expectedAuthorizationRequestParemeters =
            r'{"response_type":"code","redirect_uri":"https://app.altme.io/app/download/oidc4vc","state":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlVmVyaWZpZXIiOiI0S29yQ3dtWXlPLV90NGlfaHZhN0YzYUhHcFRfMldxcURoNmVyaW1lcE9BIiwiY3JlZGVudGlhbHMiOlsiRW1haWxQYXNzIl0sImlzc3VlciI6Imh0dHBzOi8vdGFsYW8uY28vaXNzdWVyL21meXR0YWJvc3kiLCJpc0VCU0lWMyI6ZmFsc2UsImNsaWVudF9pZCI6ImRpZDpqd2s6ZXlKamNuWWlPaUpRTFRJMU5pSXNJbXQwZVNJNklrVkRJaXdpZUNJNklqWmthMVUyV2sxR1N6YzVWM2RwWTNkS05YSmllRVV4TTNwVGRXdENXVEpQYjBWcFZsVkZhbkZOUldNaUxDSjVJam9pVW01SWVtNTVWbXh5VUZOTlZEZHBja1J6TVRWRU9YZDRaMDF2YW1sVFJFRlJjR1pHYUhGVWEweFNXU0o5IiwiaWF0IjoxNzE0NTQ5OTUxfQ.JJtv8H52NTvPzR3IPET1sXGALdt0yXaQBQbGvDLKNlM","nonce":"8b60e2fb-87f3-4401-8107-0f0128ea01ab","code_challenge":"4KorCwmYyO-_t4i_hva7F3aHGpT_2WqqDh6erimepOA","code_challenge_method":"S256","issuer_state":"test7","client_metadata":"{\"authorization_endpoint\":\"https://app.altme.io/app/download/authorize\",\"scopes_supported\":[\"openid\"],\"response_types_supported\":[\"vp_token\",\"id_token\"],\"client_id_schemes_supported\":[\"redirect_uri\",\"did\"],\"grant_types_supported\":[\"authorization_code\",\"pre-authorized_code\"],\"subject_types_supported\":[\"public\"],\"id_token_signing_alg_values_supported\":[\"ES256\",\"ES256K\"],\"request_object_signing_alg_values_supported\":[\"ES256\",\"ES256K\"],\"request_parameter_supported\":true,\"request_uri_parameter_supported\":true,\"request_authentication_methods_supported\":{\"authorization_endpoint\":[\"request_object\"]},\"vp_formats_supported\":{\"jwt_vp\":{\"alg_values_supported\":[\"ES256\",\"ES256K\"]},\"jwt_vc\":{\"alg_values_supported\":[\"ES256\",\"ES256K\"]}},\"subject_syntax_types_supported\":[\"urn:ietf:params:oauth:jwk-thumbprint\",\"did:key\",\"did:pkh\",\"did:key\",\"did:polygonid\"],\"subject_syntax_types_discriminations\":[\"did:key:jwk_jcs-pub\",\"did:ebsi:v1\"],\"subject_trust_frameworks_supported\":[\"ebsi\"],\"id_token_types_supported\":[\"subject_signed_id_token\"],\"token_endpoint_auth_method\":\"client_id\"}","client_id":"did:jwk:eyJjcnYiOiJQLTI1NiIsImt0eSI6IkVDIiwieCI6IjZka1U2Wk1GSzc5V3dpY3dKNXJieEUxM3pTdWtCWTJPb0VpVlVFanFNRWMiLCJ5IjoiUm5Iem55VmxyUFNNVDdpckRzMTVEOXd4Z01vamlTREFRcGZGaHFUa0xSWSJ9","scope":"openid","authorization_details":"[{\"type\":\"openid_credential\",\"credential_configuration_id\":\"EmailPass\"}]"}';

        final authorizationRequestParemeters =
            oidc4vc.getAuthorizationRequestParemeters(
          selectedCredentials: selectedCredentials,
          clientId: clientId,
          authorizationEndPoint: authorizationEndPoint,
          clientAssertion: null,
          scope: false,
          clientAuthentication: ClientAuthentication.clientId,
          oidc4vciDraftType: OIDC4VCIDraftType.draft13,
          vcFormatType: VCFormatType.jwtVcJson,
          secureAuthorizedFlow: false,
          issuer: issuer,
          issuerState: issuerState,
          nonce: nonce,
          state: state,
          pkcePair: pkcePair,
          clientSecret: null,
          openIdConfiguration: OpenIdConfiguration.fromJson(
            jsonDecode(openIdConfiguration) as Map<String, dynamic>,
          ),
          redirectUri: redirectUri,
        );

        expect(
          jsonEncode(authorizationRequestParemeters),
          expectedAuthorizationRequestParemeters,
        );
      },
    );
  });

  group('OIC4VC request credential', () {
    const issuer = 'https://talao.co/issuer/zxhaokccsi';

    const credential = {
      'format': 'jwt_vc',
      'types': [
        'VerifiableCredential',
        'VerifiableAttestation',
        'VerifiableDiploma2',
      ],
    };

    const did =
        'did:key:z2dmzD81cgPx8Vki7JbuuMmFYrWPgYoytykUZ3eyqht1j9Kbrbpg5is8LfTLuQ1RsW5r7s7ZjbDDFbDgy1tLrdc7Bj3itBGQkuGUQyfzKhFqbUNW2PqJPMSSzWoF2DGSvDSijCtJtYCSRsjSVLrwu5oHNbnPFvSEC4iRZPpU6B6nExRBTa';

    const kid =
        'did:key:z2dmzD81cgPx8Vki7JbuuMmFYrWPgYoytykUZ3eyqht1j9Kbrbpg5is8LfTLuQ1RsW5r7s7ZjbDDFbDgy1tLrdc7Bj3itBGQkuGUQyfzKhFqbUNW2PqJPMSSzWoF2DGSvDSijCtJtYCSRsjSVLrwu5oHNbnPFvSEC4iRZPpU6B6nExRBTa#z2dmzD81cgPx8Vki7JbuuMmFYrWPgYoytykUZ3eyqht1j9Kbrbpg5is8LfTLuQ1RsW5r7s7ZjbDDFbDgy1tLrdc7Bj3itBGQkuGUQyfzKhFqbUNW2PqJPMSSzWoF2DGSvDSijCtJtYCSRsjSVLrwu5oHNbnPFvSEC4iRZPpU6B6nExRBTa';

    const privateKey =
        '{"kty":"EC","crv":"P-256","d":"amrwK13ZiYoJ5g0fc6MvXc86RB9ID8VuK_dMowU68FE","x":"fJQ2c9P_YDep3jzidwykcSlyoC4omqBvd9RHP1nz0cw","y":"K7VxrW-S1ONuX5cxrWIltF36ac1K8kj9as_o5cyc2zk"}';

    const openIdConfiguration =
        '{"authorization_server":"https://talao.co/issuer/zxhaokccsi","credential_endpoint":"https://talao.co/issuer/zxhaokccsi/credential","credential_issuer":"https://talao.co/issuer/zxhaokccsi","subject_syntax_types_supported":null,"token_endpoint":null,"batch_endpoint":null,"authorization_endpoint":null,"subject_trust_frameworks_supported":null,"credentials_supported":[{"display":[{"locale":"en-US","name":"EU Diploma","description":"This the official EBSI VC Diploma","text_color":"#FFFFFF","background_color":"#3B6F6D","background_image":{"url":"https://i.ibb.co/CHqjxrJ/dbc-card-hig-res.png","alt_text":"Connected open cubes in blue with one orange cube as a background of the card"},"logo":{"url":"https://dutchblockchaincoalition.org/assets/images/icons/Logo-DBC.png","alt_text":"An orange block shape, with the text Dutch Blockchain Coalition next to it, portraying the logo of the Dutch Blockchain Coalition."}}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma2"],"id":null,"scope":null,"credentialSubject":{"dateOfBirth":{"display":[{"locale":"en-US","name":"Birth Date"},{"locale":"fr-FR","name":"Date de naissance"}]},"familyName":{"display":[{"locale":"en-US","name":"Family Name"},{"locale":"fr-FR","name":"Nom"}]},"givenNames":{"display":[{"locale":"en-US","name":"First Name"},{"locale":"fr-FR","name":"Prénom"}]}}},{"display":[{"locale":"en-US","name":"Individual attestation","description":"This is the EBSI Individual Verifiable Attestation","text_color":"#FFFFFF","background_color":"#3B6F6D","background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","IndividualVerifiableAttestation"],"id":null,"scope":null,"credentialSubject":{"dateOfBirth":{"display":[{"locale":"en-US","name":"Birth Date"},{"locale":"fr-FR","name":"Date de naissance"}]},"familyName":{"display":[{"locale":"en-US","name":"Family Name"},{"locale":"fr-FR","name":"Nom"}]},"firstName":{"display":[{"locale":"en-US","name":"First Name"},{"locale":"fr-FR","name":"Prénom"}]},"issuing_country":{"display":[{"locale":"en-US","name":"Issued by"},{"locale":"fr-FR","name":"Délivré par"}]},"placeOfBirth":{"display":[{"locale":"en-US","name":"Birth Place"},{"locale":"fr-FR","name":"Lieu de naissance"}]}}},{"display":[{"locale":"en-GB","name":"Email proof","description":"This is a verifiable credential","text_color":null,"background_color":null,"background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","EmailPass"],"id":null,"scope":null,"credentialSubject":null},{"display":[{"locale":"en-GB","name":"Verifiable Id","description":"This is a verifiable credential","text_color":null,"background_color":null,"background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableId"],"id":null,"scope":null,"credentialSubject":null}],"credential_configurations_supported":null,"deferred_credential_endpoint":"https://talao.co/issuer/zxhaokccsi/deferred","service_documentation":null,"credential_manifest":null,"credential_manifests":null,"issuer":null,"jwks_uri":null,"grant_types_supported":null}';

    const accessToken = '0f0119c2-0867-11ef-8bfa-0a1628958560';

    const nonce = '0f011beb-0867-11ef-817f-0a1628958560';

    const credentialRequestUrl =
        'https://talao.co/issuer/zxhaokccsi/credential';

    const expecedCredentialResponse =
        '{"credential":"eyJhbGciOiJFUzI1NiIsImtpZCI6InFsM2g2Z3Jqem5iaGNSRzVPRWk3V1B6dHNkZ1FLaGhiLXBOU1laSWgtdk0iLCJ0eXAiOiJKV1QifQ.eyJleHAiOjE3NDYxODE3NDYsImlhdCI6MTcxNDY0NTc0NiwiaXNzIjoiaHR0cHM6Ly90YWxhby5jby9pc3N1ZXIvenhoYW9rY2NzaSIsImp0aSI6InVybjp1dWlkOmNkZGE4MWYyLTA4NmUtMTFlZi05ODE3LTBhMTYyODk1ODU2MCIsIm5iZiI6MTcxNDY0NTc0Niwibm9uY2UiOiJjOWZkMzJiYS0wODZlLTExZWYtOTQ5Yi0wYTE2Mjg5NTg1NjAiLCJzdWIiOiJkaWQ6a2V5OnoyZG16RDgxY2dQeDhWa2k3SmJ1dU1tRllyV1BnWW95dHlrVVozZXlxaHQxajlLYnJicGc1aXM4TGZUTHVRMVJzVzVyN3M3WmpiRERGYkRneTF0THJkYzdCajNpdEJHUWt1R1VReWZ6S2hGcWJVTlcyUHFKUE1TU3pXb0YyREdTdkRTaWpDdEp0WUNTUnNqU1ZMcnd1NW9ITmJuUEZ2U0VDNGlSWlBwVTZCNm5FeFJCVGEiLCJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9hcGkucHJlcHJvZC5lYnNpLmV1L3RydXN0ZWQtc2NoZW1hcy1yZWdpc3RyeS92MS9zY2hlbWFzLzB4YmY3OGZjMDhhN2E5ZjI4ZjU0NzlmNThkZWEyNjlkMzY1N2Y1NGYxM2NhMzdkMzgwY2Q0ZTkyMjM3ZmI2OTFkZCIsInR5cGUiOiJKc29uU2NoZW1hVmFsaWRhdG9yMjAxOCJ9LCJjcmVkZW50aWFsU3RhdHVzIjpbeyJpZCI6Imh0dHBzOi8vdGFsYW8uY28vc2FuZGJveC9pc3N1ZXIvYml0c3RyaW5nc3RhdHVzbGlzdC8xIzczMDE5Iiwic3RhdHVzTGlzdENyZWRlbnRpYWwiOiJodHRwczovL3RhbGFvLmNvL3NhbmRib3gvaXNzdWVyL2JpdHN0cmluZ3N0YXR1c2xpc3QvMSIsInN0YXR1c0xpc3RJbmRleCI6IjczMDE5Iiwic3RhdHVzUHVycG9zZSI6InJldm9jYXRpb24iLCJ0eXBlIjoiQml0c3RyaW5nU3RhdHVzTGlzdEVudHJ5In1dLCJjcmVkZW50aWFsU3ViamVjdCI6eyJhd2FyZGluZ09wcG9ydHVuaXR5Ijp7ImF3YXJkaW5nQm9keSI6eyJlaWRhc0xlZ2FsSWRlbnRpZmllciI6IlVua25vd24iLCJob21lcGFnZSI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tLyIsImlkIjoiZGlkOmVic2k6emRSdnZLYlhoVlZCc1hoYXRqdWlCaHMiLCJwcmVmZXJyZWROYW1lIjoiTGVhc3RvbiBVbml2ZXJzaXR5IiwicmVnaXN0cmF0aW9uIjoiMDU5NzA2NUoifSwiZW5kZWRBdFRpbWUiOiIyMDIwLTA2LTI2VDAwOjAwOjAwWiIsImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0F3YXJkaW5nT3Bwb3J0dW5pdHkiLCJpZGVudGlmaWVyIjoiaHR0cHM6Ly9jZXJ0aWZpY2F0ZS1kZW1vLmJjZGlwbG9tYS5jb20vY2hlY2svODdFRDJGMjI3MEU2QzQxNDU2RTk0Qjg2QjlEOTExNUI0RTM1QkNDQUQyMDBBNDlCODQ2NTkyQzE0Rjc5Qzg2QlYxRm5ibGx0YTBOWlRuSmtSM2xEV2xSbVREbFNSVUpFVkZaSVNtTm1ZekpoVVU1c1pVSjVaMkZKU0hwV2JtWloiLCJsb2NhdGlvbiI6IkZSQU5DRSIsInN0YXJ0ZWRBdFRpbWUiOiIyMDE5LTA5LTAyVDAwOjAwOjAwWiJ9LCJkYXRlT2ZCaXJ0aCI6IjE5OTMtMDQtMDgiLCJmYW1pbHlOYW1lIjoiRE9FIiwiZ2l2ZW5OYW1lcyI6IkphbmUiLCJncmFkaW5nU2NoZW1lIjp7ImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0dyYWRpbmdTY2hlbWUiLCJ0aXRsZSI6IjIgeWVhciBmdWxsLXRpbWUgcHJvZ3JhbW1lIC8gNCBzZW1lc3RlcnMifSwiaWRlbnRpZmllciI6IjA5MDQwMDgwODRIIiwibGVhcm5pbmdBY2hpZXZlbWVudCI6eyJhZGRpdGlvbmFsTm90ZSI6WyJESVNUUklCVVRJT04gTUFOQUdFTUVOVCJdLCJkZXNjcmlwdGlvbiI6IlRoZSBNYXN0ZXIgaW4gSW5mb3JtYXRpb24gYW5kIENvbXB1dGVyIFNjaWVuY2VzIChNSUNTKSBhdCB0aGUgVW5pdmVyc2l0eSBvZiBMdXhlbWJvdXJnIGVuYWJsZXMgc3R1ZGVudHMgdG8gYWNxdWlyZSBkZWVwZXIga25vd2xlZGdlIGluIGNvbXB1dGVyIHNjaWVuY2UgYnkgdW5kZXJzdGFuZGluZyBpdHMgYWJzdHJhY3QgYW5kIGludGVyZGlzY2lwbGluYXJ5IGZvdW5kYXRpb25zLCBmb2N1c2luZyBvbiBwcm9ibGVtIHNvbHZpbmcgYW5kIGRldmVsb3BpbmcgbGlmZWxvbmcgbGVhcm5pbmcgc2tpbGxzLiIsImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0xlYXJuaW5nQWNoaWV2bWVudCIsInRpdGxlIjoiTWFzdGVyIGluIEluZm9ybWF0aW9uIGFuZCBDb21wdXRlciBTY2llbmNlcyJ9LCJsZWFybmluZ1NwZWNpZmljYXRpb24iOnsiZWN0c0NyZWRpdFBvaW50cyI6MTIwLCJlcWZMZXZlbCI6NywiaWQiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS9sYXctZWNvbm9taWNzLW1hbmFnZW1lbnQjTGVhcm5pbmdTcGVjaWZpY2F0aW9uIiwiaXNjZWRmQ29kZSI6WyI3Il0sIm5xZkxldmVsIjpbIjciXX0sInR5cGUiOiJWZXJpZmlhYmxlRGlwbG9tYTIifSwiZXZpZGVuY2UiOnsiZG9jdW1lbnRQcmVzZW5jZSI6WyJQaHlzaWNhbCJdLCJldmlkZW5jZURvY3VtZW50IjpbIlBhc3Nwb3J0Il0sImlkIjoiaHR0cHM6Ly9lc3NpZi5ldXJvcGEuZXUvdHNyLXZhL2V2aWRlbmNlL2YyYWVlYzk3LWZjMGQtNDJiZi04Y2E3LTA1NDgxOTJkNTY3OCIsInN1YmplY3RQcmVzZW5jZSI6IlBoeXNpY2FsIiwidHlwZSI6WyJEb2N1bWVudFZlcmlmaWNhdGlvbiJdLCJ2ZXJpZmllciI6ImRpZDplYnNpOjI5NjJmYjc4NGRmNjFiYWEyNjdjODEzMjQ5NzUzOWY4YzY3NGIzN2MxMjQ0YTdhIn0sInR5cGUiOlsiVmVyaWZpYWJsZUNyZWRlbnRpYWwiLCJWZXJpZmlhYmxlQXR0ZXN0YXRpb24iLCJWZXJpZmlhYmxlRGlwbG9tYSJdfX0.eU1nRdOMklOK6kKvJk-0iCdng5gXZ7quZV1ob_kr2c3_7wSsOEhlgikZzTkkZAOuxmkkdSnWRsGMoA0M4YEi1Q","c_nonce":"cddafe06-086e-11ef-b80b-0a1628958560","c_nonce_expires_in":5000,"format":"jwt_vc"}';
    dioAdapter.onPost(
      credentialRequestUrl,
      (request) => request.reply(
        200,
        expecedCredentialResponse,
      ),
    );

    test('When getCredentialType receive url it returns json response',
        () async {
      final (credentialResponseData, deferredCredentialEndpoint, format) =
          await oidc4vc.getCredential(
        issuer: issuer,
        credential: credential,
        did: did,
        clientId: did,
        kid: kid,
        privateKey: privateKey,
        cryptoHolderBinding: true,
        clientType: ClientType.did,
        proofHeaderType: ProofHeaderType.kid,
        oidc4vciDraftType: OIDC4VCIDraftType.draft11,
        clientAuthentication: ClientAuthentication.clientId,
        proofType: ProofType.jwt,
        openIdConfiguration: OpenIdConfiguration.fromJson(
          jsonDecode(openIdConfiguration) as Map<String, dynamic>,
        ),
        accessToken: accessToken,
        cnonce: nonce,
        dio: client,
      );

      expect(credentialResponseData, [expecedCredentialResponse]);
      expect(
        deferredCredentialEndpoint,
        'https://talao.co/issuer/zxhaokccsi/deferred',
      );
      expect(format, 'jwt_vc');
    });

    test('throw Exception when token is not verified', () {
      expect(
        () async {
          await oidc4vc.getCredential(
            issuer: '',
            credential: null,
            did: '',
            clientId: null,
            kid: '',
            privateKey: '',
            cryptoHolderBinding: true,
            clientType: ClientType.did,
            proofHeaderType: ProofHeaderType.kid,
            oidc4vciDraftType: OIDC4VCIDraftType.draft11,
            clientAuthentication: ClientAuthentication.clientId,
            proofType: ProofType.jwt,
            openIdConfiguration: OpenIdConfiguration.fromJson(
              jsonDecode(openIdConfiguration) as Map<String, dynamic>,
            ),
            accessToken: '',
            cnonce: null,
            dio: client,
          );
        },
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('build token data', () {
    const redirectUri = 'https://app.altme.io/app/download/callback';
    const preAuthorizedCode =
        'eyJhbGciOiJFUzI1NiIsImtpZCI6ImRpZDplYnNpOjEyMzQja2V5LTEiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL3RhbGFvLmNvL3NhbmRib3gvZWJzaS9pc3N1ZXIvenhoYW9rY2NzaSIsImNsaWVudF9pZCI6Imh0dHBzOi8vc2VsZi1pc3N1ZWQubWUvdjIiLCJleHAiOjE3MTQ2MzU4NDIsImlhdCI6MTcxNDYzNDg0MiwiaXNzIjoiaHR0cHM6Ly90YWxhby5jby9zYW5kYm94L2Vic2kvaXNzdWVyL3p4aGFva2Njc2kiLCJub25jZSI6IjZhMGJkZWUxLTA4NTUtMTFlZi04MzJlLTBhMTYyODk1ODU2MCIsInN1YiI6Imh0dHBzOi8vc2VsZi1pc3N1ZWQubWUvdjIifQ.ViX87lulUM6WZ0lNj5XMEz-Ty5q8nIcI7b-bIYa7VRsqo1wcR_en-8hzN_Q_sp8hqi8lKX80n4jM-DqXqvJk5g';

    test('get token data with credentialRequestUri for preAuthorizedCode',
        () async {
      const clientId =
          'did:key:z2dmzD81cgPx8Vki7JbuuMmFYrWPgYoytykUZ3eyqht1j9Kbpog7BZb9wdCJCjHfWMTpjcviuoFJ2fd9AiwsWGMFvhNJ5gVMA2mzHSFqkrLMXdHNeePjiaTP15sw8uaWDfyAxehGHKj7YsxymgVnEhcEJgKsLRJHgJZXAiXJGyRxWPGEYC';

      const expectedTokenData =
          '{"pre-authorized_code":"eyJhbGciOiJFUzI1NiIsImtpZCI6ImRpZDplYnNpOjEyMzQja2V5LTEiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL3RhbGFvLmNvL3NhbmRib3gvZWJzaS9pc3N1ZXIvenhoYW9rY2NzaSIsImNsaWVudF9pZCI6Imh0dHBzOi8vc2VsZi1pc3N1ZWQubWUvdjIiLCJleHAiOjE3MTQ2MzU4NDIsImlhdCI6MTcxNDYzNDg0MiwiaXNzIjoiaHR0cHM6Ly90YWxhby5jby9zYW5kYm94L2Vic2kvaXNzdWVyL3p4aGFva2Njc2kiLCJub25jZSI6IjZhMGJkZWUxLTA4NTUtMTFlZi04MzJlLTBhMTYyODk1ODU2MCIsInN1YiI6Imh0dHBzOi8vc2VsZi1pc3N1ZWQubWUvdjIifQ.ViX87lulUM6WZ0lNj5XMEz-Ty5q8nIcI7b-bIYa7VRsqo1wcR_en-8hzN_Q_sp8hqi8lKX80n4jM-DqXqvJk5g","grant_type":"urn:ietf:params:oauth:grant-type:pre-authorized_code","client_id":"did:key:z2dmzD81cgPx8Vki7JbuuMmFYrWPgYoytykUZ3eyqht1j9Kbpog7BZb9wdCJCjHfWMTpjcviuoFJ2fd9AiwsWGMFvhNJ5gVMA2mzHSFqkrLMXdHNeePjiaTP15sw8uaWDfyAxehGHKj7YsxymgVnEhcEJgKsLRJHgJZXAiXJGyRxWPGEYC"}'; // ignore: lines_longer_than_80_chars
      final tokenData = oidc4vc.buildTokenData(
        redirectUri: redirectUri,
        preAuthorizedCode: preAuthorizedCode,
        clientId: clientId,
      );

      expect(jsonEncode(tokenData), expectedTokenData);
    });

    test('get token data with credentialRequestUri - authorization flow', () {
      const clientId =
          'did:jwk:eyJjcnYiOiJQLTI1NiIsImt0eSI6IkVDIiwieCI6IjZka1U2Wk1GSzc5V3dpY3dKNXJieEUxM3pTdWtCWTJPb0VpVlVFanFNRWMiLCJ5IjoiUm5Iem55VmxyUFNNVDdpckRzMTVEOXd4Z01vamlTREFRcGZGaHFUa0xSWSJ9';
      const expectedTokenData =
          '{"code":"6486b7c9-0858-11ef-a82c-0a1628958560","grant_type":"authorization_code","code_verifier":"qZNF2gMjTQf7pJN2NMai1TS9Y81z8xzfPQtbmyVG-Gk","redirect_uri":"https://app.altme.io/app/download/callback","client_id":"did:jwk:eyJjcnYiOiJQLTI1NiIsImt0eSI6IkVDIiwieCI6IjZka1U2Wk1GSzc5V3dpY3dKNXJieEUxM3pTdWtCWTJPb0VpVlVFanFNRWMiLCJ5IjoiUm5Iem55VmxyUFNNVDdpckRzMTVEOXd4Z01vamlTREFRcGZGaHFUa0xSWSJ9"}';
      final tokenData = oidc4vc.buildTokenData(
        redirectUri: redirectUri,
        clientId: clientId,
        code: '6486b7c9-0858-11ef-a82c-0a1628958560',
        codeVerifier: 'qZNF2gMjTQf7pJN2NMai1TS9Y81z8xzfPQtbmyVG-Gk',
      );
      expect(jsonEncode(tokenData), expectedTokenData);
    });
  });

  // group('getIssuer', () {
  //   final oidc4vc = OIDC4VC(client);
  //   test('get issuer with credentialRequestUri', () {
  //     const expectedIssuer =
  //         'https://talao.co/sandbox/ebsi/issuer/vgvghylozl';
  //     final issuer = oidc4vc.getIssuer(credentialRequest);
  //     expect(expectedIssuer, issuer);
  //   });

  //   test(
  //       'get issuer with credentialRequestUri when PreAuthorizedCode is given', // ignore: lines_longer_than_80_chars
  //       () {
  //     const expectedIssuer =
  //         'https://talao.co/sandbox/ebsi/issuer/vgvghylozl';
  //     final issuer =
  //         oidc4vc.getIssuer(credentialRequestWithPreAuthorizedCode);
  //     expect(expectedIssuer, issuer);
  //   });
  // });

  // test('get readTokenEndPoint with openidConfigurationResponse', () async {
  //   const openidConfigurationResponse =
  //       r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":true,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';

  //   final oidc4vc = OIDC4VC(client);

  //   final issuer = oidc4vc.readTokenEndPoint(
  //     Response(
  //       requestOptions: RequestOptions(path: ''),
  //       data: jsonDecode(openidConfigurationResponse) as Map<String, dynamic>,
  //     ),
  //   );
  //   expect(issuer, tokenUrl);
  // });

  // test('get issuer did with openidConfigurationResponse', () {
  //   const openidConfigurationResponse =
  //       r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"},{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":true,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';
  //   final oidc4vc = OIDC4VC(client);

  //   final issuer = oidc4vc.readIssuerDid(
  //     Response(
  //       requestOptions: RequestOptions(path: ''),
  //       data: jsonDecode(openidConfigurationResponse) as Map<String, dynamic>,
  //     ),
  //   );
  //   expect(issuer, 'did:ebsi:zhSw5rPXkcHjvquwnVcTzzB');
  // });

  //   test('get publicKey did with didDocumentResponse', () {
  //     const didDocumentResponse =
  //         '{"assertionMethod":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"authentication":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"@context":"https://www.w3.org/ns/did/v1","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","verificationMethod":[{"controller":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53","publicKeyJwk":{"alg":"EdDSA","crv":"Ed25519","kid":"3623b877bbb24b08ba390f3585418f53","kty":"OKP","use":"sig","x":"pWgA8M3etXlLaqcRmgjEQkz7waseg3FKzMCzfm9Yeow"},"type":"Ed25519VerificationKey2019"}]}';
  //     const issuerDid = 'did:ebsi:zeFCExU2XAAshYkPCpjuahA';

  //     const expectedPublicKey =
  //         '{"alg":"EdDSA","crv":"Ed25519","kid":"3623b877bbb24b08ba390f3585418f53","kty":"OKP","use":"sig","x":"pWgA8M3etXlLaqcRmgjEQkz7waseg3FKzMCzfm9Yeow"}'; // ignore: lines_longer_than_80_chars

  //     final oidc4vc = OIDC4VC(client);

  //     final publicKey = oidc4vc.readPublicKeyJwk(
  //       issuerDid,
  //       Response(
  //         requestOptions: RequestOptions(path: ''),
  //         data: jsonDecode(didDocumentResponse) as Map<String, dynamic>,
  //       ),
  //     );
  //     expect(jsonEncode(publicKey), expectedPublicKey);
  //   });
  // });

  // group('verify encoded data', () {
  //   const issuerDid1 = 'did:ebsi:zeFCExU2XAAshYkPCpjuahA';
  //   const issuerDid2 = 'did:ebsi:zhSw5rPXkcHjvquwnVcTzzC';
  //   const issuerDid3 = 'did:ebsi:zhSw5rPXkcHjvquwnVcTzzC';

  //   const issuerKid =
  //       'did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53';

  //   const didDocumentUrl =
  //       'https://api-pilot.oidc4vc.eu/did-registry/v3/identifiers/$issuerDid1';

  //   const didDocumentResponse =
  //       '{"assertionMethod":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"authentication":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"@context":"https://www.w3.org/ns/did/v1","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","verificationMethod":[{"controller":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53","publicKeyJwk":{"crv":"P-521","kty":"EC","x":"AekpBQ8ST8a8VcfVOTNl353vSrDCLLJXmPk06wTjxrrjcBpXp5EOnYG_NjFZ6OvLFV1jSfS9tsz4qUxcWceqwQGk","y":"ADSmRA43Z1DSNx_RvcLI87cdL07l6jQyyBXMoxVg_l2Th-x3S1WDhjDly79ajL4Kkd0AZMaZmh9ubmf63e3kyMj2"},"type":"Ed25519VerificationKey2019"}]}';

  //   const didDocumentUrl2 =
  //       'https://api-pilot.oidc4vc.eu/did-registry/v3/identifiers/$issuerDid2';

  //   const didDocumentResponse2 =
  //       '{"assertionMethod":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"authentication":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"@context":"https://www.w3.org/ns/did/v1","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","verificationMethod":[{"controller":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53","publicKeyJwk":{"crv":"Ed25519","kty":"OKP","x":"AekpBQ8ST8a8VcfVOTNl353vSrDCLLJXmPk06wTjxrrjcBpXp5EOnYG_NjFZ6OvLFV1jSfS9tsz4qUxcWceqwQGk","y":"ADSmRA43Z1DSNx_RvcLI87cdL07l6jQyyBXMoxVg_l2Th-x3S1WDhjDly79ajL4Kkd0AZMaZmh9ubmf63e3kyMj2"},"type":"Ed25519VerificationKey2019"}]}';

  //   const didDocumentUrl3 =
  //       'https://api-pilot.oidc4vc.eu/did-registry/v3/identifiers/$issuerDid3';

  //   const didDocumentResponse3 =
  //       '{"assertionMethod":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"authentication":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"@context":"https://www.w3.org/ns/did/v1","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","verificationMethod":[{"controller":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53","publicKeyJwk":{"alg":"EdDSA","crv":"Ed25519","kid":"-1909572257","kty":"OKP","x":"XWxGtApfcqmKI7p0OKnF5JSEWMVoLsytFXLEP7xZ_l8"},"type":"Ed25519VerificationKey2019"}]}';
  //   dioAdapter
  //     ..onGet(
  //       didDocumentUrl,
  //       (request) => request.reply(200, jsonDecode(didDocumentResponse)),
  //     )
  //     ..onGet(
  //       didDocumentUrl2,
  //       (request) => request.reply(200, jsonDecode(didDocumentResponse2)),
  //     )
  //     ..onGet(
  //       didDocumentUrl3,
  //       (request) => request.reply(200, jsonDecode(didDocumentResponse3)),
  //     );

  //   final oidc4vc = OIDC4VC(client);
  //   test('returns VerificationType.verified', () async {
  //     const vcJwt = 'eyJhbGciOiJFUzUxMiJ9.'
  //         'UGF5bG9hZA.'
  //         'AdwMgeerwtHoh-l192l60hp9wAHZFVJbLfD_UxMi70cwnZOYaRI1bKPWROc-mZZq'
  //         'wqT2SI-KGDKB34XO0aw_7XdtAG8GaSwFKdCAPZgoXD2YBJZCPEX3xKpRwcdOO8Kp'
  //         'EHwJjyqOgzDO7iKvU8vcnwNrmxYbSW9ERBXukOXolLzeO_Jn';

  //     final isVerified = await oidc4vc.verifyEncodedData(
  //       issuerDid: issuerDid1,
  //       jwt: vcJwt,
  //       issuerKid: issuerKid,
  //     );

  //     expect(isVerified, VerificationType.verified);
  //   });

  //   test('returns VerificationType.notVerified', () async {
  //     const vcJwt =
  //         'eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksiLCJqd2siOnsiY3J2IjoiUC0yNTZLIiwia3R5IjoiRUMiLCJ4IjoiSjR2UXRMVXlyVlVpRklYUnJ0RXE0eHVybUJacDJlcTl3Sm1Ya0lBX3N0SSIsInkiOiJFVVU2dlhvRzNCR1gyenp3alhyR0RjcjRFeUREMFZmazNfNWZnNWtTZ0tFIn0sImtpZCI6ImRpZDplYnNpOnpvOUZSMVlmQUtGUDNRNmR2cWh4Y1h4bmZlRGlKRFA5N2ttbnFoeUFVU0FDaiNDZ2NnMXk5eGo5dVdGdzU2UE1jMjlYQmQ5RVJlaXh6dm5mdEJ6OEp3UUZpQiJ9.eyJpc3MiOiJkaWQ6ZWJzaTp6bzlGUjFZZkFLRlAzUTZkdnFoeGNYeG5mZURpSkRQOTdrbW5xaHlBVVNBQ2oiLCJub25jZSI6IjdhMDdkZTBmLWE4NzktMTFlZC04MjJiLTBhMTYyODk1ODU2MCIsImlhdCI6MTY3NzA1MDc0MDEyMzIzNSwiYXVkIjoiaHR0cHM6Ly90YWxhby5jby9zYW5kYm94L2Vic2kvaXNzdWVyL3ZndmdoeWxvemwifQ.htjRCpFWbRwanAyQcAq9XZ4vxCXyFbzaaN3yPbPxWIcKFFzDDcA4QCHTUl-L4vzWq0R3LSgQFXQ9bo5D9uCm4w'; // ignore: lines_longer_than_80_chars

  //     final isVerified = await oidc4vc.verifyEncodedData(
  //       issuerDid: issuerDid1,
  //       jwt: vcJwt,
  //       issuerKid: issuerKid,
  //     );

  //     expect(isVerified, VerificationType.notVerified);
  //   });

  //   test('returns VerificationType.unKnown', () async {
  //     const vcJwt = 'random';

  //     final isVerified = await oidc4vc.verifyEncodedData(
  //       issuerDid: issuerDid2,
  //       jwt: vcJwt,
  //       issuerKid: issuerKid,
  //     );
  //     expect(isVerified, VerificationType.unKnown);
  //   });

  //   test('returns VerificationType.notVerified for OKP', () async {
  //     const vcJwt = 'eyJraWQiOiItMTkwOTU3MjI1NyIsImFsZyI6IkVkRFNBIn0.'
  //         'eyJqdGkiOiIyMjkxNmYzYy05MDkzLTQ4MTMtODM5Ny1mMTBlNmI3MDRiNjgiLCJkZWxlZ2F0aW9uSWQiOiJiNGFlNDdhNy02MjVhLTQ2MzAtOTcyNy00NTc2NGE3MTJjY2UiLCJleHAiOjE2NTUyNzkxMDksIm5iZiI6MTY1NTI3ODgwOSwic2NvcGUiOiJyZWFkIG9wZW5pZCIsImlzcyI6Imh0dHBzOi8vaWRzdnIuZXhhbXBsZS5jb20iLCJzdWIiOiJ1c2VybmFtZSIsImF1ZCI6ImFwaS5leGFtcGxlLmNvbSIsImlhdCI6MTY1NTI3ODgwOSwicHVycG9zZSI6ImFjY2Vzc190b2tlbiJ9.' // ignore: lines_longer_than_80_chars
  //         'rjeE8D_e4RYzgvpu-nOwwx7PWMiZyDZwkwO6RiHR5t8g4JqqVokUKQt-oST1s45wubacfeDSFogOrIhe3UHDAg'; // ignore: lines_longer_than_80_chars

  //     final isVerified = await oidc4vc.verifyEncodedData(
  //       issuerDid: issuerDid3,
  //       jwt: vcJwt,
  //       issuerKid: issuerKid,
  //     );
  //     expect(isVerified, VerificationType.verified);
  //   });
  // });

  // group('getCredentialRequest', () {
  //   final oidc4vc = OIDC4VC(client);

  //   test('extract correct credential type url from openId', () async {
  //     final url = oidc4vc.getCredentialRequest(givenOpenIdRequest);
  //     expect(
  //       url,
  //       'https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd',
  //     );
  //   });

  //   test('credential type url is empty when url is not OK', () async {
  //     final url = oidc4vc.getCredentialRequest('www.example.com');
  //     expect(url, '');
  //   });
  // });

  // test('extract correct credential type url from openId', () async {
  //   final oidc4vc = OIDC4VC(client);
  //   final url = oidc4vc.getCredentialRequest(givenOpenIdRequest);
  //   expect(
  //     url,
  //     'https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd',
  //   );
  // });

  // group('get token', () {
  //   test('get correct token ', () async {
  //     final oidc4vc = OIDC4VC(client);

  //     final json = <String, dynamic>{
  //       'code': 'cb803d46-9c88-11ed-bdb3-0a1628958560',
  //       'grant_type': 'authorization_code'
  //     };

  //     const expectedValue =
  //         '{"access_token":"7a07dd19-a879-11ed-ad95-0a1628958560","c_nonce":"7a07de0f-a879-11ed-822b-0a1628958560","token_type":"Bearer","expires_in":1000}'; // ignore: lines_longer_than_80_chars

  //     final token = await oidc4vc.getToken(tokenUrl, json);
  //     expect(jsonEncode(token), expectedValue);
  //   });

  //   test('throw expection when invalid value is sent', () async {
  //     expect(
  //       () async {
  //         dioAdapter.onPost(
  //           tokenUrl,
  //           (request) => request.throws(
  //             401,
  //             DioException(requestOptions: RequestOptions(path: tokenUrl)),
  //           ),
  //         );
  //         final oidc4vc = OIDC4VC(client);

  //         final json = <String, dynamic>{};

  //         await oidc4vc.getToken(tokenUrl, json);
  //       },
  //       throwsA(isA<Exception>()),
  //     );
  //   });
  // });

  // group('get did', () {
  //   final oidc4vc = OIDC4VC(client);

  //   const expectedDidP256K =
  //       'did:ebsi:zo9FR1YfAKFP3Q6dvqhxcXxnfeDiJDP97kmnqhyAUSACj';
  //   test('from mnemonic ', () async {
  //     final did = await oidc4vc.getDidFromMnemonic(mnemonic, null);
  //     expect(did, expectedDidP256K);
  //   });

  //   test('from P-256K privateKey ', () async {
  //     const key = {
  //       'crv': 'P-256K',
  //       'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
  //       'kty': 'EC',
  //       'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  //       'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
  //     };
  //     final did = await oidc4vc.getDidFromMnemonic(null, jsonEncode(key));
  //     expect(did, expectedDidP256K);
  //   });
  //   test('from secp256k1 privateKey ', () async {
  //     const expectedDidsecp256k1 =
  //         'did:ebsi:zfuA5yVRZVaKna9pRCHv28yyCYWiXWHZXXvtp3AbTdB4p';
  //     const key = {
  //       'crv': 'secp256k1',
  //       'd': 'jMudzhP9YFNywIeIYYJbHtyizeaXOa1PWdX-qBjPTg8',
  //       'kty': 'EC',
  //       'x': 'yEC4JxUbpYx2-tKExh2NrLpETx-nnudZfcg4AcyL1to',
  //       'y': 'HNh3aF4zQsnf_sFXUVaSzrQF85veDoVxhPQ-163wUYM'
  //     };
  //     final did = await oidc4vc.getDidFromMnemonic(null, jsonEncode(key));
  //     expect(did, expectedDidsecp256k1);
  //   });

  //   group('send Presentation', () {
  //     const url =
  //         'https://talao.co/sandbox/ebsi/login/endpoint/f1722b9e-ae19-11ed-ac9f-0a1628958560';

  //     final uri = Uri.parse(
  //       'openid://?scope=openid&response_type=id_token&client_id=xjcqarovuv&redirect_uri=https%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Flogin%2Fendpoint%2Ff1722b9e-ae19-11ed-ac9f-0a1628958560&claims=%7B%27id_token%27%3A+%7B%27email%27%3A+None%7D%2C+%27vp_token%27%3A+%7B%27presentation_definition%27%3A+%7B%27id%27%3A+%27f17247aa-ae19-11ed-9241-0a1628958560%27%2C+%27input_descriptors%27%3A+%5B%7B%27constraints%27%3A+%7B%27fields%27%3A+%5B%7B%27path%27%3A+%5B%27%24.credentialSchema.id%27%5D%2C+%27filter%27%3A+%7B%27type%27%3A+%27string%27%2C+%27pattern%27%3A+%27https%3A%2F%2Fapi.preprod.oidc4vc.eu%2Ftrusted-schemas-registry%2Fv1%2Fschemas%2F0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd%27%7D%7D%5D%7D%2C+%27id%27%3A+%27f1724e6c-ae19-11ed-a3cf-0a1628958560%27%2C+%27name%27%3A+%27Input+descriptor+1%27%2C+%27purpose%27%3A+%27+%27%7D%5D%2C+%27format%27%3A+%7B%27jwt_vp%27%3A+%7B%27alg%27%3A+%5B%27ES256K%27%2C+%27ES256%27%2C+%27PS256%27%2C+%27RS256%27%5D%7D%7D%7D%7D%7D&nonce=f17239d6-ae19-11ed-8550-0a1628958560',
  //     );

  //     final credentialToBePresented = [
  //       r'{"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","receivedId":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","image":null,"data":{"@context":["https://www.w3.org/2018/credentials/v1"],"credentialSchema":{"id":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd","type":"JsonSchemaValidator2018"},"credentialStatus":{"id":"https://essif.europa.eu/status/education#higherEducation#392ac7f6-399a-437b-a268-4691ead8f176","type":"CredentialStatusList2020"},"credentialSubject":{"awardingOpportunity":{"awardingBody":{"eidasLegalIdentifier":"Unknown","homepage":"https://leaston.bcdiploma.com/","id":"did:ebsi:zdRvvKbXhVVBsXhatjuiBhs","preferredName":"Leaston University","registration":"0597065J"},"endedAtTime":"2020-06-26T00:00:00Z","id":"https://leaston.bcdiploma.com/law-economics-management#AwardingOpportunity","identifier":"https://certificate-demo.bcdiploma.com/check/87ED2F2270E6C41456E94B86B9D9115B4E35BCCAD200A49B846592C14F79C86BV1Fnbllta0NZTnJkR3lDWlRmTDlSRUJEVFZISmNmYzJhUU5sZUJ5Z2FJSHpWbmZZ","location":"FRANCE","startedAtTime":"2019-09-02T00:00:00Z"},"dateOfBirth":"1993-04-08","familyName":"DOE","givenNames":"Jane","gradingScheme":{"id":"https://leaston.bcdiploma.com/law-economics-management#GradingScheme","title":"2 year full-time programme / 4 semesters"},"id":"did:ebsi:zhFWcvr8DFL3cAVdheCpjHg3sPn1WUh9Gynm6hevPFzpw","identifier":"0904008084H","learningAchievement":{"additionalNote":["DISTRIBUTION MANAGEMENT"],"description":"The Master in Information and Computer Sciences (MICS) at the University of Luxembourg enables students to acquire deeper knowledge in computer science by understanding its abstract and interdisciplinary foundations, focusing on problem solving and developing lifelong learning skills.","id":"https://leaston.bcdiploma.com/law-economics-management#LearningAchievment","title":"Master in Information and Computer Sciences"},"learningSpecification":{"ectsCreditPoints":120,"eqfLevel":7,"id":"https://leaston.bcdiploma.com/law-economics-management#LearningSpecification","iscedfCode":["7"],"nqfLevel":["7"]},"type":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"},"evidence":{"documentPresence":["Physical"],"evidenceDocument":["Passport"],"id":"https://essif.europa.eu/tsr-va/evidence/f2aeec97-fc0d-42bf-8ca7-0548192d5678","subjectPresence":"Physical","type":["DocumentVerification"],"verifier":"did:ebsi:2962fb784df61baa267c8132497539f8c674b37c1244a7a"},"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","issuanceDate":"2023-02-16T12:04:19Z","issued":"2023-02-16T12:04:19Z","issuer":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","proof":{"created":"2022-04-27T12:25:07Z","creator":"did:ebsi:zdRvvKbXhVVBsXhatjuiBhs","domain":"https://api.preprod.oidc4vc.eu","jws":"eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFUzI1NksifQ..mIBnM8XDQqSYKQNX_LvaJhmsbyCr5OZ5cU2Zk-ReqLpr4doFsgmoobkO5128tZy-8KimVjJkGw0wL1uBWnMLWQ","nonce":"3ea68dae-d07a-4daa-932b-fbb58f5c20c4","type":"EcdsaSecp256k1Signature2019"},"type":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"],"validFrom":"2023-02-16T12:04:19Z"},"shareLink":"","credentialPreview":{"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","type":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"],"issuer":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","description":[],"name":[],"issuanceDate":"2023-02-16T12:04:19Z","proof":[{"type":"EcdsaSecp256k1Signature2019","proofPurpose":null,"verificationMethod":null,"created":"2022-04-27T12:25:07Z","jws":"eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFUzI1NksifQ..mIBnM8XDQqSYKQNX_LvaJhmsbyCr5OZ5cU2Zk-ReqLpr4doFsgmoobkO5128tZy-8KimVjJkGw0wL1uBWnMLWQ"}],"credentialSubject":{"id":"did:ebsi:zhFWcvr8DFL3cAVdheCpjHg3sPn1WUh9Gynm6hevPFzpw","type":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd","issuedBy":{"name":""},"expires":"","awardingOpportunity":{"awardingBody":{"eidasLegalIdentifier":"Unknown","homepage":"https://leaston.bcdiploma.com/","id":"did:ebsi:zdRvvKbXhVVBsXhatjuiBhs","preferredName":"Leaston University","registration":"0597065J"},"endedAtTime":"2020-06-26T00:00:00Z","id":"https://leaston.bcdiploma.com/law-economics-management#AwardingOpportunity","identifier":"https://certificate-demo.bcdiploma.com/check/87ED2F2270E6C41456E94B86B9D9115B4E35BCCAD200A49B846592C14F79C86BV1Fnbllta0NZTnJkR3lDWlRmTDlSRUJEVFZISmNmYzJhUU5sZUJ5Z2FJSHpWbmZZ","location":"FRANCE","startedAtTime":"2019-09-02T00:00:00Z"},"dateOfBirth":"1993-04-08","familyName":"DOE","givenNames":"Jane","gradingScheme":{"id":"https://leaston.bcdiploma.com/law-economics-management#GradingScheme","title":"2 year full-time programme / 4 semesters"},"identifier":"0904008084H","learningAchievement":{"additionalNote":["DISTRIBUTION MANAGEMENT"],"description":"The Master in Information and Computer Sciences (MICS) at the University of Luxembourg enables students to acquire deeper knowledge in computer science by understanding its abstract and interdisciplinary foundations, focusing on problem solving and developing lifelong learning skills.","id":"https://leaston.bcdiploma.com/law-economics-management#LearningAchievment","title":"Master in Information and Computer Sciences"},"learningSpecification":{"ectsCreditPoints":120,"eqfLevel":7,"id":"https://leaston.bcdiploma.com/law-economics-management#LearningSpecification","iscedfCode":["7"],"nqfLevel":["7"]}},"evidence":[{"id":"https://essif.europa.eu/tsr-va/evidence/f2aeec97-fc0d-42bf-8ca7-0548192d5678","type":["DocumentVerification"]}],"credentialStatus":{"id":"https://essif.europa.eu/status/education#higherEducation#392ac7f6-399a-437b-a268-4691ead8f176","type":"CredentialStatusList2020","revocationListIndex":"","revocationListCredential":""}},"display":{"backgroundColor":"","icon":"","nameFallback":"","descriptionFallback":""},"expirationDate":null,"credential_manifest":{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"id":"diploma_01","schema":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd","name":null,"description":null,"styles":null,"display":{"title":{"path":[],"schema":{"type":"string","format":null},"fallback":"Diploma"},"subtitle":{"path":[],"schema":{"type":"string","format":null},"fallback":"EBSI Verifiable diploma"},"description":{"path":[],"schema":{"type":"string","format":null},"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework."},"properties":[{"label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"type":"string","format":"date"},"fallback":"Unknown"},{"label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number","format":null},"fallback":"Unknown"},{"label":"Issue date","path":["$.issuanceDate"],"schema":{"type":"string","format":"date"},"fallback":"Unknown"},{"label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"type":"string","format":"uri"},"fallback":"Unknown"}]}}],"presentation_definition":null},"challenge":null,"domain":null,"activities":[{"acquisitionAt":"2023-02-16T17:34:24.679713","presentation":null},{"acquisitionAt":null,"presentation":{"issuer":{"preferredName":"","did":[],"organizationInfo":{"id":"","legalName":"","currentAddress":"","website":"domain","issuerDomain":[]}},"presentedAt":"2023-02-16T17:34:47.206600"}}],"jwt":"eyJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiM1MTVhOWM0MzZjMGYyYWQzYWI2NWQ2Y2VmYzVjMWYwNmMwNWI4YWRmY2Y1NGVlMDZkYzgwNTQzMjA0NzBmZmFmIiwidHlwIjoiSldUIn0.eyJleHAiOjE2NzY1NTAwNTkuMjMzMzY3LCJpYXQiOjE2NzY1NDkwNTkuMjMzMzYsImlzcyI6ImRpZDplYnNpOnpoU3c1clBYa2NIanZxdXduVmNUenpCIiwianRpIjoidXJuOnV1aWQ6NmIxZDg0MTEtOWVkNS00NTY2LTljN2YtNGMyNDE2NWZmMjM2IiwibmJmIjoxNjc2NTQ5MDU5LjIzMzM2NCwibm9uY2UiOiIwYTc4MDg2MC1hZGYyLTExZWQtYmIzZS0wYTE2Mjg5NTg1NjAiLCJzdWIiOiJkaWQ6ZWJzaTp6aEZXY3ZyOERGTDNjQVZkaGVDcGpIZzNzUG4xV1VoOUd5bm02aGV2UEZ6cHciLCJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9hcGkucHJlcHJvZC5lYnNpLmV1L3RydXN0ZWQtc2NoZW1hcy1yZWdpc3RyeS92MS9zY2hlbWFzLzB4YmY3OGZjMDhhN2E5ZjI4ZjU0NzlmNThkZWEyNjlkMzY1N2Y1NGYxM2NhMzdkMzgwY2Q0ZTkyMjM3ZmI2OTFkZCIsInR5cGUiOiJKc29uU2NoZW1hVmFsaWRhdG9yMjAxOCJ9LCJjcmVkZW50aWFsU3RhdHVzIjp7ImlkIjoiaHR0cHM6Ly9lc3NpZi5ldXJvcGEuZXUvc3RhdHVzL2VkdWNhdGlvbiNoaWdoZXJFZHVjYXRpb24jMzkyYWM3ZjYtMzk5YS00MzdiLWEyNjgtNDY5MWVhZDhmMTc2IiwidHlwZSI6IkNyZWRlbnRpYWxTdGF0dXNMaXN0MjAyMCJ9LCJjcmVkZW50aWFsU3ViamVjdCI6eyJhd2FyZGluZ09wcG9ydHVuaXR5Ijp7ImF3YXJkaW5nQm9keSI6eyJlaWRhc0xlZ2FsSWRlbnRpZmllciI6IlVua25vd24iLCJob21lcGFnZSI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tLyIsImlkIjoiZGlkOmVic2k6emRSdnZLYlhoVlZCc1hoYXRqdWlCaHMiLCJwcmVmZXJyZWROYW1lIjoiTGVhc3RvbiBVbml2ZXJzaXR5IiwicmVnaXN0cmF0aW9uIjoiMDU5NzA2NUoifSwiZW5kZWRBdFRpbWUiOiIyMDIwLTA2LTI2VDAwOjAwOjAwWiIsImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0F3YXJkaW5nT3Bwb3J0dW5pdHkiLCJpZGVudGlmaWVyIjoiaHR0cHM6Ly9jZXJ0aWZpY2F0ZS1kZW1vLmJjZGlwbG9tYS5jb20vY2hlY2svODdFRDJGMjI3MEU2QzQxNDU2RTk0Qjg2QjlEOTExNUI0RTM1QkNDQUQyMDBBNDlCODQ2NTkyQzE0Rjc5Qzg2QlYxRm5ibGx0YTBOWlRuSmtSM2xEV2xSbVREbFNSVUpFVkZaSVNtTm1ZekpoVVU1c1pVSjVaMkZKU0hwV2JtWloiLCJsb2NhdGlvbiI6IkZSQU5DRSIsInN0YXJ0ZWRBdFRpbWUiOiIyMDE5LTA5LTAyVDAwOjAwOjAwWiJ9LCJkYXRlT2ZCaXJ0aCI6IjE5OTMtMDQtMDgiLCJmYW1pbHlOYW1lIjoiRE9FIiwiZ2l2ZW5OYW1lcyI6IkphbmUiLCJncmFkaW5nU2NoZW1lIjp7ImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0dyYWRpbmdTY2hlbWUiLCJ0aXRsZSI6IjIgeWVhciBmdWxsLXRpbWUgcHJvZ3JhbW1lIC8gNCBzZW1lc3RlcnMifSwiaWQiOiJkaWQ6ZWJzaTp6aEZXY3ZyOERGTDNjQVZkaGVDcGpIZzNzUG4xV1VoOUd5bm02aGV2UEZ6cHciLCJpZGVudGlmaWVyIjoiMDkwNDAwODA4NEgiLCJsZWFybmluZ0FjaGlldmVtZW50Ijp7ImFkZGl0aW9uYWxOb3RlIjpbIkRJU1RSSUJVVElPTiBNQU5BR0VNRU5UIl0sImRlc2NyaXB0aW9uIjoiVGhlIE1hc3RlciBpbiBJbmZvcm1hdGlvbiBhbmQgQ29tcHV0ZXIgU2NpZW5jZXMgKE1JQ1MpIGF0IHRoZSBVbml2ZXJzaXR5IG9mIEx1eGVtYm91cmcgZW5hYmxlcyBzdHVkZW50cyB0byBhY3F1aXJlIGRlZXBlciBrbm93bGVkZ2UgaW4gY29tcHV0ZXIgc2NpZW5jZSBieSB1bmRlcnN0YW5kaW5nIGl0cyBhYnN0cmFjdCBhbmQgaW50ZXJkaXNjaXBsaW5hcnkgZm91bmRhdGlvbnMsIGZvY3VzaW5nIG9uIHByb2JsZW0gc29sdmluZyBhbmQgZGV2ZWxvcGluZyBsaWZlbG9uZyBsZWFybmluZyBza2lsbHMuIiwiaWQiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS9sYXctZWNvbm9taWNzLW1hbmFnZW1lbnQjTGVhcm5pbmdBY2hpZXZtZW50IiwidGl0bGUiOiJNYXN0ZXIgaW4gSW5mb3JtYXRpb24gYW5kIENvbXB1dGVyIFNjaWVuY2VzIn0sImxlYXJuaW5nU3BlY2lmaWNhdGlvbiI6eyJlY3RzQ3JlZGl0UG9pbnRzIjoxMjAsImVxZkxldmVsIjo3LCJpZCI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tL2xhdy1lY29ub21pY3MtbWFuYWdlbWVudCNMZWFybmluZ1NwZWNpZmljYXRpb24iLCJpc2NlZGZDb2RlIjpbIjciXSwibnFmTGV2ZWwiOlsiNyJdfX0sImV2aWRlbmNlIjp7ImRvY3VtZW50UHJlc2VuY2UiOlsiUGh5c2ljYWwiXSwiZXZpZGVuY2VEb2N1bWVudCI6WyJQYXNzcG9ydCJdLCJpZCI6Imh0dHBzOi8vZXNzaWYuZXVyb3BhLmV1L3Rzci12YS9ldmlkZW5jZS9mMmFlZWM5Ny1mYzBkLTQyYmYtOGNhNy0wNTQ4MTkyZDU2NzgiLCJzdWJqZWN0UHJlc2VuY2UiOiJQaHlzaWNhbCIsInR5cGUiOlsiRG9jdW1lbnRWZXJpZmljYXRpb24iXSwidmVyaWZpZXIiOiJkaWQ6ZWJzaToyOTYyZmI3ODRkZjYxYmFhMjY3YzgxMzI0OTc1MzlmOGM2NzRiMzdjMTI0NGE3YSJ9LCJpZCI6InVybjp1dWlkOjZiMWQ4NDExLTllZDUtNDU2Ni05YzdmLTRjMjQxNjVmZjIzNiIsImlzc3VhbmNlRGF0ZSI6IjIwMjMtMDItMTZUMTI6MDQ6MTlaIiwiaXNzdWVkIjoiMjAyMy0wMi0xNlQxMjowNDoxOVoiLCJpc3N1ZXIiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiIsInByb29mIjp7ImNyZWF0ZWQiOiIyMDIyLTA0LTI3VDEyOjI1OjA3WiIsImNyZWF0b3IiOiJkaWQ6ZWJzaTp6ZFJ2dktiWGhWVkJzWGhhdGp1aUJocyIsImRvbWFpbiI6Imh0dHBzOi8vYXBpLnByZXByb2QuZWJzaS5ldSIsImp3cyI6ImV5SmlOalFpT21aaGJITmxMQ0pqY21sMElqcGJJbUkyTkNKZExDSmhiR2NpT2lKRlV6STFOa3NpZlEuLm1JQm5NOFhEUXFTWUtRTlhfTHZhSmhtc2J5Q3I1T1o1Y1UyWmstUmVxTHByNGRvRnNnbW9vYmtPNTEyOHRaeS04S2ltVmpKa0d3MHdMMXVCV25NTFdRIiwibm9uY2UiOiIzZWE2OGRhZS1kMDdhLTRkYWEtOTMyYi1mYmI1OGY1YzIwYzQiLCJ0eXBlIjoiRWNkc2FTZWNwMjU2azFTaWduYXR1cmUyMDE5In0sInR5cGUiOlsiVmVyaWZpYWJsZUNyZWRlbnRpYWwiLCJWZXJpZmlhYmxlQXR0ZXN0YXRpb24iLCJWZXJpZmlhYmxlRGlwbG9tYSJdLCJ2YWxpZEZyb20iOiIyMDIzLTAyLTE2VDEyOjA0OjE5WiJ9fQ.7Bmdrkp-hpM7BcNASc7ngjia3cjrZr-nqmP0Plsfnefn26G_yR5fBJV8BT_U2zsMlcqWsxuJ9pS2Vyiq_SrooQ"}'
  //     ];

  //     test('successfully send presentation', () async {
  //       const response =
  //           '{"access":"ok","created":1676566727.680238,"credential_status":"signature check bypassed","holder_did_status":"ok","id_token_status":"ok","qrcode_status":"ok","response_format":"ok","status_code":200,"vp_token_status":"ok"}'; // ignore: lines_longer_than_80_chars
  //       dioAdapter.onGet(
  //         url,
  //         (request) => request.reply(200, jsonDecode(response)),
  //       );
  //       final oidc4vc = OIDC4VC(client);

  //       expect(
  //         () async {
  //           await oidc4vc.sendPresentation(
  //             uri,
  //             credentialToBePresented,
  //             mnemonic,
  //             null,
  //           );
  //         },
  //         returnsNormally,
  //       );
  //     });

  //     test('throw exception', () async {
  //       expect(
  //         () async {
  //           dioAdapter.onPost(
  //             url,
  //             (request) => request.throws(
  //               401,
  //               DioException(requestOptions: RequestOptions(path: tokenUrl)),
  //             ),
  //           );
  //           final oidc4vc = OIDC4VC(client);

  //           await oidc4vc.sendPresentation(
  //             uri,
  //             credentialToBePresented,
  //             mnemonic,
  //             null,
  //           );
  //         },
  //         throwsA(isA<Exception>()),
  //       );
  //     });
  //   });
  // });

  // test('get corresponding did document', () async {
  //   const url =
  //       'https://api-pilot.oidc4vc.eu/did-registry/v3/identifiers/$didKey';
  //   const response = {
  //     '@context': 'https://w3id.org/did/v1',
  //     'id': 'did:ebsi:z24q8qN8UE1j4XAFiFKtvJbH',
  //     'verificationMethod': [
  //       {
  //         'id': 'did:ebsi:z24q8qN8UE1j4XAFiFKtvJbH#keys-1',
  //         'type': 'Secp256k1VerificationKey2018',
  //         'controller': 'did:ebsi:z24q8qN8UE1j4XAFiFKtvJbH',
  //         'publicKeyHex':
  //             '04f9139fbd3b9780863b17e8390934a1017fc8d0f18b84f02acb04f24c9cae261e45745c6507881509b9e6d837329153ea75fafb2c1a5d504702d04f1e22a80ecc' // ignore: lines_longer_than_80_chars
  //       }
  //     ],
  //     'authentication': ['did:ebsi:z24q8qN8UE1j4XAFiFKtvJbH'],
  //     'assertionMethod': ['did:ebsi:z24q8qN8UE1j4XAFiFKtvJbH#keys-1']
  //   };

  //   dioAdapter.onGet(
  //     url,
  //     (request) => request.reply(200, response),
  //   );
  //   final oidc4vc = OIDC4VC(client);

  //   final value = await oidc4vc.getDidDocument(didKey);

  //   expect(value.data, response);
  // });

  // test('sandbox', () {
  //   const cNonce = 'cNonce';
  //   const did = 'did';
  //   const issuer = 'issuer';
  //   final payload = {
  //     'iss': did,
  //     'nonce': cNonce,
  //     'iat': DateTime.now().microsecondsSinceEpoch,
  //     'aud': issuer
  //   };

  //   final jwt = JWT(
  //     // Payload
  //     payload,

  //     issuer: issuer,
  //   );

  //   // Sign it (default with HS256 algorithm)
  //   // ignore: unused_local_variable
  //   final token = jwt.sign(SecretKey('secret passphrase'));
  // });

  // // test('generateToken', () {
  // //   final jwk = {
  // //     'kty': 'OKP',
  // //     'crv': 'Ed25519',
  // //     'd': '-_9OD-PMHKE2mFKEVH5R1vDhEMimtXPUX-2w1Xa0hQ0=',
  // //     'x': '1tknP1Fx-YIQBzw3xXtCwLGgYoTb-nSsNn-k9uzWpuw=',
  // //   };

  // //   final vpTokenPayload = {
  // //     'iss': 'did:ebsi:zrDzYQPDztwjQ8HdXto1B4FVB14fxoiNawZd8eyEuhR7K',
  // //     'nonce': '8dd8d00a-ad17-11ed-9fe9-0a1628958560',
  // //     'iat': '1676455223753366',
  // //     'aud': 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl',
  // //   };

  // //   final oidc4vc = OIDC4VC(client);

  // //   final tokenParameters = TokenParameters(jwk);
  // //   final token = oidc4vc.generateToken(vpTokenPayload, tokenParameters);
  //});
  //}
}
