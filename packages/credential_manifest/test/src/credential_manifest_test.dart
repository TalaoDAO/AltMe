// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_path/json_path.dart';

void main() {
  group('CredentialManifest', () {
    test('can be instantiated', () {
      expect(
        CredentialManifest(
          'idOfCredentialManifest',
          null,
          [],
          null,
        ),
        isNotNull,
      );
    });
  });
  const expected = r'''
{
      "id": "VerifiableDiploma_1",
      "issuer": {
        "id": "did:ebsi:zhSw5rPXkcHjvquwnVcTzzB",
        "name": "Test EBSILUX"
      },
      "output_descriptors": [
        {
          "display": {
            "description": {
              "fallback": "This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.",
              "path": [],
              "schema": {
                "type": "string"
              }
            },
            "properties": [
              {
                "fallback": "Unknown",
                "label": "First name",
                "path": [
                  "$.credentialSubject.firstName"
                ],
                "schema": {
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Last name",
                "path": [
                  "$.credentialSubject.familyName"
                ],
                "schema": {
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Birth date",
                "path": [
                  "$.credentialSubject.dateOfBirth"
                ],
                "schema": {
                  "format": "date",
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Grading scheme",
                "path": [
                  "$.credentialSubject.gradingScheme.title"
                ],
                "schema": {
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Title",
                "path": [
                  "$.credentialSubject.learningAchievement.title"
                ],
                "schema": {
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Description",
                "path": [
                  "$.credentialSubject.learningAchievement.description"
                ],
                "schema": {
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "ECTS Points",
                "path": [
                  "$.credentialSubject.learningSpecification.ectsCreditPoints"
                ],
                "schema": {
                  "type": "number"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Issue date",
                "path": [
                  "$.issuanceDate"
                ],
                "schema": {
                  "format": "date",
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Issued by",
                "path": [
                  "$.credentialSubject.awardingOpportunity.awardingBody.preferredName"
                ],
                "schema": {
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Registration",
                "path": [
                  "$.credentialSubject.awardingOpportunity.awardingBody.registration"
                ],
                "schema": {
                  "type": "string"
                }
              },
              {
                "fallback": "Unknown",
                "label": "Website",
                "path": [
                  "$.credentialSubject.awardingOpportunity.awardingBody.homepage"
                ],
                "schema": {
                  "format": "uri",
                  "type": "string"
                }
              }
            ],
            "subtitle": {
              "fallback": "EBSI Verifiable diploma",
              "path": [],
              "schema": {
                "type": "string"
              }
            },
            "title": {
              "fallback": "Diploma",
              "path": [],
              "schema": {
                "type": "string"
              }
            }
          },
          "id": "diploma_01",
          "schema": "https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"
        }
      ],
      "spec_version": "https://identity.foundation/credential-manifest/spec/v1.0.0/"
    }''';
  test(
      // ignore: lines_longer_than_80_chars
      'get credential manifest from openid configuration with specific outputdescriptor',
      () {
    const String openIdConf =
        r'{"authorization_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/authorize","batch_credential_endpoint":null,"credential_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/credential","credential_issuer":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl","credential_manifests":[{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"display":{"description":{"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework.","path":[],"schema":{"type":"string"}},"properties":[{"fallback":"Unknown","label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number"}},{"fallback":"Unknown","label":"Issue date","path":["$.issuanceDate"],"schema":{"format":"date","type":"string"}},{"fallback":"Unknown","label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string"}},{"fallback":"Unknown","label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"format":"uri","type":"string"}}],"subtitle":{"fallback":"EBSI Verifiable diploma","path":[],"schema":{"type":"string"}},"title":{"fallback":"Diploma","path":[],"schema":{"type":"string"}}},"id":"diploma_01","schema":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"spec_version":"https://identity.foundation/credential-manifest/spec/v1.0.0/"}],"credential_supported":[{"cryptographic_binding_methods_supported":["did"],"cryptographic_suites_supported":["ES256K","ES256","ES384","ES512","RS256"],"display":[{"locale":"en-US","name":"Issuer Talao"}],"format":"jwt_vc","id":"VerifiableDiploma","types":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd"}],"pre-authorized_grant_anonymous_access_supported":false,"subject_syntax_types_supported":["did:ebsi"],"token_endpoint":"https://talao.co/sandbox/ebsi/issuer/vgvghylozl/token"}';
    const String schema =
        'https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd';
    final JsonPath credentialManifestPath = JsonPath(
      r'$..credential_manifests[?(@.id)]',
    );

    /// select first credential manifest
    final credentialManifestMap = credentialManifestPath
        .read(jsonDecode(openIdConf))
        .first
        .value as Map<String, dynamic>;

    /// create credentialManisfest object
    final credentialManifest = CredentialManifest.fromJson(
      credentialManifestMap,
    );

    /// select wanted output desciptor
    final JsonPath outputDescriptorPath = JsonPath(
      // ignore: prefer_interpolation_to_compose_strings
      r'$..output_descriptors[?(@.schema=="' + schema + '")]',
    );

    /// There are some possible issues with this way of filtering :-/
    final Map<String, dynamic> outputDescriptorMap = outputDescriptorPath
        .read(jsonDecode(openIdConf))
        .first
        .value as Map<String, dynamic>;
    final OutputDescriptor outputDescriptor =
        OutputDescriptor.fromJson(outputDescriptorMap);

    // ignore: unused_local_variable
    final CredentialManifest finalCredentialManifest =
        credentialManifest.copyWith(outputDescriptors: [outputDescriptor]);
    expect(
      credentialManifest.toJson(),
      CredentialManifest.fromJson(
        jsonDecode(expected) as Map<String, dynamic>,
      ).toJson(),
    );
  });
}
