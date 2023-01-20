// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('EBSI DID and JWK', () {
    test('JWK from mnemonic', () async {
      final expectedJwk = {
        "kty": "EC",
        "crv": "secp256k1",
        "d": "lrKEpyoUOWRQIUOepeOpiOWI1ovobYfK9M8hYkcSnxY",
        "x": "MpE6Qo0XYS7FVM13JADFFjtfg4ehhmdpMFlzR4TsiR8",
        "y": "up-oVN_-EHHlwup51eHO7qLRS9bdN7faXug2fzTS8Uc",
        "alg": "ES256K"
      };
      final client = MockDio();
      final ebsi = Ebsi(client: client);
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
      final ebsi = Ebsi(client: client);
      final did = ebsi.getDidFromJwk(jwk);
      expect(did, expectedDid);
    });
    test('Alice DID from JWK', () async {
      // alice
      final jwk = {
        'kty': "EC",
        'd': "d_PpSCGQWWgUc1t4iLLH8bKYlYfc9Zy_M7TsfOAcbg8",
        'use': "sig",
        'crv': "P-256",
        'x': "ngy44T1vxAT6Di4nr-UaM9K3Tlnz9pkoksDokKFkmNc",
        'y': "QCRfOKlSM31GTkb4JHx3nXB4G_jSPMsbdjzlkT_UpPc",
        'alg': "ES256",
      };

// alice
      const expectedDid =
          'did:ebsi:znxntxQrN369GsNyjFjYb8fuvU7g3sJGyYGwMTcUGdzuy';

      final client = MockDio();
      final ebsi = Ebsi(client: client);
      final did = ebsi.getDidFromJwk(jwk);
      expect(did, expectedDid);
    });
    test('Bob DID from JWK', () async {
      // bob
      final jwk = {
        'kty': "EC",
        'd': "qAAbNWOBUYBcEuDYHMWE6h4O1hgsSIhMlzR2v17F-Ls",
        'use': "sig",
        'crv': "P-256",
        'x': "n1l8HzJyfmvqCprbrsDoK9sUyRK2DTWoTbOFdRT_6HE",
        'y': "DDd9ecdyVsFJGVS1f1AtItefpKKZQDt4zFJFpk9G06A",
        'alg': "ES256",
      };
// bob
      const expectedDid =
          'did:ebsi:zjg6EQC8TzGGEkrKArL1Pci6JhyQo83ZrvUrrnawXi66W';

      final client = MockDio();
      final ebsi = Ebsi(client: client);
      final did = ebsi.getDidFromJwk(jwk);
      expect(did, expectedDid);
    });
  });

  group('Ebsi request credential', () {
    test('EBSI class can be instantiated', () {
      final client = MockDio();
      expect(Ebsi(client: client), isNotNull);
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
        Ebsi(client: client).getCredentialRequest(openidRequest),
        credentialTypeRequest,
      );
    });
    test('When getCredentialRequest receive bad url it returns ""', () {
      const openidRequest = 'this is a bad request :-)';
      final client = MockDio();
      expect(Ebsi(client: client).getCredentialRequest(openidRequest), '');
    });

    test('When getCredentialType receive url it returns json response', () {
      const credentialTypeRequest =
          'https://api.conformance.intebsi.xyz/trusted-schemas-registry/v2/schemas/zCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t';
      const jsonResponse =
          r'{"$schema":"http://json-schema.org/draft-07/schema#","title":"EBSI Natural Person Verifiable ID","description":"Schema of an EBSI Verifiable ID for a natural person","type":"object","allOf":[{"$ref":"https://api.conformance.intebsi.xyz/trusted-schemas-registry/v1/schemas/0x28d76954924d1c4747a4f1f9e3e9edc9ca965efbf8ff20e4339c2bf2323a5773"},{"properties":{"credentialSubject":{"description":"Defines additional information about the subject that is described by the Verifiable ID","type":"object","properties":{"id":{"description":"Defines the DID of the subject that is described by the Verifiable Attestation","type":"string","format":"uri"},"familyName":{"description":"Defines current family name(s) of the credential subject","type":"string"},"firstName":{"description":"Defines current first name(s) of the credential subject","type":"string"},"dateOfBirth":{"description":"Defines date of birth of the credential subject","type":"string","format":"date"},"personalIdentifier":{"description":"Defines the unique national identifier of the credential subject (constructed by the sending Member State in accordance with the technical specifications for the purposes of cross-border identification and which is as persistent as possible in time)","type":"string"},"nameAndFamilyNameAtBirth":{"description":"Defines the first and the family name(s) of the credential subject at the time of their birth","type":"string"},"placeOfBirth":{"description":"Defines the place where the credential subjectis born","type":"string"},"currentAddress":{"description":"Defines the current address of the credential subject","type":"string"},"gender":{"description":"Defines the gender of the credential subject","type":"string"}},"required":["id","familyName","firstName","dateOfBirth","personalIdentifier"]}}}]}';
      final client = MockDio();
      when(() => client.get(any())).thenAnswer((_) async {
        return jsonDecode(jsonResponse) as Future<Response>;
      });
      expect(
        Ebsi(client: client).getCredentialType(credentialTypeRequest),
        jsonResponse,
      );
    });
    test('When getCredentialType receive url, a request is done with Dio',
        () async {
      const credentialTypeRequest =
          'https://api.conformance.intebsi.xyz/trusted-schemas-registry/v2/schemas/zCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t';
      const jsonResponse =
          r'{"$schema":"http://json-schema.org/draft-07/schema#","title":"EBSI Natural Person Verifiable ID","description":"Schema of an EBSI Verifiable ID for a natural person","type":"object","allOf":[{"$ref":"https://api.conformance.intebsi.xyz/trusted-schemas-registry/v1/schemas/0x28d76954924d1c4747a4f1f9e3e9edc9ca965efbf8ff20e4339c2bf2323a5773"},{"properties":{"credentialSubject":{"description":"Defines additional information about the subject that is described by the Verifiable ID","type":"object","properties":{"id":{"description":"Defines the DID of the subject that is described by the Verifiable Attestation","type":"string","format":"uri"},"familyName":{"description":"Defines current family name(s) of the credential subject","type":"string"},"firstName":{"description":"Defines current first name(s) of the credential subject","type":"string"},"dateOfBirth":{"description":"Defines date of birth of the credential subject","type":"string","format":"date"},"personalIdentifier":{"description":"Defines the unique national identifier of the credential subject (constructed by the sending Member State in accordance with the technical specifications for the purposes of cross-border identification and which is as persistent as possible in time)","type":"string"},"nameAndFamilyNameAtBirth":{"description":"Defines the first and the family name(s) of the credential subject at the time of their birth","type":"string"},"placeOfBirth":{"description":"Defines the place where the credential subjectis born","type":"string"},"currentAddress":{"description":"Defines the current address of the credential subject","type":"string"},"gender":{"description":"Defines the gender of the credential subject","type":"string"}},"required":["id","familyName","firstName","dateOfBirth","personalIdentifier"]}}}]}';
      final client = MockDio();
      when(() => client.get(any())).thenAnswer((_) async {
        return jsonDecode(jsonResponse) as Future<Response>;
      });
      await Ebsi(client: client).getCredentialType(credentialTypeRequest);
      verify(() => client.get<String>(credentialTypeRequest)).called(1);
    });
  });
}
