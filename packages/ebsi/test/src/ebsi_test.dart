// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:jose/jose.dart';
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
  group('EBSI DID and JWK', () {
    test('JWK from mnemonic', () async {
      final expectedJwk = {
        'kty': 'EC',
        'crv': 'secp256k1',
        'd': 'lrKEpyoUOWRQIUOepeOpiOWI1ovobYfK9M8hYkcSnxY',
        'x': 'MpE6Qo0XYS7FVM13JADFFjtfg4ehhmdpMFlzR4TsiR8',
        'y': 'up-oVN_-EHHlwup51eHO7qLRS9bdN7faXug2fzTS8Uc',
        'alg': 'ES256K'
      };
      final client = MockDio();
      final ebsi = Ebsi(client);
      const mnemonic =
          'jambon fromage comte camembert pain fleur voiture bac pere mere fille fils';
      final jwk = await ebsi.jwkFromMnemonic(mnemonic: mnemonic);
      expect(jsonDecode(jwk), expectedJwk);
    });
    test('DID from JWK', () async {
      final jwk = {
        'crv': 'secp256k1',
        'd': 'dBE5MSwGh1ypjymY48CGv_FaFQHQUPaZ632rhFVpZNw',
        'kty': 'EC',
        'x': 'liIvy6clecfH9riQNvs1VsX7m1bYmYZ2JsHhpPkey_dictJjfgY',
        'y': 'j8Q9Xfa8MIY78JiEpzMrlJzYz2vTkJY183hJBLLcKiU'
      };

      const expectedDid =
          'did:ebsi:znxntxQrN369GsNyjFjYb8fuvU7g3sJGyYGwMTcUGdzuy';

      final client = MockDio();
      final ebsi = Ebsi(client);
      final did = ebsi.getDidFromJwk(jwk);
      expect(did, expectedDid);
    });
    test('Alice DID from JWK', () async {
      // alice
      final jwk = {
        'kty': 'EC',
        'd': 'd_PpSCGQWWgUc1t4iLLH8bKYlYfc9Zy_M7TsfOAcbg8',
        'use': 'sig',
        'crv': 'P-256',
        'x': 'ngy44T1vxAT6Di4nr-UaM9K3Tlnz9pkoksDokKFkmNc',
        'y': 'QCRfOKlSM31GTkb4JHx3nXB4G_jSPMsbdjzlkT_UpPc',
        'alg': 'ES256',
      };

// alice
      const expectedDid =
          'did:ebsi:znxntxQrN369GsNyjFjYb8fuvU7g3sJGyYGwMTcUGdzuy';

      final client = MockDio();
      final ebsi = Ebsi(client);
      final did = ebsi.getDidFromJwk(jwk);
      expect(did, expectedDid);
    });
    test('Bob DID from JWK', () async {
      // bob
      final jwk = {
        'kty': 'EC',
        'd': 'qAAbNWOBUYBcEuDYHMWE6h4O1hgsSIhMlzR2v17F-Ls',
        'use': 'sig',
        'crv': 'P-256',
        'x': 'n1l8HzJyfmvqCprbrsDoK9sUyRK2DTWoTbOFdRT_6HE',
        'y': 'DDd9ecdyVsFJGVS1f1AtItefpKKZQDt4zFJFpk9G06A',
        'alg': 'ES256',
      };
// bob
      const expectedDid =
          'did:ebsi:zjg6EQC8TzGGEkrKArL1Pci6JhyQo83ZrvUrrnawXi66W';

      final client = MockDio();
      final ebsi = Ebsi(client);
      final did = ebsi.getDidFromJwk(jwk);
      expect(did, expectedDid);
    });
  });

  group('EBSI: getAuthorizationUriForIssuer', () {
    test(
        'given Url of openid request we return Uri for authentication endpoint',
        () async {
      const openidConfiguration =
          r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":false,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';
      final expecteAuthorizationEndpointdUri = Uri.parse(
          'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize');
      const givenredirectUrl = 'app.altme.io/app/download/callback';
      const givenOpenIdRequest =
          'openid://initiate_issuance?issuer=https%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Fissuer%2Fvgvghylozl&credential_type=https%3A%2F%2Fapi.preprod.ebsi.eu%2Ftrusted-schemas-registry%2Fv1%2Fschemas%2F0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer_state=c8d25b7e-9bd2-11ed-9d05-0a1628958560';
      final client = MockDio();
      final ebsi = Ebsi(client);

      when(() => client.get(any())).thenAnswer((_) async {
        return Response(
          data: jsonDecode(openidConfiguration),
          requestOptions: RequestOptions(path: 'myPath'),
        );
      });
      final authorizationEndpointdUri = ebsi.getAuthorizationUriForIssuer(
          givenOpenIdRequest, givenredirectUrl);
      expect(authorizationEndpointdUri, expecteAuthorizationEndpointdUri);
    });
  });

  group('Ebsi request credential', () {
    test('EBSI class can be instantiated', () {
      final client = MockDio();
      expect(Ebsi(client), isNotNull);
    });

    test('isEbsiUrl is true', () {});
    test(
        'When getCredentialRequest receive good url it returns credential_type',
        () {
      const openidRequest =
          'openid://initiate_issuance?issuer=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Fconformance%2Fv2&credential_type=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Ftrusted-schemas-registry%2Fv2%2Fschemas%2FzCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t&conformance=ec4d929a-5439-46fb-b7d3-4a1a80d0c199';
      const credentialTypeRequest =
          'https://api.conformance.intebsi.xyz/trusted-schemas-registry/v2/schemas/zCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t';
      final client = MockDio();
      expect(
        Ebsi(client).getCredentialRequest(openidRequest),
        credentialTypeRequest,
      );
    });
    test('When getCredentialRequest receive bad url it returns ""', () {
      const openidRequest = 'this is a bad request :-)';
      final client = MockDio();
      expect(Ebsi(client).getCredentialRequest(openidRequest), '');
    });

    test('When getCredentialType receive url it returns json response', () {
      final credentialTypeRequest = Uri.parse(
          'https://app.altme.io/app/download?credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl?code=cb803d46-9c88-11ed-bdb3-0a1628958560&state=0d189873-9c87-11ed-8dbf-0a1628958560');
      const jsonResponse =
          r'{"$schema":"http://json-schema.org/draft-07/schema#","title":"EBSI Natural Person Verifiable ID","description":"Schema of an EBSI Verifiable ID for a natural person","type":"object","allOf":[{"$ref":"https://api.conformance.intebsi.xyz/trusted-schemas-registry/v1/schemas/0x28d76954924d1c4747a4f1f9e3e9edc9ca965efbf8ff20e4339c2bf2323a5773"},{"properties":{"credentialSubject":{"description":"Defines additional information about the subject that is described by the Verifiable ID","type":"object","properties":{"id":{"description":"Defines the DID of the subject that is described by the Verifiable Attestation","type":"string","format":"uri"},"familyName":{"description":"Defines current family name(s) of the credential subject","type":"string"},"firstName":{"description":"Defines current first name(s) of the credential subject","type":"string"},"dateOfBirth":{"description":"Defines date of birth of the credential subject","type":"string","format":"date"},"personalIdentifier":{"description":"Defines the unique national identifier of the credential subject (constructed by the sending Member State in accordance with the technical specifications for the purposes of cross-border identification and which is as persistent as possible in time)","type":"string"},"nameAndFamilyNameAtBirth":{"description":"Defines the first and the family name(s) of the credential subject at the time of their birth","type":"string"},"placeOfBirth":{"description":"Defines the place where the credential subjectis born","type":"string"},"currentAddress":{"description":"Defines the current address of the credential subject","type":"string"},"gender":{"description":"Defines the gender of the credential subject","type":"string"}},"required":["id","familyName","firstName","dateOfBirth","personalIdentifier"]}}}]}';
      final client = MockDio();
      when(() => client.get(any())).thenAnswer((_) async {
        return jsonDecode(jsonResponse) as Future<Response>;
      });
      expect(
        Ebsi(client).getCredential(credentialTypeRequest),
        jsonResponse,
      );
    });
    test('When getCredentialType receive url, a request is done with Dio',
        () async {
      final credentialTypeRequest = Uri.parse(
          'https://app.altme.io/app/download?credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl?code=cb803d46-9c88-11ed-bdb3-0a1628958560&state=0d189873-9c87-11ed-8dbf-0a1628958560');
      const jsonResponse =
          r'{"$schema":"http://json-schema.org/draft-07/schema#","title":"EBSI Natural Person Verifiable ID","description":"Schema of an EBSI Verifiable ID for a natural person","type":"object","allOf":[{"$ref":"https://api.conformance.intebsi.xyz/trusted-schemas-registry/v1/schemas/0x28d76954924d1c4747a4f1f9e3e9edc9ca965efbf8ff20e4339c2bf2323a5773"},{"properties":{"credentialSubject":{"description":"Defines additional information about the subject that is described by the Verifiable ID","type":"object","properties":{"id":{"description":"Defines the DID of the subject that is described by the Verifiable Attestation","type":"string","format":"uri"},"familyName":{"description":"Defines current family name(s) of the credential subject","type":"string"},"firstName":{"description":"Defines current first name(s) of the credential subject","type":"string"},"dateOfBirth":{"description":"Defines date of birth of the credential subject","type":"string","format":"date"},"personalIdentifier":{"description":"Defines the unique national identifier of the credential subject (constructed by the sending Member State in accordance with the technical specifications for the purposes of cross-border identification and which is as persistent as possible in time)","type":"string"},"nameAndFamilyNameAtBirth":{"description":"Defines the first and the family name(s) of the credential subject at the time of their birth","type":"string"},"placeOfBirth":{"description":"Defines the place where the credential subjectis born","type":"string"},"currentAddress":{"description":"Defines the current address of the credential subject","type":"string"},"gender":{"description":"Defines the gender of the credential subject","type":"string"}},"required":["id","familyName","firstName","dateOfBirth","personalIdentifier"]}}}]}';
      final client = MockDio();
      when(() => client.get(any())).thenAnswer((_) async {
        return jsonDecode(jsonResponse) as Future<Response>;
      });
      await Ebsi(client).getCredential(credentialTypeRequest);
      verify(() => client.get<String>(credentialTypeRequest.toString()))
          .called(1);
    });
  });

  test('description', () {
    const encoded =
        'eyJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiNVVnFjUTJ3UEt0T3JaZGJPX0Z3ZkJzQmJpdF9QVk80RzNJQlVNZ1J3XzY4IiwidHlwIjoiSldUIn0.eyJleHAiOjE2NzQ2NDIyMjkuMTY0OTU3LCJpYXQiOjE2NzQ2NDEyMjkuMTY0OTUsImlzcyI6ImRpZDplYnNpOnpoU3c1clBYa2NIanZxdXduVmNUenpCIiwianRpIjoidXJuOnV1aWQ6NmIxZDg0MTEtOWVkNS00NTY2LTljN2YtNGMyNDE2NWZmMjM2IiwibmJmIjoxNjc0NjQxMjI5LjE2NDk1NCwibm9uY2UiOiIwNGQ3MTgyOS05Yzk4LTExZWQtYTQ2Ni0wYTE2Mjg5NTg1NjAiLCJzdWIiOiJkaWQ6ZWJzaTp6bVNLZWY2elFaREM2Nk1wcEtMSG91OXpDd2pZRTRGd2FyN05TVnkyYzdheWEiLCJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9hcGkucHJlcHJvZC5lYnNpLmV1L3RydXN0ZWQtc2NoZW1hcy1yZWdpc3RyeS92MS9zY2hlbWFzLzB4YmY3OGZjMDhhN2E5ZjI4ZjU0NzlmNThkZWEyNjlkMzY1N2Y1NGYxM2NhMzdkMzgwY2Q0ZTkyMjM3ZmI2OTFkZCIsInR5cGUiOiJKc29uU2NoZW1hVmFsaWRhdG9yMjAxOCJ9LCJjcmVkZW50aWFsU3RhdHVzIjp7ImlkIjoiaHR0cHM6Ly9lc3NpZi5ldXJvcGEuZXUvc3RhdHVzL2VkdWNhdGlvbiNoaWdoZXJFZHVjYXRpb24jMzkyYWM3ZjYtMzk5YS00MzdiLWEyNjgtNDY5MWVhZDhmMTc2IiwidHlwZSI6IkNyZWRlbnRpYWxTdGF0dXNMaXN0MjAyMCJ9LCJjcmVkZW50aWFsU3ViamVjdCI6eyJhd2FyZGluZ09wcG9ydHVuaXR5Ijp7ImF3YXJkaW5nQm9keSI6eyJlaWRhc0xlZ2FsSWRlbnRpZmllciI6IlVua25vd24iLCJob21lcGFnZSI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tLyIsImlkIjoiZGlkOmVic2k6emRSdnZLYlhoVlZCc1hoYXRqdWlCaHMiLCJwcmVmZXJyZWROYW1lIjoiTGVhc3RvbiBVbml2ZXJzaXR5IiwicmVnaXN0cmF0aW9uIjoiMDU5NzA2NUoifSwiZW5kZWRBdFRpbWUiOiIyMDIwLTA2LTI2VDAwOjAwOjAwWiIsImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0F3YXJkaW5nT3Bwb3J0dW5pdHkiLCJpZGVudGlmaWVyIjoiaHR0cHM6Ly9jZXJ0aWZpY2F0ZS1kZW1vLmJjZGlwbG9tYS5jb20vY2hlY2svODdFRDJGMjI3MEU2QzQxNDU2RTk0Qjg2QjlEOTExNUI0RTM1QkNDQUQyMDBBNDlCODQ2NTkyQzE0Rjc5Qzg2QlYxRm5ibGx0YTBOWlRuSmtSM2xEV2xSbVREbFNSVUpFVkZaSVNtTm1ZekpoVVU1c1pVSjVaMkZKU0hwV2JtWloiLCJsb2NhdGlvbiI6IkZSQU5DRSIsInN0YXJ0ZWRBdFRpbWUiOiIyMDE5LTA5LTAyVDAwOjAwOjAwWiJ9LCJkYXRlT2ZCaXJ0aCI6IjE5OTMtMDQtMDgiLCJmYW1pbHlOYW1lIjoiRE9FIiwiZ2l2ZW5OYW1lcyI6IkphbmUiLCJncmFkaW5nU2NoZW1lIjp7ImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0dyYWRpbmdTY2hlbWUiLCJ0aXRsZSI6IjIgeWVhciBmdWxsLXRpbWUgcHJvZ3JhbW1lIC8gNCBzZW1lc3RlcnMifSwiaWQiOiJkaWQ6ZWJzaTp6bVNLZWY2elFaREM2Nk1wcEtMSG91OXpDd2pZRTRGd2FyN05TVnkyYzdheWEiLCJpZGVudGlmaWVyIjoiMDkwNDAwODA4NEgiLCJsZWFybmluZ0FjaGlldmVtZW50Ijp7ImFkZGl0aW9uYWxOb3RlIjpbIkRJU1RSSUJVVElPTiBNQU5BR0VNRU5UIl0sImRlc2NyaXB0aW9uIjoiVGhlIE1hc3RlciBpbiBJbmZvcm1hdGlvbiBhbmQgQ29tcHV0ZXIgU2NpZW5jZXMgKE1JQ1MpIGF0IHRoZSBVbml2ZXJzaXR5IG9mIEx1eGVtYm91cmcgZW5hYmxlcyBzdHVkZW50cyB0byBhY3F1aXJlIGRlZXBlciBrbm93bGVkZ2UgaW4gY29tcHV0ZXIgc2NpZW5jZSBieSB1bmRlcnN0YW5kaW5nIGl0cyBhYnN0cmFjdCBhbmQgaW50ZXJkaXNjaXBsaW5hcnkgZm91bmRhdGlvbnMsIGZvY3VzaW5nIG9uIHByb2JsZW0gc29sdmluZyBhbmQgZGV2ZWxvcGluZyBsaWZlbG9uZyBsZWFybmluZyBza2lsbHMuIiwiaWQiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS9sYXctZWNvbm9taWNzLW1hbmFnZW1lbnQjTGVhcm5pbmdBY2hpZXZtZW50IiwidGl0bGUiOiJNYXN0ZXIgaW4gSW5mb3JtYXRpb24gYW5kIENvbXB1dGVyIFNjaWVuY2VzIn0sImxlYXJuaW5nU3BlY2lmaWNhdGlvbiI6eyJlY3RzQ3JlZGl0UG9pbnRzIjoxMjAsImVxZkxldmVsIjo3LCJpZCI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tL2xhdy1lY29ub21pY3MtbWFuYWdlbWVudCNMZWFybmluZ1NwZWNpZmljYXRpb24iLCJpc2NlZGZDb2RlIjpbIjciXSwibnFmTGV2ZWwiOlsiNyJdfX0sImV2aWRlbmNlIjp7ImRvY3VtZW50UHJlc2VuY2UiOlsiUGh5c2ljYWwiXSwiZXZpZGVuY2VEb2N1bWVudCI6WyJQYXNzcG9ydCJdLCJpZCI6Imh0dHBzOi8vZXNzaWYuZXVyb3BhLmV1L3Rzci12YS9ldmlkZW5jZS9mMmFlZWM5Ny1mYzBkLTQyYmYtOGNhNy0wNTQ4MTkyZDU2NzgiLCJzdWJqZWN0UHJlc2VuY2UiOiJQaHlzaWNhbCIsInR5cGUiOlsiRG9jdW1lbnRWZXJpZmljYXRpb24iXSwidmVyaWZpZXIiOiJkaWQ6ZWJzaToyOTYyZmI3ODRkZjYxYmFhMjY3YzgxMzI0OTc1MzlmOGM2NzRiMzdjMTI0NGE3YSJ9LCJpZCI6InVybjp1dWlkOjZiMWQ4NDExLTllZDUtNDU2Ni05YzdmLTRjMjQxNjVmZjIzNiIsImlzc3VhbmNlRGF0ZSI6IjIwMjMtMDEtMjVUMTA6MDc6MDlaIiwiaXNzdWVkIjoiMjAyMy0wMS0yNVQxMDowNzowOVoiLCJpc3N1ZXIiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiIsInByb29mIjp7ImNyZWF0ZWQiOiIyMDIyLTA0LTI3VDEyOjI1OjA3WiIsImNyZWF0b3IiOiJkaWQ6ZWJzaTp6ZFJ2dktiWGhWVkJzWGhhdGp1aUJocyIsImRvbWFpbiI6Imh0dHBzOi8vYXBpLnByZXByb2QuZWJzaS5ldSIsImp3cyI6ImV5SmlOalFpT21aaGJITmxMQ0pqY21sMElqcGJJbUkyTkNKZExDSmhiR2NpT2lKRlV6STFOa3NpZlEuLm1JQm5NOFhEUXFTWUtRTlhfTHZhSmhtc2J5Q3I1T1o1Y1UyWmstUmVxTHByNGRvRnNnbW9vYmtPNTEyOHRaeS04S2ltVmpKa0d3MHdMMXVCV25NTFdRIiwibm9uY2UiOiIzZWE2OGRhZS1kMDdhLTRkYWEtOTMyYi1mYmI1OGY1YzIwYzQiLCJ0eXBlIjoiRWNkc2FTZWNwMjU2azFTaWduYXR1cmUyMDE5In0sInR5cGUiOlsiVmVyaWZpYWJsZUNyZWRlbnRpYWwiLCJWZXJpZmlhYmxlQXR0ZXN0YXRpb24iLCJWZXJpZmlhYmxlRGlwbG9tYSJdLCJ2YWxpZEZyb20iOiIyMDIzLTAxLTI1VDEwOjA3OjA5WiJ9fQ.7DOsky5Yn0TUUEhXpPGOcbs4EAK4tRzbzcelcViE_FxfBREEvXvY7ekoxTHMMHYcB8aiOPCZwNaVFcTOfv285g';
    var jws = JsonWebSignature.fromCompactSerialization(encoded);
    var payload = jws.unverifiedPayload;
    print('toto');
  });
}
