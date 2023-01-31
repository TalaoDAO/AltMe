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

import 'package:flutter_test/flutter_test.dart';
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
          // ignore: lines_longer_than_80_chars
          'jambon fromage comte camembert pain fleur voiture bac pere mere fille fils';
      final jwk = await ebsi.privateFromMnemonic(mnemonic: mnemonic);
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
// ES256K pour alg
      const expectedDid =
          'did:ebsi:znxntxQrN369GsNyjFjYb8fuvU7g3sJGyYGwMTcUGdzuy';

      final client = MockDio();
      final ebsi = Ebsi(client);
      final did = ebsi.getDidFromPrivate(jwk);
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
      final did = ebsi.getDidFromPrivate(jwk);
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
      final did = ebsi.getDidFromPrivate(jwk);
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
        'https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize',
      );
      const givenredirectUrl = 'app.altme.io/app/download/callback';
      const givenOpenIdRequest =
          'openid://initiate_issuance?issuer=https%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Fissuer%2Fvgvghylozl&credential_type=https%3A%2F%2Fapi.preprod.ebsi.eu%2Ftrusted-schemas-registry%2Fv1%2Fschemas%2F0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer_state=c8d25b7e-9bd2-11ed-9d05-0a1628958560';
      final client = MockDio();
      final ebsi = Ebsi(client);

      when(() => client.get<Map<String, dynamic>>(any())).thenAnswer((_) async {
        return Response(
          data: jsonDecode(openidConfiguration) as Map<String, dynamic>,
          requestOptions: RequestOptions(path: 'myPath'),
        );
      });
      final authorizationEndpointdUri = ebsi.getAuthorizationUriForIssuer(
        givenOpenIdRequest,
        givenredirectUrl,
      );
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
      final credentialRequest = Uri.parse(
        'https://app.altme.io/app/download?credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl?code=cb803d46-9c88-11ed-bdb3-0a1628958560&state=0d189873-9c87-11ed-8dbf-0a1628958560',
      );
      const jsonResponse =
          r'{"$schema":"http://json-schema.org/draft-07/schema#","title":"EBSI Natural Person Verifiable ID","description":"Schema of an EBSI Verifiable ID for a natural person","type":"object","allOf":[{"$ref":"https://api.conformance.intebsi.xyz/trusted-schemas-registry/v1/schemas/0x28d76954924d1c4747a4f1f9e3e9edc9ca965efbf8ff20e4339c2bf2323a5773"},{"properties":{"credentialSubject":{"description":"Defines additional information about the subject that is described by the Verifiable ID","type":"object","properties":{"id":{"description":"Defines the DID of the subject that is described by the Verifiable Attestation","type":"string","format":"uri"},"familyName":{"description":"Defines current family name(s) of the credential subject","type":"string"},"firstName":{"description":"Defines current first name(s) of the credential subject","type":"string"},"dateOfBirth":{"description":"Defines date of birth of the credential subject","type":"string","format":"date"},"personalIdentifier":{"description":"Defines the unique national identifier of the credential subject (constructed by the sending Member State in accordance with the technical specifications for the purposes of cross-border identification and which is as persistent as possible in time)","type":"string"},"nameAndFamilyNameAtBirth":{"description":"Defines the first and the family name(s) of the credential subject at the time of their birth","type":"string"},"placeOfBirth":{"description":"Defines the place where the credential subjectis born","type":"string"},"currentAddress":{"description":"Defines the current address of the credential subject","type":"string"},"gender":{"description":"Defines the gender of the credential subject","type":"string"}},"required":["id","familyName","firstName","dateOfBirth","personalIdentifier"]}}}]}';
      final client = MockDio();
      // ignore: inference_failure_on_function_invocation
      when(() => client.get(any())).thenAnswer((_) async {
        return jsonDecode(jsonResponse) as Future<Response>;
      });
      const mnemonic =
          // ignore: lines_longer_than_80_chars
          'jambon fromage comte camembert pain fleur voiture bac pere mere fille fils';

      expect(
        Ebsi(client).getCredential(
          credentialRequest,
          mnemonic,
        ),
        jsonResponse,
      );
    });
    test('When getCredentialType receive url, a request is done with Dio',
        () async {
      final credentialRequest = Uri.parse(
        'https://app.altme.io/app/download?credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl?code=cb803d46-9c88-11ed-bdb3-0a1628958560&state=0d189873-9c87-11ed-8dbf-0a1628958560',
      );
      const jsonResponse =
          r'{"$schema":"http://json-schema.org/draft-07/schema#","title":"EBSI Natural Person Verifiable ID","description":"Schema of an EBSI Verifiable ID for a natural person","type":"object","allOf":[{"$ref":"https://api.conformance.intebsi.xyz/trusted-schemas-registry/v1/schemas/0x28d76954924d1c4747a4f1f9e3e9edc9ca965efbf8ff20e4339c2bf2323a5773"},{"properties":{"credentialSubject":{"description":"Defines additional information about the subject that is described by the Verifiable ID","type":"object","properties":{"id":{"description":"Defines the DID of the subject that is described by the Verifiable Attestation","type":"string","format":"uri"},"familyName":{"description":"Defines current family name(s) of the credential subject","type":"string"},"firstName":{"description":"Defines current first name(s) of the credential subject","type":"string"},"dateOfBirth":{"description":"Defines date of birth of the credential subject","type":"string","format":"date"},"personalIdentifier":{"description":"Defines the unique national identifier of the credential subject (constructed by the sending Member State in accordance with the technical specifications for the purposes of cross-border identification and which is as persistent as possible in time)","type":"string"},"nameAndFamilyNameAtBirth":{"description":"Defines the first and the family name(s) of the credential subject at the time of their birth","type":"string"},"placeOfBirth":{"description":"Defines the place where the credential subjectis born","type":"string"},"currentAddress":{"description":"Defines the current address of the credential subject","type":"string"},"gender":{"description":"Defines the gender of the credential subject","type":"string"}},"required":["id","familyName","firstName","dateOfBirth","personalIdentifier"]}}}]}';
      final client = MockDio();
      // ignore: inference_failure_on_function_invocation
      when(() => client.get(any())).thenAnswer((_) async {
        return jsonDecode(jsonResponse) as Future<Response>;
      });
      const mnemonic =
          // ignore: lines_longer_than_80_chars
          'jambon fromage comte camembert pain fleur voiture bac pere mere fille fils';
      await Ebsi(client).getCredential(
        credentialRequest,
        mnemonic,
      );
      verify(() => client.get<String>(credentialRequest.toString())).called(1);
    });
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
