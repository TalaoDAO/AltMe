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
  const wellKnownContent =
      r'{"credential_endpoint":"https://issuer.talao.co/credential","credential_manifest":{"id":"Identity_cards","issuer":{"id":"uuid:0001","name":"Altme issuer"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof of your majority. You can use it when you need to prove your majority with services that have already adopted the verifiable and decentralized identity system. ","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"Verified by","path":["$.credentialSubject.issuedBy.name"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Issuer DID","path":["$.issuer"],"schema":{"type":"string"}},{"fallback":"Altme","label":"KYC provider","path":["$.credentialSubject.kycProvider"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"KYC ID","path":["$.credentialSubject.kycId"],"schema":{"type":"string"}}]},"id":"Over18","schema":"https://github.com/TalaoDAO/context/blob/main/jsonSchema/over18_json_schema.json"},{"display":{"description":{"fallback":"This card is a proof of your are over 13 yo. You can use it when you need to prove your majority with services that have already adopted the verifiable and decentralized identity system. ","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"Verified by","path":["$.credentialSubject.issuedBy.name"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Issuer DID","path":["$.issuer"],"schema":{"type":"string"}},{"fallback":"Altme","label":"KYC provider","path":["$.credentialSubject.kycProvider"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"KYC ID","path":["$.credentialSubject.kycId"],"schema":{"type":"string"}}],"subtitle":{"fallback":"Provided by Altme","path":[],"schema":{"type":"string"}},"title":{"fallback":"Over 13","path":[],"schema":{"type":"string"}}},"id":"Over13","schema":"https://github.com/TalaoDAO/context/blob/main/jsonSchema/over13_json_schema.json"},{"display":{"description":{"fallback":"This card is a proof of your age. You can use it when you need to prove your age without disclosing your identity with services that have already adopted the decentralized identity system.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"","label":"Age range","path":["$.credentialSubject.ageRange"],"schema":{"type":"string"}},{"fallback":"","label":"Expires","path":["$.expirationDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Altme","label":"Verified by","path":[],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Issuer DID","path":["$.issuer"],"schema":{"type":"string"}},{"fallback":"Altme","label":"KYC provider","path":["$.credentialSubject.kycProvider"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"KYC ID","path":["$.credentialSubject.kycId"],"schema":{"type":"string"}}],"subtitle":{"fallback":"Age range","path":[],"schema":{"type":"string"}},"title":{"fallback":"Unverified","path":["$.credentialSubject.ageRange"],"schema":{"type":"string"}}},"id":"AgeRange","schema":"https://github.com/TalaoDAO/wallet-tools/blob/main/test/CredentialOffer2/AgeRange.jsonld","styles":{"background":{"color":"#baaaad"},"text":{"color":"#ffffff"}}},{"display":{"description":{"fallback":"This card is a proof of your identity. You can use it when you need to prove your identity with services that have already adopted the verifiable and decentralized identity system (futur standard).","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"","label":"First name","path":["$.credentialSubject.givenName"],"schema":{"type":"string"}},{"fallback":"","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"","label":"Gender","path":["$.credentialSubject.gender"],"schema":{"type":"string"}},{"fallback":"","label":"Birth date","path":["$.credentialSubject.birthDate"],"schema":{"format":"date","type":"string"}},{"fallback":"","label":"Birth place","path":["$.credentialSubject.birthPlace"],"schema":{"type":"string"}},{"fallback":"","label":"Expiration date","path":["$.credentialSubject.expiryDate"],"schema":{"format":"date","type":"string"}},{"fallback":"","label":"Authority","path":["$.credentialSubject.authority"],"schema":{"type":"string"}},{"fallback":"","label":"Issue date","path":["$.credentialSubject.issueDate"],"schema":{"format":"date","type":"string"}},{"fallback":"","label":"Nationality","path":["$.credentialSubject.nationality"],"schema":{"type":"string"}},{"fallback":"Altme","label":"Verified by","path":[],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Issuer DID","path":["$.issuer"],"schema":{"type":"string"}},{"fallback":"Altme","label":"KYC provider","path":["$.credentialSubject.kycProvider"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"KYC ID","path":["$.credentialSubject.kycId"],"schema":{"type":"string"}}],"subtitle":{"fallback":"Your decentralized identity document","path":[],"schema":{"type":"string"}},"title":{"fallback":"Identity Card","path":[],"schema":{"type":"string"}}},"id":"IdCard","schema":"https://github.com/TalaoDAO/wallet-tools/blob/main/test/CredentialOffer2/IdCard.jsonld","styles":{"background":{"color":"#baaaad"},"text":{"color":"#ffffff"}}},{"display":{"description":{"fallback":"This card is a proof of your identity for your LinkedIn profile. From this card, you can export a QR code and display it in the banner on your LinkedIn account. By scanning the QR code with his Talao wallet, anyone will be able to verify that your identity matches the URL of your LinkedIn profile, and will also be able to access 2 additional information: your nationality and your year of birth.\nExpiration date :  This card will remain active and reusable for 1 YEAR. \nHow to get it: You can claim this card by following Talao\u2019s KYC check. \nOnly information related to your first name, last name, nationality and year of birth will be accessible from your LinkedIn profile.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"","label":"First name","path":["$.credentialSubject.givenName"],"schema":{"type":"string"}},{"fallback":"","label":"Family name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"","label":"Year of birth","path":["$.credentialSubject.yearOfBirth"],"schema":{"type":"string"}},{"fallback":"","label":"Nationality","path":["$.credentialSubject.nationality"],"schema":{"type":"string"}},{"fallback":"","label":"Expiration date","path":["$.expirationDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"","label":"Evidence document","path":["$.evidence[0].evidenceDocument"],"schema":{"type":"string"}},{"fallback":"Altme","label":"Verified by","path":[],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Issuer DID","path":["$.issuer"],"schema":{"type":"string"}}],"subtitle":{"fallback":"For testing purpose","path":[],"schema":{"type":"string"}},"title":{"fallback":"LinkedIn Card","path":[],"schema":{"type":"string"}}},"id":"LinkedininCard","schema":"https://github.com/TalaoDAO/wallet-tools/blob/main/test/CredentialOffer2/VerifiableId.jsonld","styles":{"background":{"color":"#4181f1"},"text":{"color":"#ffffff"}}},{"display":{"description":{"fallback":"This card is a proof of liveness. You can use it when you need to prove your are human with services that have already adopted the verifiable and decentralized identity system. ","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"Verified by","path":["$.credentialSubject.issuedBy.name"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Expires","path":["$.expirationDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Altme","label":"KYC provider","path":["$.credentialSubject.kycProvider"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"KYC ID","path":["$.credentialSubject.kycId"],"schema":{"type":"string"}}]},"id":"Liveness","schema":"https://github.com/TalaoDAO/wallet-tools/blob/main/test/CredentialOffer2/Liveness.jsonld"},{"display":{"description":{"fallback":"This card is a proof of your gender. You can use it when you need to prove your gender without disclosing your identity with services that have already adopted the decentralized identity system.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"","label":"Gender","path":["$.credentialSubject.gender"],"schema":{"type":"string"}},{"fallback":"","label":"Expires","path":["$.expirationDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Altme","label":"Verified by","path":[],"schema":{"type":"string"}},{"fallback":"Altme","label":"KYC provider","path":["$.credentialSubject.kycProvider"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"KYC ID","path":["$.credentialSubject.kycId"],"schema":{"type":"string"}}],"subtitle":{"fallback":"Your decentralized identity document","path":[],"schema":{"type":"string"}},"title":{"fallback":"Gender Card","path":[],"schema":{"type":"string"}}},"id":"Gender","schema":"https://github.com/TalaoDAO/wallet-tools/blob/main/test/CredentialOffer2/Gender.jsonld","styles":{"background":{"color":"#baaaad"},"text":{"color":"#ffffff"}}},{"display":{"description":{"fallback":"This card is a proof of ownership of your email. You can use it when you need to prove your email ownership with services that have already adopted the verifiable and decentralized identity system.  ","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"Email address","path":["$.credentialSubject.email"],"schema":{"format":"email","type":"string"}},{"fallback":"Not stated","label":"Email verified","path":["$.credentialSubject.emailVerified"],"schema":{"type":"bool"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.issuedBy.name"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Issuer DID","path":["$.issuer"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Expiration date","path":["$.expirationDate"],"schema":{"format":"date","type":"string"}}]},"id":"EmailPass","schema":"https://github.com/TalaoDAO/context/blob/main/jsonSchema/emailpass_json_schema.json"},{"display":{"description":{"fallback":"This card is a proof of your nationality. You can use it when you need to prove your nationality without disclosing your identity with services that have already adopted the decentralized identity system.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"","label":"Country of nationality","path":["$.credentialSubject.nationality"],"schema":{"type":"string"}},{"fallback":"","label":"Expires","path":["$.expirationDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Altme","label":"Verified by","path":[],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Issuer DID","path":["$.issuer"],"schema":{"type":"string"}},{"fallback":"Altme","label":"KYC provider","path":["$.credentialSubject.kycProvider"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"KYC ID","path":["$.credentialSubject.kycId"],"schema":{"type":"string"}}],"subtitle":{"fallback":"Your decentralized identity document","path":[],"schema":{"type":"string"}},"title":{"fallback":"Nationality Card","path":[],"schema":{"type":"string"}}},"id":"Nationality","schema":"https://github.com/TalaoDAO/wallet-tools/blob/main/test/CredentialOffer2/Nationality.jsonld","styles":{"background":{"color":"#baaaad"},"text":{"color":"#ffffff"}}},{"display":{"description":{"fallback":"This credential carries your Passport MRZ hash (SHA256). You can use it when you need to prove your identity uniqueness without disclosing your personal data. ","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"Verified by","path":["$.credentialSubject.issuedBy.name"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Passport MRZ hash","path":["$.credentialSubject.passportNumber"],"schema":{"type":"string"}},{"fallback":"Altme","label":"KYC provider","path":["$.credentialSubject.kycProvider"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"KYC ID","path":["$.credentialSubject.kycId"],"schema":{"type":"string"}}],"subtitle":{"fallback":"Provided by Altme","path":[],"schema":{"type":"string"}},"title":{"fallback":"Passport footprint","path":[],"schema":{"type":"string"}}},"id":"PassportNumber","schema":"https://github.com/TalaoDAO/wallet-tools/blob/main/test/CredentialOffer2/PassportNumber.jsonld"},{"display":{"description":{"fallback":"This card is a proof of your identity. You can use it when you need to prove your identity with services that have already adopted the verifiable and decentralized identity system (EBSI standard).","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"","label":"Family name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"","label":"Gender","path":["$.credentialSubject.gender"],"schema":{"type":"string"}},{"fallback":"","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"","label":"Birth place","path":["$.credentialSubject.placeOfBirth"],"schema":{"type":"string"}},{"fallback":"","label":"Personal Identifier","path":["$.credentialSubject.personalIdentifier"],"schema":{"type":"string"}},{"fallback":"","label":"Expiration date","path":["$.expirationDate"],"schema":{"format":"date","type":"string"}},{"fallback":"","label":"Issue date","path":["$.issued"],"schema":{"format":"date","type":"string"}},{"fallback":"","label":"Evidence document","path":["$.evidence[0].evidenceDocument"],"schema":{"type":"string"}},{"fallback":"Altme","label":"Verified by","path":[],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Issuer DID","path":["$.issuer"],"schema":{"type":"string"}}],"subtitle":{"fallback":"EBSI","path":[],"schema":{"type":"string"}},"title":{"fallback":"Verifiable Id","path":[],"schema":{"type":"string"}}},"id":"VerifiableId_1","schema":"https://api-conformance.ebsi.eu/trusted-schemas-registry/v2/schemas/z22ZAMdQtNLwi51T2vdZXGGZaYyjrsuP1yzWyXZirCAHv","styles":{"background":{"color":"#baaaad"},"text":{"color":"#ffffff"}}}]},"issuer":"https://issuer.talao.co/","token_endpoint":"https://issuer.talao.co/token","token_endpoint_auth_methods_supported":["client_secret_basic"]}';
  const initialQrCodeUrl = 'https://talao.co/sandbox/ebsi/issuer/vgvghylozl';
  const QRCodeContent =
      'openid://initiate_issuance?issuer=https://talao.co/sandbox/ebsi/issuer/vgvghylozl&credential_type=https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd&op_stat=46cc5d84-9b29-11ed-ae36-0a1628958560';
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
        Ebsi(client: client).getCredential(credentialTypeRequest),
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
      await Ebsi(client: client).getCredential(credentialTypeRequest);
      verify(() => client.get<String>(credentialTypeRequest)).called(1);
    });
  });
}
