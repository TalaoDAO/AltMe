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
      'position taste mention august skin taste best air sure acoustic poet ritual'; // ignore: lines_longer_than_80_chars

  test('OIDC4VC class can be instantiated', () {
    final oidc4vc = OIDC4VC();
    expect(oidc4vc, isNotNull);
  });

  group('EBSI DID and JWK', () {
    final oidc4vc = OIDC4VC();

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
    test('JWK from mnemonic', () async {
      final jwk = await oidc4vc.privateKeyFromMnemonic(
        mnemonic: mnemonic,
        indexValue: index,
      );
      expect(jsonDecode(jwk), expectedECJwk);
    });

    group('getPrivateKey', () {
      test('privateKey from mnemonic', () async {
        final jwk = await oidc4vc.getPrivateKey(
          mnemonic: mnemonic,
          indexValue: index,
        );
        expect(jwk, expectedECJwk);
      });

      test('privateKey from key', () async {
        const key = {
          'crv': 'secp256k1',
          'd': 's_wb6Ef1ardGsT5Il6WLRvQ9Zu0lp7I2OVwtzT5iQpo',
          'kty': 'EC',
          'x': 'qs4JLbsmA-7L-3o9V4BoNVrDtYoWE2OOZIvujoVJZ1U',
          'y': '8PLGROkTALZP3YHY5pm0yrMVCjQoctHM3uaxug70mq8',
        };
        final jwk = await oidc4vc.getPrivateKey(
          privateKey: jsonEncode(key),
          indexValue: index,
        );
        expect(jwk, expectedECJwk);
      });
    });

    test('JWK from seeds', () {
      final jwk = oidc4vc.jwkFromSeed(seedBytes: Uint8List.fromList(seedBytes));
      expect(jwk, expectedECJwk);
    });
  });

  group('EBSI: getAuthorizationUriForIssuer', () {
    const issuer = 'https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi';

    const openidConfiguration =
        '{"authorization_server":"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi/authorize_server","credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi","credential_supported":[{"display":[{"locale":"en-GB","name":"Verifiable diploma"}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"]},{"display":[{"locale":"en-GB","name":"Email proof"}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","EmailPass"]},{"display":[{"locale":"en-GB","name":"Verifiable Id"}],"format":"jwt_vc","id":"VerifiableId","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableId"]}],"credentials_supported":[{"display":[{"locale":"en-GB","name":"Verifiable diploma"}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"]},{"display":[{"locale":"en-GB","name":"Email proof"}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","EmailPass"]},{"display":[{"locale":"en-GB","name":"Verifiable Id"}],"format":"jwt_vc","id":"VerifiableId","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableId"]}],"deferred_credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi/deferred","service_documentation":"New environment for V3 compliance test, use specific did:key"}';

    const selectedCredentials = [
      {
        'format': 'jwt_vc',
        'types': [
          'VerifiableCredential',
          'VerifiableAttestation',
          'VerifiableDiploma',
        ],
      }
    ];
    const clientId =
        'did:key:zBhBLmYmyihtomRdJJNEKzbPj51o4a3GYFeZoRHSABKUwqdjiQPY2fjSoTWRD2nvVmaLnLHU8GXeGFmL1ed8ZAoPGoDeBMwcp4XFchNeTw917v2evpUjyst2gxZuRrVDSxDCb6G2Z1Tbz8kWHbjfUKgLVQd7CexS5GvPHfSQGdsLdjj4cNZvvZa';
    const webLink = 'https://app.altme.io/app/download/oidc4vc';
    const schema =
        'openid-credential-offer://?credential_offer_uri=https://talao.co/sandbox/ebsi/issuer/credential_offer_uri/a572f0a6-56a9-11ee-ac4f-0a1628958560';
    const issuerState = 'a53d709e-56a9-11ee-828d-0a1628958560';
    const nonce = '6044cc7d-2bd9-4804-82ae-c9950d8eedd8';
    const options = '[0]';
    const state = '4eee52c0-e524-4b62-a005-629e97f82dc5';
    const pkcePair = PkcePair(
      'l-NEmG-JlH-VwUxNoNmv8NPD47K_2Pu0hEY6tAHg9pE',
      'E0BAjRGdb3bspwyNsGnRDcV1zHp4CyCB7_2EQUsB4Ls',
    );
    // test(
    //   'given Url of openid request we return Uri for authentication endpoint',
    //   () async {
    //     final expectedAuthorizationEndpointdUri = Uri.parse(
    //         'https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi/authorize?response_type=code&client_id=did%3Akey%3AzBhBLmYmyihtomRdJJNEKzbPj51o4a3GYFeZoRHSABKUwqdjiQPY2fjSoTWRD2nvVmaLnLHU8GXeGFmL1ed8ZAoPGoDeBMwcp4XFchNeTw917v2evpUjyst2gxZuRrVDSxDCb6G2Z1Tbz8kWHbjfUKgLVQd7CexS5GvPHfSQGdsLdjj4cNZvvZa&redirect_uri=https%3A%2F%2Fapp.altme.io%2Fapp%2Fdownload%2Foidc4vc%3Furi%3Dopenid-credential-offer%3A%2F%2F%3Fcredential_offer_uri%3Dhttps%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Fissuer%2Fcredential_offer_uri%2Fa572f0a6-56a9-11ee-ac4f-0a1628958560%26code_verifier%3Dl-NEmG-JlH-VwUxNoNmv8NPD47K_2Pu0hEY6tAHg9pE%26options%3D%5B0%5D&scope=openid&issuer_state=a53d709e-56a9-11ee-828d-0a1628958560&state=4eee52c0-e524-4b62-a005-629e97f82dc5&nonce=6044cc7d-2bd9-4804-82ae-c9950d8eedd8&code_challenge=E0BAjRGdb3bspwyNsGnRDcV1zHp4CyCB7_2EQUsB4Ls&code_challenge_method=S256&authorization_details=%5B%7B%22type%22%3A%22openid_credential%22%2C%22locations%22%3A%5B%22https%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Fissuer%2Fpcbrwbvrsi%22%5D%2C%22format%22%3A%22jwt_vc%22%2C%22types%22%3A%5B%22VerifiableCredential%22%2C%22VerifiableAttestation%22%2C%22VerifiableDiploma%22%5D%7D%5D&client_metadata=%7B%22authorization_endpoint%22%3A%22https%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Fissuer%2Fpcbrwbvrsi%2Fauthorize%22%2C%22scopes_supported%22%3A%5B%22openid%22%5D%2C%22response_types_supported%22%3A%5B%22vp_token%22%2C%22id_token%22%5D%2C%22subject_types_supported%22%3A%5B%22public%22%5D%2C%22id_token_signing_alg_values_supported%22%3A%5B%22ES256%22%5D%2C%22request_object_signing_alg_values_supported%22%3A%5B%22ES256%22%5D%2C%22vp_formats_supported%22%3A%7B%22jwt_vp%22%3A%7B%22alg_values_supported%22%3A%5B%22ES256%22%5D%7D%2C%22jwt_vc%22%3A%7B%22alg_values_supported%22%3A%5B%22ES256%22%5D%7D%7D%2C%22subject_syntax_types_supported%22%3A%5B%22urn%3Aietf%3Aparams%3Aoauth%3Ajwk-thumbprint%22%2C%22did%F0%9F%94%91jwk_jcs-pub%22%5D%2C%22id_token_types_supported%22%3A%5B%22subject_signed_id_token%22%5D%7D');

    //     dioAdapter.onGet(
    //       issuer,
    //       (request) => request.reply(200, jsonDecode(openidConfiguration)),
    //     );

    //     final oidc4vc = OIDC4VC();

    //     final authorizationEndpointdUri =
    //         await oidc4vc.getAuthorizationUriForIssuer(
    //       selectedCredentials: selectedCredentials,
    //       clientId: clientId,
    //       webLink: webLink,
    //       schema: schema,
    //       issuer: issuer,
    //       issuerState: issuerState,
    //       nonce: nonce,
    //       options: options,
    //       state: state,
    //       pkcePair: pkcePair,
    //     );

    //     expect(
    //       authorizationEndpointdUri.toString(),
    //       expectedAuthorizationEndpointdUri.toString(),
    //     );
    //   },
    // );

    test(
      'throw Exception with when request is not valid',
      () async {
        final oidc4vc = OIDC4VC();

        // expect(
        //   () async => oidc4vc.getAuthorizationUriForIssuer(
        //     selectedCredentials: [],
        //     clientId: '',
        //     webLink: '',
        //     schema: '',
        //     issuer: '',
        //     issuerState: '',
        //     nonce: '',
        //     options: '',
        //     state: '',
        //     pkcePair: const PkcePair(
        //       '',
        //       '',
        //     ),
        //   ),
        //   throwsA(
        //     isA<Exception>().having(
        //       (p0) => p0.toString(),
        //       'toString()',
        //       'Exception: Not a valid openid url to initiate issuance',
        //     ),
        //   ),
        // );
      },
    );

    test(
      'given correct authorization request parameter',
      () async {
        const openIdConfigurationResponse =
            '{"authorization_server":"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi/authorize_server","credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi","credentials_supported":[{"display":[{"locale":"en-GB","name":"Verifiable diploma"}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"]},{"display":[{"locale":"en-GB","name":"Email proof"}],"format":"jwt_vc","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","EmailPass"]},{"display":[{"locale":"en-GB","name":"Verifiable Id"}],"format":"jwt_vc","id":"VerifiableId","trust_framework":{"name":"ebsi","type":"Accreditation","uri":"TIR link towards accreditation"},"types":["VerifiableCredential","VerifiableAttestation","VerifiableId"]}],"deferred_credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi/deferred","service_documentation":"New environment for V3 compliance test, use specific did:key"}';
        const expectedAuthorizationRequestParemeters =
            r'{"response_type":"code","client_id":"did:key:zBhBLmYmyihtomRdJJNEKzbPj51o4a3GYFeZoRHSABKUwqdjiQPY2fjSoTWRD2nvVmaLnLHU8GXeGFmL1ed8ZAoPGoDeBMwcp4XFchNeTw917v2evpUjyst2gxZuRrVDSxDCb6G2Z1Tbz8kWHbjfUKgLVQd7CexS5GvPHfSQGdsLdjj4cNZvvZa","redirect_uri":"https://app.altme.io/app/download/oidc4vc?uri=openid-credential-offer://?credential_offer_uri=https://talao.co/sandbox/ebsi/issuer/credential_offer_uri/a572f0a6-56a9-11ee-ac4f-0a1628958560&code_verifier=l-NEmG-JlH-VwUxNoNmv8NPD47K_2Pu0hEY6tAHg9pE&options=[0]","scope":"openid","issuer_state":"a53d709e-56a9-11ee-828d-0a1628958560","state":"4eee52c0-e524-4b62-a005-629e97f82dc5","nonce":"6044cc7d-2bd9-4804-82ae-c9950d8eedd8","code_challenge":"E0BAjRGdb3bspwyNsGnRDcV1zHp4CyCB7_2EQUsB4Ls","code_challenge_method":"S256","authorization_details":"[{\"type\":\"openid_credential\",\"locations\":[\"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi\"],\"format\":\"jwt_vc\",\"types\":[\"VerifiableCredential\",\"VerifiableAttestation\",\"VerifiableDiploma\"]}]","client_metadata":"{\"authorization_endpoint\":\"https://talao.co/sandbox/ebsi/issuer/pcbrwbvrsi/authorize\",\"scopes_supported\":[\"openid\"],\"response_types_supported\":[\"vp_token\",\"id_token\"],\"subject_types_supported\":[\"public\"],\"id_token_signing_alg_values_supported\":[\"ES256\"],\"request_object_signing_alg_values_supported\":[\"ES256\"],\"vp_formats_supported\":{\"jwt_vp\":{\"alg_values_supported\":[\"ES256\"]},\"jwt_vc\":{\"alg_values_supported\":[\"ES256\"]}},\"subject_syntax_types_supported\":[\"urn:ietf:params:oauth:jwk-thumbprint\",\"did🔑jwk_jcs-pub\"],\"id_token_types_supported\":[\"subject_signed_id_token\"]}"}';
        final oidc4vc = OIDC4VC();

        // final authorizationRequestParemeters =
        //     oidc4vc.getAuthorizationRequestParemeters(
        //   selectedCredentials: selectedCredentials,
        //   clientId: clientId,
        //   webLink: webLink,
        //   schema: schema,
        //   issuer: issuer,
        //   issuerState: issuerState,
        //   nonce: nonce,
        //   options: options,
        //   state: state,
        //   pkcePair: pkcePair,
        //   openidConfigurationResponse:
        //       jsonDecode(openIdConfigurationResponse) as Map<String, dynamic>,
        // );

        // expect(
        //   jsonEncode(authorizationRequestParemeters),
        //   expectedAuthorizationRequestParemeters,
        // );
      },
    );
  });
  //group('OIC4VC request credential', () {
  // final credentialRequest = Uri.parse(
  //   'https://app.altme.io/app/download?credential_type=https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl?code=cb803d46-9c88-11ed-bdb3-0a1628958560&state=0d189873-9c87-11ed-8dbf-0a1628958560',
  // );

  // final credentialRequestWithPreAuthorizedCode = Uri.parse(
  //   'openid://initiate_issuance?issuer=https%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Fissuer%2Fvgvghylozl&credential_type=https%3A%2F%2Fapi.preprod.oidc4vc.eu%2Ftrusted-schemas-registry%2Fv1%2Fschemas%2F0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&op_state=test&pre-authorized_code=ff8e73c5-ae07-11ed-b1f7-0a1628958560&user_pin_required=False',
  // );

  // const issuerResponse =
  //     r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.oidc4vc.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":true,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';

  // const tokenResponse =
  //     '{"access_token":"7a07dd19-a879-11ed-ad95-0a1628958560","c_nonce":"7a07de0f-a879-11ed-822b-0a1628958560","token_type":"Bearer","expires_in":1000}'; // ignore: lines_longer_than_80_chars

  // const credentialRequestUrl =
  //     'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential';

  // const credentialRequestResponse =
  //     '{"format":"jwt_vc","credential":"eyJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiM1MTVhOWM0MzZjMGYyYWQzYWI2NWQ2Y2VmYzVjMWYwNmMwNWI4YWRmY2Y1NGVlMDZkYzgwNTQzMjA0NzBmZmFmIiwidHlwIjoiSldUIn0.eyJleHAiOjE2NzU5NDcwNTguODkyNzc4LCJpYXQiOjE2NzU5NDYwNTguODkyNzcxLCJpc3MiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiIsImp0aSI6InVybjp1dWlkOjZiMWQ4NDExLTllZDUtNDU2Ni05YzdmLTRjMjQxNjVmZjIzNiIsIm5iZiI6MTY3NTk0NjA1OC44OTI3NzYsIm5vbmNlIjoiMTFmNWY2MDAtYTg3Ni0xMWVkLTkwZjItMGExNjI4OTU4NTYwIiwic3ViIjoiZGlkOmVic2k6em94UkdWWlFuZFRmUWs1NEI3dEtkd3dOZGhhaTVnbTlGOE5hdjhlY2VOQUJhIiwidmMiOnsiQGNvbnRleHQiOlsiaHR0cHM6Ly93d3cudzMub3JnLzIwMTgvY3JlZGVudGlhbHMvdjEiXSwiY3JlZGVudGlhbFNjaGVtYSI6eyJpZCI6Imh0dHBzOi8vYXBpLnByZXByb2QuZWJzaS5ldS90cnVzdGVkLXNjaGVtYXMtcmVnaXN0cnkvdjEvc2NoZW1hcy8weGJmNzhmYzA4YTdhOWYyOGY1NDc5ZjU4ZGVhMjY5ZDM2NTdmNTRmMTNjYTM3ZDM4MGNkNGU5MjIzN2ZiNjkxZGQiLCJ0eXBlIjoiSnNvblNjaGVtYVZhbGlkYXRvcjIwMTgifSwiY3JlZGVudGlhbFN0YXR1cyI6eyJpZCI6Imh0dHBzOi8vZXNzaWYuZXVyb3BhLmV1L3N0YXR1cy9lZHVjYXRpb24jaGlnaGVyRWR1Y2F0aW9uIzM5MmFjN2Y2LTM5OWEtNDM3Yi1hMjY4LTQ2OTFlYWQ4ZjE3NiIsInR5cGUiOiJDcmVkZW50aWFsU3RhdHVzTGlzdDIwMjAifSwiY3JlZGVudGlhbFN1YmplY3QiOnsiYXdhcmRpbmdPcHBvcnR1bml0eSI6eyJhd2FyZGluZ0JvZHkiOnsiZWlkYXNMZWdhbElkZW50aWZpZXIiOiJVbmtub3duIiwiaG9tZXBhZ2UiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS8iLCJpZCI6ImRpZDplYnNpOnpkUnZ2S2JYaFZWQnNYaGF0anVpQmhzIiwicHJlZmVycmVkTmFtZSI6IkxlYXN0b24gVW5pdmVyc2l0eSIsInJlZ2lzdHJhdGlvbiI6IjA1OTcwNjVKIn0sImVuZGVkQXRUaW1lIjoiMjAyMC0wNi0yNlQwMDowMDowMFoiLCJpZCI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tL2xhdy1lY29ub21pY3MtbWFuYWdlbWVudCNBd2FyZGluZ09wcG9ydHVuaXR5IiwiaWRlbnRpZmllciI6Imh0dHBzOi8vY2VydGlmaWNhdGUtZGVtby5iY2RpcGxvbWEuY29tL2NoZWNrLzg3RUQyRjIyNzBFNkM0MTQ1NkU5NEI4NkI5RDkxMTVCNEUzNUJDQ0FEMjAwQTQ5Qjg0NjU5MkMxNEY3OUM4NkJWMUZuYmxsdGEwTlpUbkprUjNsRFdsUm1URGxTUlVKRVZGWklTbU5tWXpKaFVVNXNaVUo1WjJGSlNIcFdibVpaIiwibG9jYXRpb24iOiJGUkFOQ0UiLCJzdGFydGVkQXRUaW1lIjoiMjAxOS0wOS0wMlQwMDowMDowMFoifSwiZGF0ZU9mQmlydGgiOiIxOTkzLTA0LTA4IiwiZmFtaWx5TmFtZSI6IkRPRSIsImdpdmVuTmFtZXMiOiJKYW5lIiwiZ3JhZGluZ1NjaGVtZSI6eyJpZCI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tL2xhdy1lY29ub21pY3MtbWFuYWdlbWVudCNHcmFkaW5nU2NoZW1lIiwidGl0bGUiOiIyIHllYXIgZnVsbC10aW1lIHByb2dyYW1tZSAvIDQgc2VtZXN0ZXJzIn0sImlkIjoiZGlkOmVic2k6em94UkdWWlFuZFRmUWs1NEI3dEtkd3dOZGhhaTVnbTlGOE5hdjhlY2VOQUJhIiwiaWRlbnRpZmllciI6IjA5MDQwMDgwODRIIiwibGVhcm5pbmdBY2hpZXZlbWVudCI6eyJhZGRpdGlvbmFsTm90ZSI6WyJESVNUUklCVVRJT04gTUFOQUdFTUVOVCJdLCJkZXNjcmlwdGlvbiI6IlRoZSBNYXN0ZXIgaW4gSW5mb3JtYXRpb24gYW5kIENvbXB1dGVyIFNjaWVuY2VzIChNSUNTKSBhdCB0aGUgVW5pdmVyc2l0eSBvZiBMdXhlbWJvdXJnIGVuYWJsZXMgc3R1ZGVudHMgdG8gYWNxdWlyZSBkZWVwZXIga25vd2xlZGdlIGluIGNvbXB1dGVyIHNjaWVuY2UgYnkgdW5kZXJzdGFuZGluZyBpdHMgYWJzdHJhY3QgYW5kIGludGVyZGlzY2lwbGluYXJ5IGZvdW5kYXRpb25zLCBmb2N1c2luZyBvbiBwcm9ibGVtIHNvbHZpbmcgYW5kIGRldmVsb3BpbmcgbGlmZWxvbmcgbGVhcm5pbmcgc2tpbGxzLiIsImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0xlYXJuaW5nQWNoaWV2bWVudCIsInRpdGxlIjoiTWFzdGVyIGluIEluZm9ybWF0aW9uIGFuZCBDb21wdXRlciBTY2llbmNlcyJ9LCJsZWFybmluZ1NwZWNpZmljYXRpb24iOnsiZWN0c0NyZWRpdFBvaW50cyI6MTIwLCJlcWZMZXZlbCI6NywiaWQiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS9sYXctZWNvbm9taWNzLW1hbmFnZW1lbnQjTGVhcm5pbmdTcGVjaWZpY2F0aW9uIiwiaXNjZWRmQ29kZSI6WyI3Il0sIm5xZkxldmVsIjpbIjciXX19LCJldmlkZW5jZSI6eyJkb2N1bWVudFByZXNlbmNlIjpbIlBoeXNpY2FsIl0sImV2aWRlbmNlRG9jdW1lbnQiOlsiUGFzc3BvcnQiXSwiaWQiOiJodHRwczovL2Vzc2lmLmV1cm9wYS5ldS90c3ItdmEvZXZpZGVuY2UvZjJhZWVjOTctZmMwZC00MmJmLThjYTctMDU0ODE5MmQ1Njc4Iiwic3ViamVjdFByZXNlbmNlIjoiUGh5c2ljYWwiLCJ0eXBlIjpbIkRvY3VtZW50VmVyaWZpY2F0aW9uIl0sInZlcmlmaWVyIjoiZGlkOmVic2k6Mjk2MmZiNzg0ZGY2MWJhYTI2N2M4MTMyNDk3NTM5ZjhjNjc0YjM3YzEyNDRhN2EifSwiaWQiOiJ1cm46dXVpZDo2YjFkODQxMS05ZWQ1LTQ1NjYtOWM3Zi00YzI0MTY1ZmYyMzYiLCJpc3N1YW5jZURhdGUiOiIyMDIzLTAyLTA5VDEyOjM0OjE4WiIsImlzc3VlZCI6IjIwMjMtMDItMDlUMTI6MzQ6MThaIiwiaXNzdWVyIjoiZGlkOmVic2k6emhTdzVyUFhrY0hqdnF1d25WY1R6ekIiLCJwcm9vZiI6eyJjcmVhdGVkIjoiMjAyMi0wNC0yN1QxMjoyNTowN1oiLCJjcmVhdG9yIjoiZGlkOmVic2k6emRSdnZLYlhoVlZCc1hoYXRqdWlCaHMiLCJkb21haW4iOiJodHRwczovL2FwaS5wcmVwcm9kLmVic2kuZXUiLCJqd3MiOiJleUppTmpRaU9tWmhiSE5sTENKamNtbDBJanBiSW1JMk5DSmRMQ0poYkdjaU9pSkZVekkxTmtzaWZRLi5tSUJuTThYRFFxU1lLUU5YX0x2YUpobXNieUNyNU9aNWNVMlprLVJlcUxwcjRkb0ZzZ21vb2JrTzUxMjh0WnktOEtpbVZqSmtHdzB3TDF1QlduTUxXUSIsIm5vbmNlIjoiM2VhNjhkYWUtZDA3YS00ZGFhLTkzMmItZmJiNThmNWMyMGM0IiwidHlwZSI6IkVjZHNhU2VjcDI1NmsxU2lnbmF0dXJlMjAxOSJ9LCJ0eXBlIjpbIlZlcmlmaWFibGVDcmVkZW50aWFsIiwiVmVyaWZpYWJsZUF0dGVzdGF0aW9uIiwiVmVyaWZpYWJsZURpcGxvbWEiXSwidmFsaWRGcm9tIjoiMjAyMy0wMi0wOVQxMjozNDoxOFoifX0.uQK9sK-VtqmKjLJIw_v5Ff5xAMDAosZCtl1LFYxZhUolReD6a7O-NI1f5lcswBCZPLfJ-HJyb5iShehHObzFDA","c_nonce":"128952c8-a876-11ed-bbc4-0a1628958560","c_nonce_expires_in":1000}'; // ignore: lines_longer_than_80_chars

  // dioAdapter
  //   ..onGet(
  //     issuer,
  //     (request) => request.reply(200, jsonDecode(issuerResponse)),
  //   )
  //   ..onPost(
  //     'tokenUrl',
  //     (request) => request.reply(
  //       200,
  //       jsonDecode(tokenResponse),
  //     ),
  //   )
  //   ..onPost(
  //     credentialRequestUrl,
  //     (request) => request.reply(
  //       200,
  //       jsonDecode(credentialRequestResponse),
  //     ),
  //   );

  // test('When getCredentialType receive url it returns json response',
  //     () async {
  //   final oidc4vc = OIDC4VC(client);
  //   final credential = await oidc4vc.getCredential(
  //     credentialRequest,
  //     mnemonic,
  //     null,
  //   );
  //   expect(jsonEncode(credential), credentialRequestResponse);
  // });

  //});
  // test('throw Exception when token is not verified', () {
  //   const issuerDid = 'did:ebsi:zhSw5rPXkcHjvquwnVcTzzB';

  //   const didDocumentUrl =
  //       'https://api-pilot.oidc4vc.eu/did-registry/v3/identifiers/$issuerDid';

  //   const didDocumentResponse =
  //       '{"assertionMethod":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"authentication":["did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53"],"@context":"https://www.w3.org/ns/did/v1","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","verificationMethod":[{"controller":"did:ebsi:zeFCExU2XAAshYkPCpjuahA","id":"did:ebsi:zeFCExU2XAAshYkPCpjuahA#3623b877bbb24b08ba390f3585418f53","publicKeyJwk":{"crv":"P-521","kty":"EC","x":"AekpBQ8ST8a8VcfVOTNl353vSrDCLLJXmPk06wTjxrrjcBpXp5EOnYG_NjFZ6OvLFV1jSfS9tsz4qUxcWceqwQGk","y":"ADSmRA43Z1DSNx_RvcLI87cdL07l6jQyyBXMoxVg_l2Th-x3S1WDhjDly79ajL4Kkd0AZMaZmh9ubmf63e3kyMj2"},"type":"Ed25519VerificationKey2019"}]}';

  //   dioAdapter.onGet(
  //     didDocumentUrl,
  //     (request) => request.reply(200, jsonDecode(didDocumentResponse)),
  //   );

  //   final oidc4vc = OIDC4VC(client);

  //   expect(
  //     () async {
  //       await oidc4vc.getCredential(
  //         credentialRequest,
  //         mnemonic,
  //         null,
  //       );
  //     },
  //     throwsA(
  //       isA<Exception>().having(
  //         (p0) => p0.toString(),
  //         'toString()',
  //         'Exception: VERIFICATION_ISSUE',
  //       ),
  //     ),
  //   );
  // });

  // group('build token data', () {
  //   final oidc4vc = OIDC4VC(client);
  //   test('get token data with credentialRequestUri', () async {
  //     const expectedTokenData =
  //         '{"code":"cb803d46-9c88-11ed-bdb3-0a1628958560","grant_type":"authorization_code"}'; // ignore: lines_longer_than_80_chars
  //     final tokenData = oidc4vc.buildTokenData(
  //       credentialRequest,
  //     );
  //     expect(jsonEncode(tokenData), expectedTokenData);
  //   });

  //   test('get token data with credentialRequestUri', () {
  //     const expectedTokenData =
  //         '{"pre-authorized_code":"ff8e73c5-ae07-11ed-b1f7-0a1628958560","grant_type":"urn:ietf:params:oauth:grant-type:pre-authorized_code"}'; // ignore: lines_longer_than_80_chars
  //     final tokenData =
  //         oidc4vc.buildTokenData(credentialRequestWithPreAuthorizedCode);
  //     expect(jsonEncode(tokenData), expectedTokenData);
  //   });
  // });

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
