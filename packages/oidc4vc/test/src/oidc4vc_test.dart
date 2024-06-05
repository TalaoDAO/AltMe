//ignore_for_file: lines_longer_than_80_chars
// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: unnecessary_string_escapes

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class MockPkcePair extends Mock implements PkcePair {}

class MockSecureStorage extends Mock implements SecureStorageProvider {}

void main() {
  group('OIDC4VC Test', () {
    final client = Dio();
    final dioAdapter =
        DioAdapter(dio: Dio(BaseOptions()), matcher: const UrlRequestMatcher());

    client.httpClientAdapter = dioAdapter;

    const mnemonic =
        'position taste mention august skin taste best air sure acoustic poet ritual';

    final oidc4vc = OIDC4VC();

    final mockSecureStorage = MockSecureStorage();

    setUpAll(() {
      when(() => mockSecureStorage.delete(any()))
          .thenAnswer((_) => Future.value());
    });

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
        final jwk =
            oidc4vc.jwkFromSeed(seedBytes: Uint8List.fromList(seedBytes));
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

      const authorizationEndPoint =
          'https://app.altme.io/app/download/authorize';

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
            secureStorage: mockSecureStorage,
          );

          expect(authorizationEndpoint, expectedAuthorizationEndpoint);
          expect(
            authorizationRequestParemeters,
            expectedAuthorizationRequestParemeters,
          );
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
            '{"pre-authorized_code":"eyJhbGciOiJFUzI1NiIsImtpZCI6ImRpZDplYnNpOjEyMzQja2V5LTEiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL3RhbGFvLmNvL3NhbmRib3gvZWJzaS9pc3N1ZXIvenhoYW9rY2NzaSIsImNsaWVudF9pZCI6Imh0dHBzOi8vc2VsZi1pc3N1ZWQubWUvdjIiLCJleHAiOjE3MTQ2MzU4NDIsImlhdCI6MTcxNDYzNDg0MiwiaXNzIjoiaHR0cHM6Ly90YWxhby5jby9zYW5kYm94L2Vic2kvaXNzdWVyL3p4aGFva2Njc2kiLCJub25jZSI6IjZhMGJkZWUxLTA4NTUtMTFlZi04MzJlLTBhMTYyODk1ODU2MCIsInN1YiI6Imh0dHBzOi8vc2VsZi1pc3N1ZWQubWUvdjIifQ.ViX87lulUM6WZ0lNj5XMEz-Ty5q8nIcI7b-bIYa7VRsqo1wcR_en-8hzN_Q_sp8hqi8lKX80n4jM-DqXqvJk5g","grant_type":"urn:ietf:params:oauth:grant-type:pre-authorized_code","client_id":"did:key:z2dmzD81cgPx8Vki7JbuuMmFYrWPgYoytykUZ3eyqht1j9Kbpog7BZb9wdCJCjHfWMTpjcviuoFJ2fd9AiwsWGMFvhNJ5gVMA2mzHSFqkrLMXdHNeePjiaTP15sw8uaWDfyAxehGHKj7YsxymgVnEhcEJgKsLRJHgJZXAiXJGyRxWPGEYC"}';
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

    group('getIssuer', () {
      test('get issuer with credentialRequestUri', () async {
        const clientId =
            'did:key:z2dmzD81cgPx8Vki7JbuuMmFYrWPgYoytykUZ3eyqht1j9Kbrbpg5is8LfTLuQ1RsW5r7s7ZjbDDFbDgy1tLrdc7Bj3itBGQkuGUQyfzKhFqbUNW2PqJPMSSzWoF2DGSvDSijCtJtYCSRsjSVLrwu5oHNbnPFvSEC4iRZPpU6B6nExRBTa';

        const expectedIssuerJwt =
            'eyJhbGciOiJFUzI1NiIsInR5cCI6Im9wZW5pZDR2Y2ktcHJvb2Yrand0Iiwia2lkIjoidmNEV1FrRzBmbXhmRm90clhKZFRZMEhzQklobTQ2UDZYYzNqcXdVbjRVWSJ9.eyJpc3MiOiJkaWQ6a2V5OnoyZG16RDgxY2dQeDhWa2k3SmJ1dU1tRllyV1BnWW95dHlrVVozZXlxaHQxajlLYnJicGc1aXM4TGZUTHVRMVJzVzVyN3M3WmpiRERGYkRneTF0THJkYzdCajNpdEJHUWt1R1VReWZ6S2hGcWJVTlcyUHFKUE1TU3pXb0YyREdTdkRTaWpDdEp0WUNTUnNqU1ZMcnd1NW9ITmJuUEZ2U0VDNGlSWlBwVTZCNm5FeFJCVGEiLCJpYXQiOjE3MTQ3MTU1NDQsImF1ZCI6Imh0dHBzOi8vdGFsYW8uY28vaXNzdWVyL3p4aGFva2Njc2kiLCJub25jZSI6IjJkYTJkNTA2LTA5MTAtMTFlZi05ZTQ5LTBhMTYyODk1ODU2MCJ9.kmRv9RfhwGmAArHiqsZl7HkxE32vO9hyiVuI-lcMmpBPsgJ_eqPSXvkhSrIoUoKCtWAS3gaTT1hRZ5O0_fk9fA';

        final tokenParameters = IssuerTokenParameters(
          privateKey: {
            'kty': 'EC',
            'crv': 'P-256',
            'd': 'amrwK13ZiYoJ5g0fc6MvXc86RB9ID8VuK_dMowU68FE',
            'x': 'fJQ2c9P_YDep3jzidwykcSlyoC4omqBvd9RHP1nz0cw',
            'y': 'K7VxrW-S1ONuX5cxrWIltF36ac1K8kj9as_o5cyc2zk',
          },
          did: clientId,
          mediaType: MediaType.proofOfOwnership,
          proofHeaderType: ProofHeaderType.kid,
          clientType: ClientType.did,
          clientId: clientId,
          issuer: 'https://talao.co/issuer/zxhaokccsi',
        );
        final issuerJwt = await oidc4vc.getIssuerJwt(
          tokenParameters: tokenParameters,
          clientAuthentication: ClientAuthentication.clientId,
          iss: clientId,
          cnonce: '2da2d506-0910-11ef-9e49-0a1628958560',
        );

        expect(issuerJwt.startsWith('ey'), expectedIssuerJwt.startsWith('ey'));
      });
    });

    test('get readTokenEndPoint with openidConfigurationResponse', () async {
      const issuer = 'https://talao.co/issuer/zxhaokccsi';
      const openidConfigurationResponse =
          '{"authorization_server":"https://talao.co/issuer/zxhaokccsi","credential_endpoint":"https://talao.co/issuer/zxhaokccsi/credential","credential_issuer":"https://talao.co/issuer/zxhaokccsi","subject_syntax_types_supported":null,"token_endpoint":null,"batch_endpoint":null,"authorization_endpoint":null,"subject_trust_frameworks_supported":null,"credentials_supported":[{"display":[{"locale":"en-US","name":"EU Diploma","description":"This the official EBSI VC Diploma","text_color":"#FFFFFF","background_color":"#3B6F6D","background_image":{"url":"https://i.ibb.co/CHqjxrJ/dbc-card-hig-res.png","alt_text":"Connected open cubes in blue with one orange cube as a background of the card"},"logo":{"url":"https://dutchblockchaincoalition.org/assets/images/icons/Logo-DBC.png","alt_text":"An orange block shape, with the text Dutch Blockchain Coalition next to it, portraying the logo of the Dutch Blockchain Coalition."}}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma2"],"id":null,"scope":null,"credentialSubject":{"dateOfBirth":{"display":[{"locale":"en-US","name":"Birth Date"},{"locale":"fr-FR","name":"Date de naissance"}]},"familyName":{"display":[{"locale":"en-US","name":"Family Name"},{"locale":"fr-FR","name":"Nom"}]},"givenNames":{"display":[{"locale":"en-US","name":"First Name"},{"locale":"fr-FR","name":"Prénom"}]}}},{"display":[{"locale":"en-US","name":"Individual attestation","description":"This is the EBSI Individual Verifiable Attestation","text_color":"#FFFFFF","background_color":"#3B6F6D","background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","IndividualVerifiableAttestation"],"id":null,"scope":null,"credentialSubject":{"dateOfBirth":{"display":[{"locale":"en-US","name":"Birth Date"},{"locale":"fr-FR","name":"Date de naissance"}]},"familyName":{"display":[{"locale":"en-US","name":"Family Name"},{"locale":"fr-FR","name":"Nom"}]},"firstName":{"display":[{"locale":"en-US","name":"First Name"},{"locale":"fr-FR","name":"Prénom"}]},"issuing_country":{"display":[{"locale":"en-US","name":"Issued by"},{"locale":"fr-FR","name":"Délivré par"}]},"placeOfBirth":{"display":[{"locale":"en-US","name":"Birth Place"},{"locale":"fr-FR","name":"Lieu de naissance"}]}}},{"display":[{"locale":"en-GB","name":"Email proof","description":"This is a verifiable credential","text_color":null,"background_color":null,"background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","EmailPass"],"id":null,"scope":null,"credentialSubject":null},{"display":[{"locale":"en-GB","name":"Verifiable Id","description":"This is a verifiable credential","text_color":null,"background_color":null,"background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableId"],"id":null,"scope":null,"credentialSubject":null}],"credential_configurations_supported":null,"deferred_credential_endpoint":"https://talao.co/issuer/zxhaokccsi/deferred","service_documentation":null,"credential_manifest":null,"credential_manifests":null,"issuer":null,"jwks_uri":null,"grant_types_supported":null}';
      const openidConfigurationResponse2 =
          '{"authorization_endpoint":"https://talao.co/issuer/zxhaokccsi/authorize","grant_types_supported":["authorization_code","urn:ietf:params:oauth:grant-type:pre-authorized_code"],"id_token_signing_alg_values_supported":["ES256","ES256K","EdDSA","RS256"],"id_token_types_supported":["subject_signed_id_token"],"jwks_uri":"https://talao.co/issuer/zxhaokccsi/jwks","pushed_authorization_request_endpoint":"https://talao.co/issuer/zxhaokccsi/authorize/par","request_authentication_methods_supported":{"authorization_endpoint":["request_object"]},"request_object_signing_alg_values_supported":["ES256","ES256K","EdDSA","RS256"],"request_parameter_supported":true,"request_uri_parameter_supported":true,"response_modes_supported":["query"],"response_types_supported":["vp_token","id_token"],"scopes_supported":["openid"],"subject_syntax_types_discriminations":["did:key:jwk_jcs-pub","did:ebsi:v1"],"subject_syntax_types_supported":["urn:ietf:params:oauth:jwk-thumbprint","did:key","did:ebsi","did:tz","did:pkh","did:hedera","did:key","did:ethr","did:web","did:jwk"],"subject_trust_frameworks_supported":["ebsi"],"subject_types_supported":["public","pairwise"],"token_endpoint":"https://talao.co/issuer/zxhaokccsi/token","token_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","none"]}';

      const expectedTokenEndpoint = 'https://talao.co/issuer/zxhaokccsi/token';

      dioAdapter.onPost(
        '$issuer/.well-known/openid-configuration',
        (request) => request.reply(
          200,
          jsonDecode(openidConfigurationResponse2),
        ),
      );

      final tokenEndpoint = await oidc4vc.readTokenEndPoint(
        dio: client,
        issuer: issuer,
        oidc4vciDraftType: OIDC4VCIDraftType.draft11,
        openIdConfiguration: OpenIdConfiguration.fromJson(
          jsonDecode(openidConfigurationResponse) as Map<String, dynamic>,
        ),
        secureStorage: mockSecureStorage,
      );

      expect(tokenEndpoint, expectedTokenEndpoint);
    });

    test('get issuer did with openidConfigurationResponse', () {
      const openidConfigurationResponse =
          r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"},{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":true,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';

      final issuer = oidc4vc.readIssuerDid(
        Response(
          requestOptions: RequestOptions(),
          data: jsonDecode(openidConfigurationResponse) as Map<String, dynamic>,
        ),
      );
      expect(issuer, 'did:ebsi:zhSw5rPXkcHjvquwnVcTzzB');
    });

    test('get publicKey did with didDocumentResponse', () {
      const didDocument =
          '{"keys":[{"crv":"Ed25519","kid":"AegXN9J71CIQWw7TjhM-eHYZW45TfP0uC5xJduiH_w0","kty":"OKP","x":"FUoLewH4w4-KdaPH2cjZbL--CKYxQRWR05Yd_bIbhQo"}]}';
      const issuerDid = 'https://talao.co/sandbox/issuer/statuslist';
      const holderKid = 'AegXN9J71CIQWw7TjhM-eHYZW45TfP0uC5xJduiH_w0';

      const expectedPublicKey =
          '{"crv":"Ed25519","kid":"AegXN9J71CIQWw7TjhM-eHYZW45TfP0uC5xJduiH_w0","kty":"OKP","x":"FUoLewH4w4-KdaPH2cjZbL--CKYxQRWR05Yd_bIbhQo"}';

      final publicKey = oidc4vc.readPublicKeyJwk(
        issuer: issuerDid,
        holderKid: holderKid,
        didDocument: jsonDecode(didDocument) as Map<String, dynamic>,
      );
      expect(jsonEncode(publicKey), expectedPublicKey);
    });

    group('verify encoded data', () {
      const issuer = 'did:web:talao.co';
      const issuerKid1 = 'did:web:talao.co#key-2';
      const issuerKid2 = 'did:web:talao.co#key-222';
      const issuerKid3 = 'did:web:talao.co#key-21';
      const issuerKid4 = 'did:web:talao.co#key-3';

      const universal = 'https://unires:test@unires.talao.co/1.0/identifiers';

      const jwt =
          'eyJhbGciOiJFUzI1NiIsImtpZCI6ImRpZDp3ZWI6dGFsYW8uY28ja2V5LTIiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjE3NDYyNTUzMDYsImlhdCI6MTcxNDcxOTMwNiwiaXNzIjoiZGlkOndlYjp0YWxhby5jbyIsImp0aSI6InVybjp1dWlkOjEyZjdmNmI1LTA5MWEtMTFlZi04MWU1LTBhMTYyODk1ODU2MCIsIm5iZiI6MTcxNDcxOTMwNiwibm9uY2UiOiIxMWVhZTg1YS0wOTFhLTExZWYtODJkNC0wYTE2Mjg5NTg1NjAiLCJzdWIiOiJkaWQ6andrOmV5SmpjbllpT2lKUUxUSTFOaUlzSW10MGVTSTZJa1ZESWl3aWVDSTZJa1pIYTFScWFrUXhPR1l6VVRsc2FteG9WblEyVnpaMWJqSmtjbFJ1WjJoSU1XOVhSM1JRUmpOZk16Z2lMQ0o1SWpvaVkwWkNhWHBYZURoNE5rbE1XbWt5T1ZkRVFtNHpialU0WldWbGNra3ROVmMxWWxOeGVHaFFVR05RWXlKOSIsInZjIjp7IkBjb250ZXh0IjpbImh0dHBzOi8vd3d3LnczLm9yZy8yMDE4L2NyZWRlbnRpYWxzL3YxIl0sImNyZWRlbnRpYWxTY2hlbWEiOnsiaWQiOiJodHRwczovL2FwaS1jb25mb3JtYW5jZS5lYnNpLmV1L3RydXN0ZWQtc2NoZW1hcy1yZWdpc3RyeS92Mi9zY2hlbWFzL3oyMlpBTWRRdE5Md2k1MVQydmRaWEdHWmFZeWpyc3VQMXl6V3lYWmlyQ0FIdiIsInR5cGUiOiJGdWxsSnNvblNjaGVtYVZhbGlkYXRvcjIwMjEifSwiY3JlZGVudGlhbFN0YXR1cyI6W3siaWQiOiJodHRwczovL3RhbGFvLmNvL3NhbmRib3gvaXNzdWVyL2JpdHN0cmluZ3N0YXR1c2xpc3QvMSM1ODg5NyIsInN0YXR1c0xpc3RDcmVkZW50aWFsIjoiaHR0cHM6Ly90YWxhby5jby9zYW5kYm94L2lzc3Vlci9iaXRzdHJpbmdzdGF0dXNsaXN0LzEiLCJzdGF0dXNMaXN0SW5kZXgiOiI1ODg5NyIsInN0YXR1c1B1cnBvc2UiOiJyZXZvY2F0aW9uIiwidHlwZSI6IkJpdHN0cmluZ1N0YXR1c0xpc3RFbnRyeSJ9XSwiY3JlZGVudGlhbFN1YmplY3QiOnsiZGF0ZUlzc3VlZCI6IjIwMjItMTItMjAiLCJkYXRlT2ZCaXJ0aCI6IjE5MzAtMTAtMDEiLCJmYW1pbHlOYW1lIjoiQ2FzdGFmaW9yaSIsImZpcnN0TmFtZSI6IkJpYW5jYSIsImdlbmRlciI6IkYiLCJ0eXBlIjoiVmVyaWZpYWJsZUlkIn0sImV4cGlyYXRpb25EYXRlIjoiMjAyNS0wNS0wM1QwNjo1NDo1M1oiLCJ0eXBlIjpbIlZlcmlmaWFibGVDcmVkZW50aWFsIiwiVmVyaWZpYWJsZUlkIl0sInZhbGlkRnJvbSI6IjIwMjUtMDUtMDNUMDY6NTQ6NTNaIn19.5DJwR_gUbu-GDpSF7hwXcpmHg-wYmKU_AxOvR4Psimefk0H4JUbX803svm3QhxIK2i4GgMhRWmgqhvML_x7nTw';

      const didDocument =
          r'{"@context":"https://w3id.org/did-resolution/v1","didDocument":{"@context":["https://www.w3.org/ns/did/v1",{"@id":"https://w3id.org/security#publicKeyJwk","@type":"@json"}],"id":"did:web:talao.co","verificationMethod":[{"id":"did:web:talao.co#key-1","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"e":"AQAB","kid":"did:web:talao.co#key-1","kty":"RSA","n":"pPocyKreTAn3YrmGyPYXHklYqUiSSQirGACwJSYYs-ksfw4brtA3SZCmA2sdAO8a2DXfqADwFgVSxJFtJ3GkHLV2ZvOIOnZCX6MF6NIWHB9c64ydrYNJbEy72oyG_-v-sE6rb0x-D-uJe9DFYIURzisyBlNA7imsiZPQniOjPLv0BUgED0vdO5HijFe7XbpVhoU-2oTkHHQ4CadmBZhelCczACkXpOU7mwcImGj9h1__PsyT5VBLi_92-93NimZjechPaaTYEU2u0rfnfVW5eGDYNAynO4Q2bhpFPRTXWZ5Lhnhnq7M76T6DGA3GeAu_MOzB0l4dxpFMJ6wHnekdkQ"}},{"id":"did:web:talao.co#key-2","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"P-256","kty":"EC","x":"Bls7WaGu_jsharYBAzakvuSERIV_IFR2tS64e5p_Y_Q","y":"haeKjXQ9uzyK4Ind1W4SBUkR_9udjjx1OmKK4vl1jko"}},{"id":"did:web:talao.co#key-21","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"P-256","kty":"EC","x":"J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI","y":"HNh3aF4zQsnf_sFXUVaSzrQF85veDoVxhPQ-163wUYM"}},{"id":"did:web:talao.co#key-3","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"Ed25519","kty":"OKP","x":"FUoLewH4w4-KdaPH2cjZbL--CKYxQRWR05Yd_bIbhQo"}},{"id":"did:web:talao.co#key-4","type":"Ed25519VerificationKey2018","controller":"did:web:talao.co","publicKeyBase58":"2S73k5pn5umfnaW31qx6dXFndEn6SmWw7LpgSjNNC5BF"}],"authentication":["did:web:talao.co#key-1","did:web:talao.co#key-2","did:web:talao.co#key-3","did:web:talao.co#key-4"],"assertionMethod":["did:web:talao.co#key-1","did:web:talao.co#key-2","did:web:talao.co#key-3","did:web:talao.co#key-4"],"keyAgreement":["did:web:talao.co#key-3","did:web:talao.co#key-4"],"capabilityInvocation":["did:web:talao.co#key-1","did:web:talao.co#key-4"],"service":[{"id":"did:web:talao.co#domain-1","type":"LinkedDomains","serviceEndpoint":"https://talao.co"}]},"didResolutionMetadata":{"contentType":"application/did+ld+json","pattern":"^(did:web:.+)$","driverUrl":"http://uni-resolver-driver-did-uport:8081/1.0/identifiers/","duration":42,"did":{"didString":"did:web:talao.co","methodSpecificId":"talao.co","method":"web"}},"didDocumentMetadata":{}}';

      dioAdapter.onGet(
        '$universal/$issuer',
        (request) => request.reply(200, jsonDecode(didDocument)),
      );

      test('returns VerificationType.verified', () async {
        final isVerified = await oidc4vc.verifyEncodedData(
          issuer: issuer,
          jwt: jwt,
          issuerKid: issuerKid1,
          dio: client,
          fromStatusList: false,
          isCachingEnabled: false,
          publicJwk: null,
        );
        expect(isVerified, VerificationType.verified);
      });

      test('returns VerificationType.unKnown', () async {
        final isVerified = await oidc4vc.verifyEncodedData(
          issuer: issuer,
          jwt: jwt,
          issuerKid: issuerKid2,
          dio: client,
          fromStatusList: false,
          isCachingEnabled: false,
          publicJwk: null,
        );
        expect(isVerified, VerificationType.unKnown);
      });

      test('returns VerificationType.notVerified', () async {
        const vcJwt =
            'eyJhbGciOiJIUzI1NiJ9.eyJSb2xlIjoiQWRtaW4iLCJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsImV4cCI6MTcxNDcyMjY3NiwiaWF0IjoxNzE0NzIyNjc2fQ.mVQhu1VmyA6LlcA77NmdhUvTrOoawL_VxhrMzkkh7BE';
        final isVerified = await oidc4vc.verifyEncodedData(
          issuer: issuer,
          jwt: vcJwt,
          issuerKid: issuerKid3,
          dio: client,
          fromStatusList: false,
          isCachingEnabled: false,
          publicJwk: null,
        );
        expect(isVerified, VerificationType.notVerified);
      });

      test('returns VerificationType.notVerified for OKP', () async {
        const vcJwt = 'eyJraWQiOiItMTkwOTU3MjI1NyIsImFsZyI6IkVkRFNBIn0.'
            'eyJqdGkiOiIyMjkxNmYzYy05MDkzLTQ4MTMtODM5Ny1mMTBlNmI3MDRiNjgiLCJkZWxlZ2F0aW9uSWQiOiJiNGFlNDdhNy02MjVhLTQ2MzAtOTcyNy00NTc2NGE3MTJjY2UiLCJleHAiOjE2NTUyNzkxMDksIm5iZiI6MTY1NTI3ODgwOSwic2NvcGUiOiJyZWFkIG9wZW5pZCIsImlzcyI6Imh0dHBzOi8vaWRzdnIuZXhhbXBsZS5jb20iLCJzdWIiOiJ1c2VybmFtZSIsImF1ZCI6ImFwaS5leGFtcGxlLmNvbSIsImlhdCI6MTY1NTI3ODgwOSwicHVycG9zZSI6ImFjY2Vzc190b2tlbiJ9.'
            'rjeE8D_e4RYzgvpu-nOwwx7PWMiZyDZwkwO6RiHR5t8g4JqqVokUKQt-oST1s45wubacfeDSFogOrIhe3UHDAg';

        final isVerified = await oidc4vc.verifyEncodedData(
          issuer: issuer,
          jwt: vcJwt,
          issuerKid: issuerKid4,
          dio: client,
          fromStatusList: false,
          isCachingEnabled: false,
          publicJwk: null,
        );
        expect(isVerified, VerificationType.notVerified);
      });
    });

    group('get token', () {
      const tokenEndPoint = 'https://talao.co/issuer/zarbjrqrzj/token';
      const tokenData = {
        'pre-authorized_code': '5cdf5508-0923-11ef-90b1-0a1628958560',
        'grant_type': 'urn:ietf:params:oauth:grant-type:pre-authorized_code',
        'client_id':
            'did:key:zDnaeoAcB8wFcSWqLeiJbCg663C3qAKkEfuuTM9rGWx2NFWCt',
        'user_pin': '4444',
        'tx_code': '4444',
      };

      test('get correct token ', () async {
        const response =
            '{"access_token":"ac9e48a7-0923-11ef-95a3-0a1628958560","c_nonce":"ac9e4a9c-0923-11ef-a47c-0a1628958560","token_type":"Bearer","expires_in":10000,"c_nonce_expires_in":1704466725,"refresh_token":"ac9e49f2-0923-11ef-91ef-0a1628958560"}';

        dioAdapter.onPost(
          tokenEndPoint,
          (request) => request.reply(200, jsonDecode(response)),
        );

        const expectedValue =
            '{"access_token":"ac9e48a7-0923-11ef-95a3-0a1628958560","c_nonce":"ac9e4a9c-0923-11ef-a47c-0a1628958560","token_type":"Bearer","expires_in":10000,"c_nonce_expires_in":1704466725,"refresh_token":"ac9e49f2-0923-11ef-91ef-0a1628958560"}';
        final token = await oidc4vc.getToken(
          dio: client,
          tokenData: tokenData,
          tokenEndPoint: tokenEndPoint,
          authorization: null,
        );

        expect(jsonEncode(token), expectedValue);
      });

      test('throw expection when invalid value is sent', () async {
        expect(
          () async {
            dioAdapter.onPost(
              tokenEndPoint,
              (request) => request.throws(
                401,
                DioException(
                  requestOptions: RequestOptions(path: tokenEndPoint),
                ),
              ),
            );

            await oidc4vc.getToken(
              dio: client,
              tokenData: tokenData,
              tokenEndPoint: tokenEndPoint,
              authorization: null,
            );
          },
          throwsA(isA<Exception>()),
        );
      });
    });

    group(
      'get did document',
      () {
        test('get corresponding did document', () async {
          const issuer = 'did:web:talao.co';
          const universal =
              'https://unires:test@unires.talao.co/1.0/identifiers';

          const didDocument =
              r'{"@context":"https://w3id.org/did-resolution/v1","didDocument":{"@context":["https://www.w3.org/ns/did/v1",{"@id":"https://w3id.org/security#publicKeyJwk","@type":"@json"}],"id":"did:web:talao.co","verificationMethod":[{"id":"did:web:talao.co#key-1","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"e":"AQAB","kid":"did:web:talao.co#key-1","kty":"RSA","n":"pPocyKreTAn3YrmGyPYXHklYqUiSSQirGACwJSYYs-ksfw4brtA3SZCmA2sdAO8a2DXfqADwFgVSxJFtJ3GkHLV2ZvOIOnZCX6MF6NIWHB9c64ydrYNJbEy72oyG_-v-sE6rb0x-D-uJe9DFYIURzisyBlNA7imsiZPQniOjPLv0BUgED0vdO5HijFe7XbpVhoU-2oTkHHQ4CadmBZhelCczACkXpOU7mwcImGj9h1__PsyT5VBLi_92-93NimZjechPaaTYEU2u0rfnfVW5eGDYNAynO4Q2bhpFPRTXWZ5Lhnhnq7M76T6DGA3GeAu_MOzB0l4dxpFMJ6wHnekdkQ"}},{"id":"did:web:talao.co#key-2","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"P-256","kty":"EC","x":"Bls7WaGu_jsharYBAzakvuSERIV_IFR2tS64e5p_Y_Q","y":"haeKjXQ9uzyK4Ind1W4SBUkR_9udjjx1OmKK4vl1jko"}},{"id":"did:web:talao.co#key-21","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"P-256","kty":"EC","x":"J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI","y":"HNh3aF4zQsnf_sFXUVaSzrQF85veDoVxhPQ-163wUYM"}},{"id":"did:web:talao.co#key-3","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"Ed25519","kty":"OKP","x":"FUoLewH4w4-KdaPH2cjZbL--CKYxQRWR05Yd_bIbhQo"}},{"id":"did:web:talao.co#key-4","type":"Ed25519VerificationKey2018","controller":"did:web:talao.co","publicKeyBase58":"2S73k5pn5umfnaW31qx6dXFndEn6SmWw7LpgSjNNC5BF"}],"authentication":["did:web:talao.co#key-1","did:web:talao.co#key-2","did:web:talao.co#key-3","did:web:talao.co#key-4"],"assertionMethod":["did:web:talao.co#key-1","did:web:talao.co#key-2","did:web:talao.co#key-3","did:web:talao.co#key-4"],"keyAgreement":["did:web:talao.co#key-3","did:web:talao.co#key-4"],"capabilityInvocation":["did:web:talao.co#key-1","did:web:talao.co#key-4"],"service":[{"id":"did:web:talao.co#domain-1","type":"LinkedDomains","serviceEndpoint":"https://talao.co"}]},"didResolutionMetadata":{"contentType":"application/did+ld+json","pattern":"^(did:web:.+)$","driverUrl":"http://uni-resolver-driver-did-uport:8081/1.0/identifiers/","duration":42,"did":{"didString":"did:web:talao.co","methodSpecificId":"talao.co","method":"web"}},"didDocumentMetadata":{}}';

          dioAdapter.onGet(
            '$universal/$issuer',
            (request) => request.reply(200, jsonDecode(didDocument)),
          );

          final value = await oidc4vc.getDidDocument(
            didKey: issuer,
            fromStatusList: false,
            isCachingEnabled: false,
            dio: client,
          );

          expect(value, jsonDecode(didDocument));
        });

        test(
            'use public resolver as fallback and get corresponding did document',
            () async {
          const issuer = 'did:web:talao.co';
          const universal =
              'https://unires:test@unires.talao.co/1.0/identifiers';

          const public = 'https://dev.uniresolver.io/1.0/identifiers';

          const didDocument =
              r'{"@context":"https://w3id.org/did-resolution/v1","didDocument":{"@context":["https://www.w3.org/ns/did/v1",{"@id":"https://w3id.org/security#publicKeyJwk","@type":"@json"}],"id":"did:web:talao.co","verificationMethod":[{"id":"did:web:talao.co#key-1","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"e":"AQAB","kid":"did:web:talao.co#key-1","kty":"RSA","n":"pPocyKreTAn3YrmGyPYXHklYqUiSSQirGACwJSYYs-ksfw4brtA3SZCmA2sdAO8a2DXfqADwFgVSxJFtJ3GkHLV2ZvOIOnZCX6MF6NIWHB9c64ydrYNJbEy72oyG_-v-sE6rb0x-D-uJe9DFYIURzisyBlNA7imsiZPQniOjPLv0BUgED0vdO5HijFe7XbpVhoU-2oTkHHQ4CadmBZhelCczACkXpOU7mwcImGj9h1__PsyT5VBLi_92-93NimZjechPaaTYEU2u0rfnfVW5eGDYNAynO4Q2bhpFPRTXWZ5Lhnhnq7M76T6DGA3GeAu_MOzB0l4dxpFMJ6wHnekdkQ"}},{"id":"did:web:talao.co#key-2","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"P-256","kty":"EC","x":"Bls7WaGu_jsharYBAzakvuSERIV_IFR2tS64e5p_Y_Q","y":"haeKjXQ9uzyK4Ind1W4SBUkR_9udjjx1OmKK4vl1jko"}},{"id":"did:web:talao.co#key-21","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"P-256","kty":"EC","x":"J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI","y":"HNh3aF4zQsnf_sFXUVaSzrQF85veDoVxhPQ-163wUYM"}},{"id":"did:web:talao.co#key-3","type":"JwsVerificationKey2020","controller":"did:web:talao.co","publicKeyJwk":{"crv":"Ed25519","kty":"OKP","x":"FUoLewH4w4-KdaPH2cjZbL--CKYxQRWR05Yd_bIbhQo"}},{"id":"did:web:talao.co#key-4","type":"Ed25519VerificationKey2018","controller":"did:web:talao.co","publicKeyBase58":"2S73k5pn5umfnaW31qx6dXFndEn6SmWw7LpgSjNNC5BF"}],"authentication":["did:web:talao.co#key-1","did:web:talao.co#key-2","did:web:talao.co#key-3","did:web:talao.co#key-4"],"assertionMethod":["did:web:talao.co#key-1","did:web:talao.co#key-2","did:web:talao.co#key-3","did:web:talao.co#key-4"],"keyAgreement":["did:web:talao.co#key-3","did:web:talao.co#key-4"],"capabilityInvocation":["did:web:talao.co#key-1","did:web:talao.co#key-4"],"service":[{"id":"did:web:talao.co#domain-1","type":"LinkedDomains","serviceEndpoint":"https://talao.co"}]},"didResolutionMetadata":{"contentType":"application/did+ld+json","pattern":"^(did:web:.+)$","driverUrl":"http://uni-resolver-driver-did-uport:8081/1.0/identifiers/","duration":42,"did":{"didString":"did:web:talao.co","methodSpecificId":"talao.co","method":"web"}},"didDocumentMetadata":{}}';

          dioAdapter
            ..onGet(
              '$universal/$issuer',
              (request) => request.throws(
                500,
                DioException.connectionError(
                  requestOptions: RequestOptions(path: '$universal/$issuer'),
                  reason: 'Internal Server Error',
                ),
              ),
            )
            ..onGet(
              '$public/$issuer',
              (request) => request.reply(200, jsonDecode(didDocument)),
            );

          final value = await oidc4vc.getDidDocument(
            didKey: issuer,
            fromStatusList: false,
            isCachingEnabled: false,
            dio: client,
          );

          expect(value, jsonDecode(didDocument));
        });
        test('get corresponding did document', () async {
          const issuer = 'https://talao.co/issuer/zxhaokccsi';
          const openidConfigurationResponse1 =
              '{"authorization_server":"https://talao.co/issuer/zxhaokccsi","credential_endpoint":"https://talao.co/issuer/zxhaokccsi/credential","credential_issuer":"https://talao.co/issuer/zxhaokccsi","subject_syntax_types_supported":null,"token_endpoint":null,"batch_endpoint":null,"authorization_endpoint":null,"subject_trust_frameworks_supported":null,"credentials_supported":[{"display":[{"locale":"en-US","name":"EU Diploma","description":"This the official EBSI VC Diploma","text_color":"#FFFFFF","background_color":"#3B6F6D","background_image":{"url":"https://i.ibb.co/CHqjxrJ/dbc-card-hig-res.png","alt_text":"Connected open cubes in blue with one orange cube as a background of the card"},"logo":{"url":"https://dutchblockchaincoalition.org/assets/images/icons/Logo-DBC.png","alt_text":"An orange block shape, with the text Dutch Blockchain Coalition next to it, portraying the logo of the Dutch Blockchain Coalition."}}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma2"],"id":null,"scope":null,"credentialSubject":{"dateOfBirth":{"display":[{"locale":"en-US","name":"Birth Date"},{"locale":"fr-FR","name":"Date de naissance"}]},"familyName":{"display":[{"locale":"en-US","name":"Family Name"},{"locale":"fr-FR","name":"Nom"}]},"givenNames":{"display":[{"locale":"en-US","name":"First Name"},{"locale":"fr-FR","name":"Prénom"}]}}},{"display":[{"locale":"en-US","name":"Individual attestation","description":"This is the EBSI Individual Verifiable Attestation","text_color":"#FFFFFF","background_color":"#3B6F6D","background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","IndividualVerifiableAttestation"],"id":null,"scope":null,"credentialSubject":{"dateOfBirth":{"display":[{"locale":"en-US","name":"Birth Date"},{"locale":"fr-FR","name":"Date de naissance"}]},"familyName":{"display":[{"locale":"en-US","name":"Family Name"},{"locale":"fr-FR","name":"Nom"}]},"firstName":{"display":[{"locale":"en-US","name":"First Name"},{"locale":"fr-FR","name":"Prénom"}]},"issuing_country":{"display":[{"locale":"en-US","name":"Issued by"},{"locale":"fr-FR","name":"Délivré par"}]},"placeOfBirth":{"display":[{"locale":"en-US","name":"Birth Place"},{"locale":"fr-FR","name":"Lieu de naissance"}]}}},{"display":[{"locale":"en-GB","name":"Email proof","description":"This is a verifiable credential","text_color":null,"background_color":null,"background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","EmailPass"],"id":null,"scope":null,"credentialSubject":null},{"display":[{"locale":"en-GB","name":"Verifiable Id","description":"This is a verifiable credential","text_color":null,"background_color":null,"background_image":null,"logo":null}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableId"],"id":null,"scope":null,"credentialSubject":null}],"credential_configurations_supported":null,"deferred_credential_endpoint":"https://talao.co/issuer/zxhaokccsi/deferred","service_documentation":null,"credential_manifest":null,"credential_manifests":null,"issuer":null,"jwks_uri":null,"grant_types_supported":null}';
          const openidConfigurationResponse2 =
              '{"authorization_server":null,"credential_endpoint":null,"credential_issuer":null,"subject_syntax_types_supported":null,"token_endpoint":null,"batch_endpoint":null,"authorization_endpoint":null,"subject_trust_frameworks_supported":null,"credentials_supported":null,"credential_configurations_supported":null,"deferred_credential_endpoint":null,"service_documentation":null,"credential_manifest":null,"credential_manifests":null,"issuer":"https://talao.co/sandbox/issuer/statuslist","jwks_uri":"https://talao.co/sandbox/issuer/statuslist/jwks","grant_types_supported":null}';
          const jwkUriResponse =
              '{"keys":[{"crv":"Ed25519","kid":"AegXN9J71CIQWw7TjhM-eHYZW45TfP0uC5xJduiH_w0","kty":"OKP","x":"FUoLewH4w4-KdaPH2cjZbL--CKYxQRWR05Yd_bIbhQo"}]}';

          const expectedDidDocument =
              '{"keys":[{"crv":"Ed25519","kid":"AegXN9J71CIQWw7TjhM-eHYZW45TfP0uC5xJduiH_w0","kty":"OKP","x":"FUoLewH4w4-KdaPH2cjZbL--CKYxQRWR05Yd_bIbhQo"}]}';

          dioAdapter
            ..onGet(
              '$issuer/.well-known/openid-credential-issuer',
              (request) =>
                  request.reply(200, jsonDecode(openidConfigurationResponse1)),
            )
            ..onGet(
              '$issuer/.well-known/openid-configuration',
              (request) =>
                  request.reply(200, jsonDecode(openidConfigurationResponse2)),
            )
            ..onGet(
              'https://talao.co/sandbox/issuer/statuslist/jwks',
              (request) => request.reply(200, jsonDecode(jwkUriResponse)),
            );

          final value = await oidc4vc.getDidDocument(
            didKey: issuer,
            fromStatusList: false,
            isCachingEnabled: false,
            dio: client,
            secureStorage: mockSecureStorage,
          );
          expect(value, jsonDecode(expectedDidDocument));
        });
      },
    );
  });
}
