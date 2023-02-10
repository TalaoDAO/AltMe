// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
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

  final client = Dio();
  final dioAdapter =
      DioAdapter(dio: Dio(BaseOptions()), matcher: const UrlRequestMatcher());
  client.httpClientAdapter = dioAdapter;

  const mnemonic =
      'position taste mention august skin taste best air sure acoustic poet ritual'; // ignore: lines_longer_than_80_chars

  const issuer =
      'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/.well-known/openid-configuration';

  test('EBSI class can be instantiated', () {
    final ebsi = Ebsi(client);
    expect(ebsi, isNotNull);
  });

  group('EBSI DID and JWK', () {
    final ebsi = Ebsi(client);

    const seedBytes = [
      113,
      197,
      150,
      53,
      40,
      198,
      138,
      253,
      98,
      90,
      83,
      97,
      226,
      71,
      225,
      90,
      252,
      6,
      223,
      44,
      144,
      49,
      239,
      40,
      223,
      80,
      238,
      210,
      226,
      145,
      206,
      187
    ];

    const expectedJwk = {
      'crv': 'P-256K',
      'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
      'kty': 'EC',
      'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
      'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
    };
    test('JWK from mnemonic', () async {
      final jwk = await ebsi.privateKeyFromMnemonic(mnemonic: mnemonic);
      expect(jsonDecode(jwk), expectedJwk);
    });

    test('JWK from seeds', () {
      final jwk = ebsi.jwkFromSeed(seedBytes: Uint8List.fromList(seedBytes));
      expect(jwk, expectedJwk);
    });

    test('isEbsiUrl is true', () {
      const openIdRequest =
          'openid://initiate_issuance?issuer=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Fconformance%2Fv2&credential_type=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Ftrusted-schemas-registry%2Fv2%2Fschemas%2FzCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t&conformance=ec4d929a-5439-46fb-b7d3-4a1a80d0c199';

      final isCorrectUrl = ebsi.isEbsiInitiateIssuanceUrl(openIdRequest);
      expect(isCorrectUrl, true);
    });

    test('isEbsiUrl is false', () {
      final isCorrectUrl =
          ebsi.isEbsiInitiateIssuanceUrl('https://example.com');
      expect(isCorrectUrl, false);
    });
  });

  group('EBSI: getAuthorizationUriForIssuer', () {
    const givenOpenIdRequest =
        'openid://initiate_issuance?issuer=https%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Fissuer%2Fvgvghylozl&credential_type=https%3A%2F%2Fapi.preprod.ebsi.eu%2Ftrusted-schemas-registry%2Fv1%2Fschemas%2F0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer_state=c8d25b7e-9bd2-11ed-9d05-0a1628958560';
    const givenredirectUrl = 'app.altme.io/app/download/callback';

    test(
        'given Url of openid request we return Uri for authentication endpoint',
        () async {
      const openidConfiguration =
          r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":false,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';
      final expectedAuthorizationEndpointdUri = Uri.parse(
        'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize?scope=openid&client_id=app.altme.io%2Fapp%2Fdownload%2Fcallback&response_type=code&authorization_details=%5B%7B%22type%22%3A%22openid_credential%22%2C%22credential_type%22%3A%22https%3A%2F%2Fapi.preprod.ebsi.eu%2Ftrusted-schemas-registry%2Fv1%2Fschemas%2F0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd%22%2C%22format%22%3A%22jwt_vc%22%7D%5D&redirect_uri=app.altme.io%2Fapp%2Fdownload%2Fcallback%3Fcredential_type%3Dhttps%3A%2F%2Fapi.preprod.ebsi.eu%2Ftrusted-schemas-registry%2Fv1%2Fschemas%2F0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd%26issuer%3Dhttps%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Fissuer%2Fvgvghylozl&state&op_state',
      );

      dioAdapter.onGet(
        issuer,
        (request) => request.reply(200, jsonDecode(openidConfiguration)),
      );
      final ebsi = Ebsi(client);

      final authorizationEndpointdUri = await ebsi.getAuthorizationUriForIssuer(
        givenOpenIdRequest,
        givenredirectUrl,
      );
      expect(authorizationEndpointdUri, expectedAuthorizationEndpointdUri);
    });

    test('get correct issuer from openid request', () async {
      const expectedIssuer = 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl';
      final ebsi = Ebsi(client);

      final issuer = ebsi.getIssuerFromOpenidRequest(
        givenOpenIdRequest,
      );
      expect(issuer, expectedIssuer);
    });

    test('get correct Autorization RequestParameters', () async {
      const parameters = {
        'scope': 'openid',
        'client_id': 'app.altme.io/app/download/callback',
        'response_type': 'code',
        'authorization_details':
            '[{"type":"openid_credential","credential_type":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd","format":"jwt_vc"}]',
        'redirect_uri':
            'app.altme.io/app/download/callback?credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl',
        'state': null,
        'op_state': null
      };
      final ebsi = Ebsi(client);

      final authorizationRequestParemeters =
          ebsi.getAuthorizationRequestParemeters(
        givenOpenIdRequest,
        givenredirectUrl,
      );

      expect(authorizationRequestParemeters, parameters);
    });
  });

  group('issuer', () {
    final ebsi = Ebsi(client);
    test('get issuer when openIdRequest is good', () {
      const openIdRequest =
          'openid://initiate_issuance?issuer=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Fconformance%2Fv2&credential_type=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Ftrusted-schemas-registry%2Fv2%2Fschemas%2FzCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t&conformance=ec4d929a-5439-46fb-b7d3-4a1a80d0c199';
      const expectedIssuer =
          'https://api.conformance.intebsi.xyz/conformance/v2';

      final issuer = ebsi.getIssuerRequest(openIdRequest);
      expect(issuer, expectedIssuer);
    });

    test('get empty string ' ' when openIdRequest is good', () {
      const openidRequest = 'this is a bad request :-)';
      final ebsi = Ebsi(client);
      expect(ebsi.getIssuerRequest(openidRequest), '');
    });
  });

  group('Ebsi request credential', () {
    final credentialRequest = Uri.parse(
      'https://app.altme.io/app/download?credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl?code=cb803d46-9c88-11ed-bdb3-0a1628958560&state=0d189873-9c87-11ed-8dbf-0a1628958560',
    );

    const issuerResponse =
        r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":true,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';

    const tokenUrl = 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token';

    const tokenResponse =
        '{"access_token":"7a07dd19-a879-11ed-ad95-0a1628958560","c_nonce":"7a07de0f-a879-11ed-822b-0a1628958560","token_type":"Bearer","expires_in":1000}';

    const credentialRequestUrl =
        'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential';

    const credentialRequestResponse =
        '{"format":"jwt_vc","credential":"eyJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiM1MTVhOWM0MzZjMGYyYWQzYWI2NWQ2Y2VmYzVjMWYwNmMwNWI4YWRmY2Y1NGVlMDZkYzgwNTQzMjA0NzBmZmFmIiwidHlwIjoiSldUIn0.eyJleHAiOjE2NzU5NDcwNTguODkyNzc4LCJpYXQiOjE2NzU5NDYwNTguODkyNzcxLCJpc3MiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiIsImp0aSI6InVybjp1dWlkOjZiMWQ4NDExLTllZDUtNDU2Ni05YzdmLTRjMjQxNjVmZjIzNiIsIm5iZiI6MTY3NTk0NjA1OC44OTI3NzYsIm5vbmNlIjoiMTFmNWY2MDAtYTg3Ni0xMWVkLTkwZjItMGExNjI4OTU4NTYwIiwic3ViIjoiZGlkOmVic2k6em94UkdWWlFuZFRmUWs1NEI3dEtkd3dOZGhhaTVnbTlGOE5hdjhlY2VOQUJhIiwidmMiOnsiQGNvbnRleHQiOlsiaHR0cHM6Ly93d3cudzMub3JnLzIwMTgvY3JlZGVudGlhbHMvdjEiXSwiY3JlZGVudGlhbFNjaGVtYSI6eyJpZCI6Imh0dHBzOi8vYXBpLnByZXByb2QuZWJzaS5ldS90cnVzdGVkLXNjaGVtYXMtcmVnaXN0cnkvdjEvc2NoZW1hcy8weGJmNzhmYzA4YTdhOWYyOGY1NDc5ZjU4ZGVhMjY5ZDM2NTdmNTRmMTNjYTM3ZDM4MGNkNGU5MjIzN2ZiNjkxZGQiLCJ0eXBlIjoiSnNvblNjaGVtYVZhbGlkYXRvcjIwMTgifSwiY3JlZGVudGlhbFN0YXR1cyI6eyJpZCI6Imh0dHBzOi8vZXNzaWYuZXVyb3BhLmV1L3N0YXR1cy9lZHVjYXRpb24jaGlnaGVyRWR1Y2F0aW9uIzM5MmFjN2Y2LTM5OWEtNDM3Yi1hMjY4LTQ2OTFlYWQ4ZjE3NiIsInR5cGUiOiJDcmVkZW50aWFsU3RhdHVzTGlzdDIwMjAifSwiY3JlZGVudGlhbFN1YmplY3QiOnsiYXdhcmRpbmdPcHBvcnR1bml0eSI6eyJhd2FyZGluZ0JvZHkiOnsiZWlkYXNMZWdhbElkZW50aWZpZXIiOiJVbmtub3duIiwiaG9tZXBhZ2UiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS8iLCJpZCI6ImRpZDplYnNpOnpkUnZ2S2JYaFZWQnNYaGF0anVpQmhzIiwicHJlZmVycmVkTmFtZSI6IkxlYXN0b24gVW5pdmVyc2l0eSIsInJlZ2lzdHJhdGlvbiI6IjA1OTcwNjVKIn0sImVuZGVkQXRUaW1lIjoiMjAyMC0wNi0yNlQwMDowMDowMFoiLCJpZCI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tL2xhdy1lY29ub21pY3MtbWFuYWdlbWVudCNBd2FyZGluZ09wcG9ydHVuaXR5IiwiaWRlbnRpZmllciI6Imh0dHBzOi8vY2VydGlmaWNhdGUtZGVtby5iY2RpcGxvbWEuY29tL2NoZWNrLzg3RUQyRjIyNzBFNkM0MTQ1NkU5NEI4NkI5RDkxMTVCNEUzNUJDQ0FEMjAwQTQ5Qjg0NjU5MkMxNEY3OUM4NkJWMUZuYmxsdGEwTlpUbkprUjNsRFdsUm1URGxTUlVKRVZGWklTbU5tWXpKaFVVNXNaVUo1WjJGSlNIcFdibVpaIiwibG9jYXRpb24iOiJGUkFOQ0UiLCJzdGFydGVkQXRUaW1lIjoiMjAxOS0wOS0wMlQwMDowMDowMFoifSwiZGF0ZU9mQmlydGgiOiIxOTkzLTA0LTA4IiwiZmFtaWx5TmFtZSI6IkRPRSIsImdpdmVuTmFtZXMiOiJKYW5lIiwiZ3JhZGluZ1NjaGVtZSI6eyJpZCI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tL2xhdy1lY29ub21pY3MtbWFuYWdlbWVudCNHcmFkaW5nU2NoZW1lIiwidGl0bGUiOiIyIHllYXIgZnVsbC10aW1lIHByb2dyYW1tZSAvIDQgc2VtZXN0ZXJzIn0sImlkIjoiZGlkOmVic2k6em94UkdWWlFuZFRmUWs1NEI3dEtkd3dOZGhhaTVnbTlGOE5hdjhlY2VOQUJhIiwiaWRlbnRpZmllciI6IjA5MDQwMDgwODRIIiwibGVhcm5pbmdBY2hpZXZlbWVudCI6eyJhZGRpdGlvbmFsTm90ZSI6WyJESVNUUklCVVRJT04gTUFOQUdFTUVOVCJdLCJkZXNjcmlwdGlvbiI6IlRoZSBNYXN0ZXIgaW4gSW5mb3JtYXRpb24gYW5kIENvbXB1dGVyIFNjaWVuY2VzIChNSUNTKSBhdCB0aGUgVW5pdmVyc2l0eSBvZiBMdXhlbWJvdXJnIGVuYWJsZXMgc3R1ZGVudHMgdG8gYWNxdWlyZSBkZWVwZXIga25vd2xlZGdlIGluIGNvbXB1dGVyIHNjaWVuY2UgYnkgdW5kZXJzdGFuZGluZyBpdHMgYWJzdHJhY3QgYW5kIGludGVyZGlzY2lwbGluYXJ5IGZvdW5kYXRpb25zLCBmb2N1c2luZyBvbiBwcm9ibGVtIHNvbHZpbmcgYW5kIGRldmVsb3BpbmcgbGlmZWxvbmcgbGVhcm5pbmcgc2tpbGxzLiIsImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0xlYXJuaW5nQWNoaWV2bWVudCIsInRpdGxlIjoiTWFzdGVyIGluIEluZm9ybWF0aW9uIGFuZCBDb21wdXRlciBTY2llbmNlcyJ9LCJsZWFybmluZ1NwZWNpZmljYXRpb24iOnsiZWN0c0NyZWRpdFBvaW50cyI6MTIwLCJlcWZMZXZlbCI6NywiaWQiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS9sYXctZWNvbm9taWNzLW1hbmFnZW1lbnQjTGVhcm5pbmdTcGVjaWZpY2F0aW9uIiwiaXNjZWRmQ29kZSI6WyI3Il0sIm5xZkxldmVsIjpbIjciXX19LCJldmlkZW5jZSI6eyJkb2N1bWVudFByZXNlbmNlIjpbIlBoeXNpY2FsIl0sImV2aWRlbmNlRG9jdW1lbnQiOlsiUGFzc3BvcnQiXSwiaWQiOiJodHRwczovL2Vzc2lmLmV1cm9wYS5ldS90c3ItdmEvZXZpZGVuY2UvZjJhZWVjOTctZmMwZC00MmJmLThjYTctMDU0ODE5MmQ1Njc4Iiwic3ViamVjdFByZXNlbmNlIjoiUGh5c2ljYWwiLCJ0eXBlIjpbIkRvY3VtZW50VmVyaWZpY2F0aW9uIl0sInZlcmlmaWVyIjoiZGlkOmVic2k6Mjk2MmZiNzg0ZGY2MWJhYTI2N2M4MTMyNDk3NTM5ZjhjNjc0YjM3YzEyNDRhN2EifSwiaWQiOiJ1cm46dXVpZDo2YjFkODQxMS05ZWQ1LTQ1NjYtOWM3Zi00YzI0MTY1ZmYyMzYiLCJpc3N1YW5jZURhdGUiOiIyMDIzLTAyLTA5VDEyOjM0OjE4WiIsImlzc3VlZCI6IjIwMjMtMDItMDlUMTI6MzQ6MThaIiwiaXNzdWVyIjoiZGlkOmVic2k6emhTdzVyUFhrY0hqdnF1d25WY1R6ekIiLCJwcm9vZiI6eyJjcmVhdGVkIjoiMjAyMi0wNC0yN1QxMjoyNTowN1oiLCJjcmVhdG9yIjoiZGlkOmVic2k6emRSdnZLYlhoVlZCc1hoYXRqdWlCaHMiLCJkb21haW4iOiJodHRwczovL2FwaS5wcmVwcm9kLmVic2kuZXUiLCJqd3MiOiJleUppTmpRaU9tWmhiSE5sTENKamNtbDBJanBiSW1JMk5DSmRMQ0poYkdjaU9pSkZVekkxTmtzaWZRLi5tSUJuTThYRFFxU1lLUU5YX0x2YUpobXNieUNyNU9aNWNVMlprLVJlcUxwcjRkb0ZzZ21vb2JrTzUxMjh0WnktOEtpbVZqSmtHdzB3TDF1QlduTUxXUSIsIm5vbmNlIjoiM2VhNjhkYWUtZDA3YS00ZGFhLTkzMmItZmJiNThmNWMyMGM0IiwidHlwZSI6IkVjZHNhU2VjcDI1NmsxU2lnbmF0dXJlMjAxOSJ9LCJ0eXBlIjpbIlZlcmlmaWFibGVDcmVkZW50aWFsIiwiVmVyaWZpYWJsZUF0dGVzdGF0aW9uIiwiVmVyaWZpYWJsZURpcGxvbWEiXSwidmFsaWRGcm9tIjoiMjAyMy0wMi0wOVQxMjozNDoxOFoifX0.uQK9sK-VtqmKjLJIw_v5Ff5xAMDAosZCtl1LFYxZhUolReD6a7O-NI1f5lcswBCZPLfJ-HJyb5iShehHObzFDA","c_nonce":"128952c8-a876-11ed-bbc4-0a1628958560","c_nonce_expires_in":1000}';
    dioAdapter
      ..onGet(
        issuer,
        (request) => request.reply(200, jsonDecode(issuerResponse)),
      )
      ..onPost(
        tokenUrl,
        (request) => request.reply(
          200,
          jsonDecode(tokenResponse),
        ),
      )
      ..onPost(
        credentialRequestUrl,
        (request) => request.reply(
          200,
          jsonDecode(credentialRequestResponse),
        ),
      );
    final ebsi = Ebsi(client);

    test('When getCredentialType receive url it returns json response',
        () async {
      final credential = await ebsi.getCredential(
        credentialRequest,
        mnemonic,
        null,
      );
      expect(jsonEncode(credential), credentialRequestResponse);
    });

    test('get token data with credentialRequestUri', () async {
      const expectedTokenData =
          '{"code":"cb803d46-9c88-11ed-bdb3-0a1628958560","grant_type":"authorization_code"}';
      final tokenData = ebsi.buildTokenData(
        credentialRequest,
      );
      expect(jsonEncode(tokenData), expectedTokenData);
    });

    test('get issuer with credentialRequestUri', () async {
      const expectedIssuer = 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl';
      final issuer = ebsi.getIssuer(credentialRequest);
      expect(expectedIssuer, issuer);
    });

    test('get readTokenEndPoint with openidConfigurationResponse', () async {});
  });

  test('sandbox', () {
    const cNonce = 'cNonce';
    const did = 'did';
    const issuer = 'issuer';
    final payload = {
      'iss': did,
      'nonce': cNonce,
      'iat': DateTime.now().microsecondsSinceEpoch,
      'aud': issuer
    };

    final jwt = JWT(
      // Payload
      payload,

      issuer: issuer,
    );

// Sign it (default with HS256 algorithm)
    // ignore: unused_local_variable
    final token = jwt.sign(SecretKey('secret passphrase'));
  });
}
