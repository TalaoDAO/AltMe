// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:ebsi/ebsi.dart';
import 'package:flutter_test/flutter_test.dart';

import 'verifier_token_parameters_class.dart';

void main() {
  group('Verifier TokenParameters', () {
    const url =
        'openid://?scope=openid&response_type=id_token&client_id=xjcqarovuv&redirect_uri=https%3A%2F%2Ftalao.co%2Fsandbox%2Febsi%2Flogin%2Fendpoint%2F69164da8-a851-11ed-8418-0a1628958560&claims=%7B%27id_token%27%3A+%7B%27email%27%3A+None%7D%2C+%27vp_token%27%3A+%7B%27presentation_definition%27%3A+%7B%27id%27%3A+%2769166a42-a851-11ed-aa45-0a1628958560%27%2C+%27input_descriptors%27%3A+%5B%7B%27id%27%3A+%2769166b29-a851-11ed-ac22-0a1628958560%27%2C+%27name%27%3A+%27Input+descriptor+1%27%2C+%27purpose%27%3A+%27+%27%2C+%27constraints%27%3A+%7B%27fields%27%3A+%5B%7B%27path%27%3A+%5B%27%24.vc.credentialSchema.id%27%5D%2C+%27filter%27%3A+%7B%27type%27%3A+%27string%27%2C+%27pattern%27%3A+%27https%3A%2F%2Fapi.preprod.ebsi.eu%2Ftrusted-schemas-registry%2Fv1%2Fschemas%2F0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd%27%7D%7D%5D%7D%7D%5D%2C+%27format%27%3A+%7B%27jwt_vp%27%3A+%7B%27alg%27%3A+%5B%27ES256K%27%2C+%27ES256%27%2C+%27PS256%27%2C+%27RS256%27%5D%7D%7D%7D%7D%7D&nonce=69165b47-a851-11ed-bd52-0a1628958560';

    const privateKey = {
      'crv': 'P-256K',
      'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
      'kty': 'EC',
      'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
      'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
    };

    final uri = Uri.parse(url);

    const credentialsToBePresented = [
      r'{"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","receivedId":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","image":null,"data":{"@context":["https://www.w3.org/2018/credentials/v1"],"credentialSchema":{"id":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd","type":"JsonSchemaValidator2018"},"credentialStatus":{"id":"https://essif.europa.eu/status/education#higherEducation#392ac7f6-399a-437b-a268-4691ead8f176","type":"CredentialStatusList2020"},"credentialSubject":{"awardingOpportunity":{"awardingBody":{"eidasLegalIdentifier":"Unknown","homepage":"https://leaston.bcdiploma.com/","id":"did:ebsi:zdRvvKbXhVVBsXhatjuiBhs","preferredName":"Leaston University","registration":"0597065J"},"endedAtTime":"2020-06-26T00:00:00Z","id":"https://leaston.bcdiploma.com/law-economics-management#AwardingOpportunity","identifier":"https://certificate-demo.bcdiploma.com/check/87ED2F2270E6C41456E94B86B9D9115B4E35BCCAD200A49B846592C14F79C86BV1Fnbllta0NZTnJkR3lDWlRmTDlSRUJEVFZISmNmYzJhUU5sZUJ5Z2FJSHpWbmZZ","location":"FRANCE","startedAtTime":"2019-09-02T00:00:00Z"},"dateOfBirth":"1993-04-08","familyName":"DOE","givenNames":"Jane","gradingScheme":{"id":"https://leaston.bcdiploma.com/law-economics-management#GradingScheme","title":"2 year full-time programme / 4 semesters"},"id":"did:ebsi:zoxRGVZQndTfQk54B7tKdwwNdhai5gm9F8Nav8eceNABa","identifier":"0904008084H","learningAchievement":{"additionalNote":["DISTRIBUTION MANAGEMENT"],"description":"The Master in Information and Computer Sciences (MICS) at the University of Luxembourg enables students to acquire deeper knowledge in computer science by understanding its abstract and interdisciplinary foundations, focusing on problem solving and developing lifelong learning skills.","id":"https://leaston.bcdiploma.com/law-economics-management#LearningAchievment","title":"Master in Information and Computer Sciences"},"learningSpecification":{"ectsCreditPoints":120,"eqfLevel":7,"id":"https://leaston.bcdiploma.com/law-economics-management#LearningSpecification","iscedfCode":["7"],"nqfLevel":["7"]}},"evidence":{"documentPresence":["Physical"],"evidenceDocument":["Passport"],"id":"https://essif.europa.eu/tsr-va/evidence/f2aeec97-fc0d-42bf-8ca7-0548192d5678","subjectPresence":"Physical","type":["DocumentVerification"],"verifier":"did:ebsi:2962fb784df61baa267c8132497539f8c674b37c1244a7a"},"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","issuanceDate":"2023-02-08T15:10:56Z","issued":"2023-02-08T15:10:56Z","issuer":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","proof":{"created":"2022-04-27T12:25:07Z","creator":"did:ebsi:zdRvvKbXhVVBsXhatjuiBhs","domain":"https://api.preprod.ebsi.eu","jws":"eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFUzI1NksifQ..mIBnM8XDQqSYKQNX_LvaJhmsbyCr5OZ5cU2Zk-ReqLpr4doFsgmoobkO5128tZy-8KimVjJkGw0wL1uBWnMLWQ","nonce":"3ea68dae-d07a-4daa-932b-fbb58f5c20c4","type":"EcdsaSecp256k1Signature2019"},"type":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"],"validFrom":"2023-02-08T15:10:56Z"},"shareLink":"","credentialPreview":{"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","type":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"],"issuer":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","description":[],"name":[],"issuanceDate":"2023-02-08T15:10:56Z","proof":[{"type":"EcdsaSecp256k1Signature2019","proofPurpose":null,"verificationMethod":null,"created":"2022-04-27T12:25:07Z","jws":"eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFUzI1NksifQ..mIBnM8XDQqSYKQNX_LvaJhmsbyCr5OZ5cU2Zk-ReqLpr4doFsgmoobkO5128tZy-8KimVjJkGw0wL1uBWnMLWQ"}],"credentialSubject":{"id":"did:ebsi:zoxRGVZQndTfQk54B7tKdwwNdhai5gm9F8Nav8eceNABa","type":null,"issuedBy":{"name":""}},"evidence":[{"id":"https://essif.europa.eu/tsr-va/evidence/f2aeec97-fc0d-42bf-8ca7-0548192d5678","type":["DocumentVerification"]}],"credentialStatus":{"id":"https://essif.europa.eu/status/education#higherEducation#392ac7f6-399a-437b-a268-4691ead8f176","type":"CredentialStatusList2020","revocationListIndex":"","revocationListCredential":""}},"display":{"backgroundColor":"","icon":"","nameFallback":"","descriptionFallback":""},"expirationDate":null,"credential_manifest":{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"id":"diploma_01","schema":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd","name":null,"description":null,"styles":null,"display":{"title":{"path":[],"schema":{"type":"string","format":null},"fallback":"Diploma"},"subtitle":{"path":[],"schema":{"type":"string","format":null},"fallback":"EBSI Verifiable diploma"},"description":{"path":[],"schema":{"type":"string","format":null},"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework."},"properties":[{"label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"type":"string","format":"date"},"fallback":"Unknown"},{"label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number","format":null},"fallback":"Unknown"},{"label":"Issue date","path":["$.issuanceDate"],"schema":{"type":"string","format":"date"},"fallback":"Unknown"},{"label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"type":"string","format":"uri"},"fallback":"Unknown"}]}}],"presentation_definition":null},"challenge":null,"domain":null,"activities":[{"acquisitionAt":"2023-02-08T20:41:02.024360","presentation":null}],"jwt":"eyJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiM1MTVhOWM0MzZjMGYyYWQzYWI2NWQ2Y2VmYzVjMWYwNmMwNWI4YWRmY2Y1NGVlMDZkYzgwNTQzMjA0NzBmZmFmIiwidHlwIjoiSldUIn0.eyJleHAiOjE2NzU4NzAwNTYuMTcxMDgyLCJpYXQiOjE2NzU4NjkwNTYuMTcxMDc1LCJpc3MiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiIsImp0aSI6InVybjp1dWlkOjZiMWQ4NDExLTllZDUtNDU2Ni05YzdmLTRjMjQxNjVmZjIzNiIsIm5iZiI6MTY3NTg2OTA1Ni4xNzEwOCwibm9uY2UiOiJjOGM3Nzg0Yi1hN2MyLTExZWQtOGUwMS0wYTE2Mjg5NTg1NjAiLCJzdWIiOiJkaWQ6ZWJzaTp6b3hSR1ZaUW5kVGZRazU0Qjd0S2R3d05kaGFpNWdtOUY4TmF2OGVjZU5BQmEiLCJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9hcGkucHJlcHJvZC5lYnNpLmV1L3RydXN0ZWQtc2NoZW1hcy1yZWdpc3RyeS92MS9zY2hlbWFzLzB4YmY3OGZjMDhhN2E5ZjI4ZjU0NzlmNThkZWEyNjlkMzY1N2Y1NGYxM2NhMzdkMzgwY2Q0ZTkyMjM3ZmI2OTFkZCIsInR5cGUiOiJKc29uU2NoZW1hVmFsaWRhdG9yMjAxOCJ9LCJjcmVkZW50aWFsU3RhdHVzIjp7ImlkIjoiaHR0cHM6Ly9lc3NpZi5ldXJvcGEuZXUvc3RhdHVzL2VkdWNhdGlvbiNoaWdoZXJFZHVjYXRpb24jMzkyYWM3ZjYtMzk5YS00MzdiLWEyNjgtNDY5MWVhZDhmMTc2IiwidHlwZSI6IkNyZWRlbnRpYWxTdGF0dXNMaXN0MjAyMCJ9LCJjcmVkZW50aWFsU3ViamVjdCI6eyJhd2FyZGluZ09wcG9ydHVuaXR5Ijp7ImF3YXJkaW5nQm9keSI6eyJlaWRhc0xlZ2FsSWRlbnRpZmllciI6IlVua25vd24iLCJob21lcGFnZSI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tLyIsImlkIjoiZGlkOmVic2k6emRSdnZLYlhoVlZCc1hoYXRqdWlCaHMiLCJwcmVmZXJyZWROYW1lIjoiTGVhc3RvbiBVbml2ZXJzaXR5IiwicmVnaXN0cmF0aW9uIjoiMDU5NzA2NUoifSwiZW5kZWRBdFRpbWUiOiIyMDIwLTA2LTI2VDAwOjAwOjAwWiIsImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0F3YXJkaW5nT3Bwb3J0dW5pdHkiLCJpZGVudGlmaWVyIjoiaHR0cHM6Ly9jZXJ0aWZpY2F0ZS1kZW1vLmJjZGlwbG9tYS5jb20vY2hlY2svODdFRDJGMjI3MEU2QzQxNDU2RTk0Qjg2QjlEOTExNUI0RTM1QkNDQUQyMDBBNDlCODQ2NTkyQzE0Rjc5Qzg2QlYxRm5ibGx0YTBOWlRuSmtSM2xEV2xSbVREbFNSVUpFVkZaSVNtTm1ZekpoVVU1c1pVSjVaMkZKU0hwV2JtWloiLCJsb2NhdGlvbiI6IkZSQU5DRSIsInN0YXJ0ZWRBdFRpbWUiOiIyMDE5LTA5LTAyVDAwOjAwOjAwWiJ9LCJkYXRlT2ZCaXJ0aCI6IjE5OTMtMDQtMDgiLCJmYW1pbHlOYW1lIjoiRE9FIiwiZ2l2ZW5OYW1lcyI6IkphbmUiLCJncmFkaW5nU2NoZW1lIjp7ImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0dyYWRpbmdTY2hlbWUiLCJ0aXRsZSI6IjIgeWVhciBmdWxsLXRpbWUgcHJvZ3JhbW1lIC8gNCBzZW1lc3RlcnMifSwiaWQiOiJkaWQ6ZWJzaTp6b3hSR1ZaUW5kVGZRazU0Qjd0S2R3d05kaGFpNWdtOUY4TmF2OGVjZU5BQmEiLCJpZGVudGlmaWVyIjoiMDkwNDAwODA4NEgiLCJsZWFybmluZ0FjaGlldmVtZW50Ijp7ImFkZGl0aW9uYWxOb3RlIjpbIkRJU1RSSUJVVElPTiBNQU5BR0VNRU5UIl0sImRlc2NyaXB0aW9uIjoiVGhlIE1hc3RlciBpbiBJbmZvcm1hdGlvbiBhbmQgQ29tcHV0ZXIgU2NpZW5jZXMgKE1JQ1MpIGF0IHRoZSBVbml2ZXJzaXR5IG9mIEx1eGVtYm91cmcgZW5hYmxlcyBzdHVkZW50cyB0byBhY3F1aXJlIGRlZXBlciBrbm93bGVkZ2UgaW4gY29tcHV0ZXIgc2NpZW5jZSBieSB1bmRlcnN0YW5kaW5nIGl0cyBhYnN0cmFjdCBhbmQgaW50ZXJkaXNjaXBsaW5hcnkgZm91bmRhdGlvbnMsIGZvY3VzaW5nIG9uIHByb2JsZW0gc29sdmluZyBhbmQgZGV2ZWxvcGluZyBsaWZlbG9uZyBsZWFybmluZyBza2lsbHMuIiwiaWQiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS9sYXctZWNvbm9taWNzLW1hbmFnZW1lbnQjTGVhcm5pbmdBY2hpZXZtZW50IiwidGl0bGUiOiJNYXN0ZXIgaW4gSW5mb3JtYXRpb24gYW5kIENvbXB1dGVyIFNjaWVuY2VzIn0sImxlYXJuaW5nU3BlY2lmaWNhdGlvbiI6eyJlY3RzQ3JlZGl0UG9pbnRzIjoxMjAsImVxZkxldmVsIjo3LCJpZCI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tL2xhdy1lY29ub21pY3MtbWFuYWdlbWVudCNMZWFybmluZ1NwZWNpZmljYXRpb24iLCJpc2NlZGZDb2RlIjpbIjciXSwibnFmTGV2ZWwiOlsiNyJdfX0sImV2aWRlbmNlIjp7ImRvY3VtZW50UHJlc2VuY2UiOlsiUGh5c2ljYWwiXSwiZXZpZGVuY2VEb2N1bWVudCI6WyJQYXNzcG9ydCJdLCJpZCI6Imh0dHBzOi8vZXNzaWYuZXVyb3BhLmV1L3Rzci12YS9ldmlkZW5jZS9mMmFlZWM5Ny1mYzBkLTQyYmYtOGNhNy0wNTQ4MTkyZDU2NzgiLCJzdWJqZWN0UHJlc2VuY2UiOiJQaHlzaWNhbCIsInR5cGUiOlsiRG9jdW1lbnRWZXJpZmljYXRpb24iXSwidmVyaWZpZXIiOiJkaWQ6ZWJzaToyOTYyZmI3ODRkZjYxYmFhMjY3YzgxMzI0OTc1MzlmOGM2NzRiMzdjMTI0NGE3YSJ9LCJpZCI6InVybjp1dWlkOjZiMWQ4NDExLTllZDUtNDU2Ni05YzdmLTRjMjQxNjVmZjIzNiIsImlzc3VhbmNlRGF0ZSI6IjIwMjMtMDItMDhUMTU6MTA6NTZaIiwiaXNzdWVkIjoiMjAyMy0wMi0wOFQxNToxMDo1NloiLCJpc3N1ZXIiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiIsInByb29mIjp7ImNyZWF0ZWQiOiIyMDIyLTA0LTI3VDEyOjI1OjA3WiIsImNyZWF0b3IiOiJkaWQ6ZWJzaTp6ZFJ2dktiWGhWVkJzWGhhdGp1aUJocyIsImRvbWFpbiI6Imh0dHBzOi8vYXBpLnByZXByb2QuZWJzaS5ldSIsImp3cyI6ImV5SmlOalFpT21aaGJITmxMQ0pqY21sMElqcGJJbUkyTkNKZExDSmhiR2NpT2lKRlV6STFOa3NpZlEuLm1JQm5NOFhEUXFTWUtRTlhfTHZhSmhtc2J5Q3I1T1o1Y1UyWmstUmVxTHByNGRvRnNnbW9vYmtPNTEyOHRaeS04S2ltVmpKa0d3MHdMMXVCV25NTFdRIiwibm9uY2UiOiIzZWE2OGRhZS1kMDdhLTRkYWEtOTMyYi1mYmI1OGY1YzIwYzQiLCJ0eXBlIjoiRWNkc2FTZWNwMjU2azFTaWduYXR1cmUyMDE5In0sInR5cGUiOlsiVmVyaWZpYWJsZUNyZWRlbnRpYWwiLCJWZXJpZmlhYmxlQXR0ZXN0YXRpb24iLCJWZXJpZmlhYmxlRGlwbG9tYSJdLCJ2YWxpZEZyb20iOiIyMDIzLTAyLTA4VDE1OjEwOjU2WiJ9fQ.avhpj0UC7SJiOo8PWJV3zhJoxngdmrBnyTkQsnqe76JlOmatLkgAY5Mp_sUJQnN1uENiT-_KBf0KY3izx4X_SA"}',
      r'{"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","receivedId":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","image":null,"data":{"@context":["https://www.w3.org/2018/credentials/v1"],"credentialSchema":{"id":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd","type":"JsonSchemaValidator2018"},"credentialStatus":{"id":"https://essif.europa.eu/status/education#higherEducation#392ac7f6-399a-437b-a268-4691ead8f176","type":"CredentialStatusList2020"},"credentialSubject":{"awardingOpportunity":{"awardingBody":{"eidasLegalIdentifier":"Unknown","homepage":"https://leaston.bcdiploma.com/","id":"did:ebsi:zdRvvKbXhVVBsXhatjuiBhs","preferredName":"Leaston University","registration":"0597065J"},"endedAtTime":"2020-06-26T00:00:00Z","id":"https://leaston.bcdiploma.com/law-economics-management#AwardingOpportunity","identifier":"https://certificate-demo.bcdiploma.com/check/87ED2F2270E6C41456E94B86B9D9115B4E35BCCAD200A49B846592C14F79C86BV1Fnbllta0NZTnJkR3lDWlRmTDlSRUJEVFZISmNmYzJhUU5sZUJ5Z2FJSHpWbmZZ","location":"FRANCE","startedAtTime":"2019-09-02T00:00:00Z"},"dateOfBirth":"1993-04-08","familyName":"DOE","givenNames":"Jane","gradingScheme":{"id":"https://leaston.bcdiploma.com/law-economics-management#GradingScheme","title":"2 year full-time programme / 4 semesters"},"id":"did:ebsi:zoxRGVZQndTfQk54B7tKdwwNdhai5gm9F8Nav8eceNABa","identifier":"0904008084H","learningAchievement":{"additionalNote":["DISTRIBUTION MANAGEMENT"],"description":"The Master in Information and Computer Sciences (MICS) at the University of Luxembourg enables students to acquire deeper knowledge in computer science by understanding its abstract and interdisciplinary foundations, focusing on problem solving and developing lifelong learning skills.","id":"https://leaston.bcdiploma.com/law-economics-management#LearningAchievment","title":"Master in Information and Computer Sciences"},"learningSpecification":{"ectsCreditPoints":120,"eqfLevel":7,"id":"https://leaston.bcdiploma.com/law-economics-management#LearningSpecification","iscedfCode":["7"],"nqfLevel":["7"]}},"evidence":{"documentPresence":["Physical"],"evidenceDocument":["Passport"],"id":"https://essif.europa.eu/tsr-va/evidence/f2aeec97-fc0d-42bf-8ca7-0548192d5678","subjectPresence":"Physical","type":["DocumentVerification"],"verifier":"did:ebsi:2962fb784df61baa267c8132497539f8c674b37c1244a7a"},"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","issuanceDate":"2023-02-08T15:10:56Z","issued":"2023-02-08T15:10:56Z","issuer":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","proof":{"created":"2022-04-27T12:25:07Z","creator":"did:ebsi:zdRvvKbXhVVBsXhatjuiBhs","domain":"https://api.preprod.ebsi.eu","jws":"eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFUzI1NksifQ..mIBnM8XDQqSYKQNX_LvaJhmsbyCr5OZ5cU2Zk-ReqLpr4doFsgmoobkO5128tZy-8KimVjJkGw0wL1uBWnMLWQ","nonce":"3ea68dae-d07a-4daa-932b-fbb58f5c20c4","type":"EcdsaSecp256k1Signature2019"},"type":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"],"validFrom":"2023-02-08T15:10:56Z"},"shareLink":"","credentialPreview":{"id":"urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236","type":["VerifiableCredential","VerifiableAttestation","VerifiableDiploma"],"issuer":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","description":[],"name":[],"issuanceDate":"2023-02-08T15:10:56Z","proof":[{"type":"EcdsaSecp256k1Signature2019","proofPurpose":null,"verificationMethod":null,"created":"2022-04-27T12:25:07Z","jws":"eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFUzI1NksifQ..mIBnM8XDQqSYKQNX_LvaJhmsbyCr5OZ5cU2Zk-ReqLpr4doFsgmoobkO5128tZy-8KimVjJkGw0wL1uBWnMLWQ"}],"credentialSubject":{"id":"did:ebsi:zoxRGVZQndTfQk54B7tKdwwNdhai5gm9F8Nav8eceNABa","type":null,"issuedBy":{"name":""}},"evidence":[{"id":"https://essif.europa.eu/tsr-va/evidence/f2aeec97-fc0d-42bf-8ca7-0548192d5678","type":["DocumentVerification"]}],"credentialStatus":{"id":"https://essif.europa.eu/status/education#higherEducation#392ac7f6-399a-437b-a268-4691ead8f176","type":"CredentialStatusList2020","revocationListIndex":"","revocationListCredential":""}},"display":{"backgroundColor":"","icon":"","nameFallback":"","descriptionFallback":""},"expirationDate":null,"credential_manifest":{"id":"VerifiableDiploma_1","issuer":{"id":"did:ebsi:zhSw5rPXkcHjvquwnVcTzzB","name":"Test EBSILUX"},"output_descriptors":[{"id":"diploma_01","schema":"https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd","name":null,"description":null,"styles":null,"display":{"title":{"path":[],"schema":{"type":"string","format":null},"fallback":"Diploma"},"subtitle":{"path":[],"schema":{"type":"string","format":null},"fallback":"EBSI Verifiable diploma"},"description":{"path":[],"schema":{"type":"string","format":null},"fallback":"This card is a proof that you passed this diploma successfully. You can use this card  when you need to prove this information to services that have adopted EU EBSI framework."},"properties":[{"label":"First name","path":["$.credentialSubject.firstName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Last name","path":["$.credentialSubject.familyName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Birth date","path":["$.credentialSubject.dateOfBirth"],"schema":{"type":"string","format":"date"},"fallback":"Unknown"},{"label":"Grading scheme","path":["$.credentialSubject.gradingScheme.title"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Title","path":["$.credentialSubject.learningAchievement.title"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Description","path":["$.credentialSubject.learningAchievement.description"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"ECTS Points","path":["$.credentialSubject.learningSpecification.ectsCreditPoints"],"schema":{"type":"number","format":null},"fallback":"Unknown"},{"label":"Issue date","path":["$.issuanceDate"],"schema":{"type":"string","format":"date"},"fallback":"Unknown"},{"label":"Issued by","path":["$.credentialSubject.awardingOpportunity.awardingBody.preferredName"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Registration","path":["$.credentialSubject.awardingOpportunity.awardingBody.registration"],"schema":{"type":"string","format":null},"fallback":"Unknown"},{"label":"Website","path":["$.credentialSubject.awardingOpportunity.awardingBody.homepage"],"schema":{"type":"string","format":"uri"},"fallback":"Unknown"}]}}],"presentation_definition":null},"challenge":null,"domain":null,"activities":[{"acquisitionAt":"2023-02-08T20:41:02.024360","presentation":null}]}'
    ];

    final verifierTokenParameters =
        VerifierTokenParameters(privateKey, uri, credentialsToBePresented);

    const nonce = '69165b47-a851-11ed-bd52-0a1628958560';

    const audience = 'xjcqarovuv';

    const jwtsOfCredentials = [
      // ignore: lines_longer_than_80_chars
      'eyJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiM1MTVhOWM0MzZjMGYyYWQzYWI2NWQ2Y2VmYzVjMWYwNmMwNWI4YWRmY2Y1NGVlMDZkYzgwNTQzMjA0NzBmZmFmIiwidHlwIjoiSldUIn0.eyJleHAiOjE2NzU4NzAwNTYuMTcxMDgyLCJpYXQiOjE2NzU4NjkwNTYuMTcxMDc1LCJpc3MiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiIsImp0aSI6InVybjp1dWlkOjZiMWQ4NDExLTllZDUtNDU2Ni05YzdmLTRjMjQxNjVmZjIzNiIsIm5iZiI6MTY3NTg2OTA1Ni4xNzEwOCwibm9uY2UiOiJjOGM3Nzg0Yi1hN2MyLTExZWQtOGUwMS0wYTE2Mjg5NTg1NjAiLCJzdWIiOiJkaWQ6ZWJzaTp6b3hSR1ZaUW5kVGZRazU0Qjd0S2R3d05kaGFpNWdtOUY4TmF2OGVjZU5BQmEiLCJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9hcGkucHJlcHJvZC5lYnNpLmV1L3RydXN0ZWQtc2NoZW1hcy1yZWdpc3RyeS92MS9zY2hlbWFzLzB4YmY3OGZjMDhhN2E5ZjI4ZjU0NzlmNThkZWEyNjlkMzY1N2Y1NGYxM2NhMzdkMzgwY2Q0ZTkyMjM3ZmI2OTFkZCIsInR5cGUiOiJKc29uU2NoZW1hVmFsaWRhdG9yMjAxOCJ9LCJjcmVkZW50aWFsU3RhdHVzIjp7ImlkIjoiaHR0cHM6Ly9lc3NpZi5ldXJvcGEuZXUvc3RhdHVzL2VkdWNhdGlvbiNoaWdoZXJFZHVjYXRpb24jMzkyYWM3ZjYtMzk5YS00MzdiLWEyNjgtNDY5MWVhZDhmMTc2IiwidHlwZSI6IkNyZWRlbnRpYWxTdGF0dXNMaXN0MjAyMCJ9LCJjcmVkZW50aWFsU3ViamVjdCI6eyJhd2FyZGluZ09wcG9ydHVuaXR5Ijp7ImF3YXJkaW5nQm9keSI6eyJlaWRhc0xlZ2FsSWRlbnRpZmllciI6IlVua25vd24iLCJob21lcGFnZSI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tLyIsImlkIjoiZGlkOmVic2k6emRSdnZLYlhoVlZCc1hoYXRqdWlCaHMiLCJwcmVmZXJyZWROYW1lIjoiTGVhc3RvbiBVbml2ZXJzaXR5IiwicmVnaXN0cmF0aW9uIjoiMDU5NzA2NUoifSwiZW5kZWRBdFRpbWUiOiIyMDIwLTA2LTI2VDAwOjAwOjAwWiIsImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0F3YXJkaW5nT3Bwb3J0dW5pdHkiLCJpZGVudGlmaWVyIjoiaHR0cHM6Ly9jZXJ0aWZpY2F0ZS1kZW1vLmJjZGlwbG9tYS5jb20vY2hlY2svODdFRDJGMjI3MEU2QzQxNDU2RTk0Qjg2QjlEOTExNUI0RTM1QkNDQUQyMDBBNDlCODQ2NTkyQzE0Rjc5Qzg2QlYxRm5ibGx0YTBOWlRuSmtSM2xEV2xSbVREbFNSVUpFVkZaSVNtTm1ZekpoVVU1c1pVSjVaMkZKU0hwV2JtWloiLCJsb2NhdGlvbiI6IkZSQU5DRSIsInN0YXJ0ZWRBdFRpbWUiOiIyMDE5LTA5LTAyVDAwOjAwOjAwWiJ9LCJkYXRlT2ZCaXJ0aCI6IjE5OTMtMDQtMDgiLCJmYW1pbHlOYW1lIjoiRE9FIiwiZ2l2ZW5OYW1lcyI6IkphbmUiLCJncmFkaW5nU2NoZW1lIjp7ImlkIjoiaHR0cHM6Ly9sZWFzdG9uLmJjZGlwbG9tYS5jb20vbGF3LWVjb25vbWljcy1tYW5hZ2VtZW50I0dyYWRpbmdTY2hlbWUiLCJ0aXRsZSI6IjIgeWVhciBmdWxsLXRpbWUgcHJvZ3JhbW1lIC8gNCBzZW1lc3RlcnMifSwiaWQiOiJkaWQ6ZWJzaTp6b3hSR1ZaUW5kVGZRazU0Qjd0S2R3d05kaGFpNWdtOUY4TmF2OGVjZU5BQmEiLCJpZGVudGlmaWVyIjoiMDkwNDAwODA4NEgiLCJsZWFybmluZ0FjaGlldmVtZW50Ijp7ImFkZGl0aW9uYWxOb3RlIjpbIkRJU1RSSUJVVElPTiBNQU5BR0VNRU5UIl0sImRlc2NyaXB0aW9uIjoiVGhlIE1hc3RlciBpbiBJbmZvcm1hdGlvbiBhbmQgQ29tcHV0ZXIgU2NpZW5jZXMgKE1JQ1MpIGF0IHRoZSBVbml2ZXJzaXR5IG9mIEx1eGVtYm91cmcgZW5hYmxlcyBzdHVkZW50cyB0byBhY3F1aXJlIGRlZXBlciBrbm93bGVkZ2UgaW4gY29tcHV0ZXIgc2NpZW5jZSBieSB1bmRlcnN0YW5kaW5nIGl0cyBhYnN0cmFjdCBhbmQgaW50ZXJkaXNjaXBsaW5hcnkgZm91bmRhdGlvbnMsIGZvY3VzaW5nIG9uIHByb2JsZW0gc29sdmluZyBhbmQgZGV2ZWxvcGluZyBsaWZlbG9uZyBsZWFybmluZyBza2lsbHMuIiwiaWQiOiJodHRwczovL2xlYXN0b24uYmNkaXBsb21hLmNvbS9sYXctZWNvbm9taWNzLW1hbmFnZW1lbnQjTGVhcm5pbmdBY2hpZXZtZW50IiwidGl0bGUiOiJNYXN0ZXIgaW4gSW5mb3JtYXRpb24gYW5kIENvbXB1dGVyIFNjaWVuY2VzIn0sImxlYXJuaW5nU3BlY2lmaWNhdGlvbiI6eyJlY3RzQ3JlZGl0UG9pbnRzIjoxMjAsImVxZkxldmVsIjo3LCJpZCI6Imh0dHBzOi8vbGVhc3Rvbi5iY2RpcGxvbWEuY29tL2xhdy1lY29ub21pY3MtbWFuYWdlbWVudCNMZWFybmluZ1NwZWNpZmljYXRpb24iLCJpc2NlZGZDb2RlIjpbIjciXSwibnFmTGV2ZWwiOlsiNyJdfX0sImV2aWRlbmNlIjp7ImRvY3VtZW50UHJlc2VuY2UiOlsiUGh5c2ljYWwiXSwiZXZpZGVuY2VEb2N1bWVudCI6WyJQYXNzcG9ydCJdLCJpZCI6Imh0dHBzOi8vZXNzaWYuZXVyb3BhLmV1L3Rzci12YS9ldmlkZW5jZS9mMmFlZWM5Ny1mYzBkLTQyYmYtOGNhNy0wNTQ4MTkyZDU2NzgiLCJzdWJqZWN0UHJlc2VuY2UiOiJQaHlzaWNhbCIsInR5cGUiOlsiRG9jdW1lbnRWZXJpZmljYXRpb24iXSwidmVyaWZpZXIiOiJkaWQ6ZWJzaToyOTYyZmI3ODRkZjYxYmFhMjY3YzgxMzI0OTc1MzlmOGM2NzRiMzdjMTI0NGE3YSJ9LCJpZCI6InVybjp1dWlkOjZiMWQ4NDExLTllZDUtNDU2Ni05YzdmLTRjMjQxNjVmZjIzNiIsImlzc3VhbmNlRGF0ZSI6IjIwMjMtMDItMDhUMTU6MTA6NTZaIiwiaXNzdWVkIjoiMjAyMy0wMi0wOFQxNToxMDo1NloiLCJpc3N1ZXIiOiJkaWQ6ZWJzaTp6aFN3NXJQWGtjSGp2cXV3blZjVHp6QiIsInByb29mIjp7ImNyZWF0ZWQiOiIyMDIyLTA0LTI3VDEyOjI1OjA3WiIsImNyZWF0b3IiOiJkaWQ6ZWJzaTp6ZFJ2dktiWGhWVkJzWGhhdGp1aUJocyIsImRvbWFpbiI6Imh0dHBzOi8vYXBpLnByZXByb2QuZWJzaS5ldSIsImp3cyI6ImV5SmlOalFpT21aaGJITmxMQ0pqY21sMElqcGJJbUkyTkNKZExDSmhiR2NpT2lKRlV6STFOa3NpZlEuLm1JQm5NOFhEUXFTWUtRTlhfTHZhSmhtc2J5Q3I1T1o1Y1UyWmstUmVxTHByNGRvRnNnbW9vYmtPNTEyOHRaeS04S2ltVmpKa0d3MHdMMXVCV25NTFdRIiwibm9uY2UiOiIzZWE2OGRhZS1kMDdhLTRkYWEtOTMyYi1mYmI1OGY1YzIwYzQiLCJ0eXBlIjoiRWNkc2FTZWNwMjU2azFTaWduYXR1cmUyMDE5In0sInR5cGUiOlsiVmVyaWZpYWJsZUNyZWRlbnRpYWwiLCJWZXJpZmlhYmxlQXR0ZXN0YXRpb24iLCJWZXJpZmlhYmxlRGlwbG9tYSJdLCJ2YWxpZEZyb20iOiIyMDIzLTAyLTA4VDE1OjEwOjU2WiJ9fQ.avhpj0UC7SJiOo8PWJV3zhJoxngdmrBnyTkQsnqe76JlOmatLkgAY5Mp_sUJQnN1uENiT-_KBf0KY3izx4X_SA',

      {
        '@context': ['https://www.w3.org/2018/credentials/v1'],
        'credentialSchema': {
          'id':
              'https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd',
          'type': 'JsonSchemaValidator2018'
        },
        'credentialStatus': {
          'id':
              'https://essif.europa.eu/status/education#higherEducation#392ac7f6-399a-437b-a268-4691ead8f176',
          'type': 'CredentialStatusList2020'
        },
        'credentialSubject': {
          'awardingOpportunity': {
            'awardingBody': {
              'eidasLegalIdentifier': 'Unknown',
              'homepage': 'https://leaston.bcdiploma.com/',
              'id': 'did:ebsi:zdRvvKbXhVVBsXhatjuiBhs',
              'preferredName': 'Leaston University',
              'registration': '0597065J'
            },
            'endedAtTime': '2020-06-26T00:00:00Z',
            'id':
                'https://leaston.bcdiploma.com/law-economics-management#AwardingOpportunity',
            'identifier':
                'https://certificate-demo.bcdiploma.com/check/87ED2F2270E6C41456E94B86B9D9115B4E35BCCAD200A49B846592C14F79C86BV1Fnbllta0NZTnJkR3lDWlRmTDlSRUJEVFZISmNmYzJhUU5sZUJ5Z2FJSHpWbmZZ',
            'location': 'FRANCE',
            'startedAtTime': '2019-09-02T00:00:00Z'
          },
          'dateOfBirth': '1993-04-08',
          'familyName': 'DOE',
          'givenNames': 'Jane',
          'gradingScheme': {
            'id':
                'https://leaston.bcdiploma.com/law-economics-management#GradingScheme',
            'title': '2 year full-time programme / 4 semesters'
          },
          'id': 'did:ebsi:zoxRGVZQndTfQk54B7tKdwwNdhai5gm9F8Nav8eceNABa',
          'identifier': '0904008084H',
          'learningAchievement': {
            'additionalNote': ['DISTRIBUTION MANAGEMENT'],
            'description':
                'The Master in Information and Computer Sciences (MICS) at the University of Luxembourg enables students to acquire deeper knowledge in computer science by understanding its abstract and interdisciplinary foundations, focusing on problem solving and developing lifelong learning skills.', // ignore: lines_longer_than_80_chars
            'id':
                'https://leaston.bcdiploma.com/law-economics-management#LearningAchievment',
            'title': 'Master in Information and Computer Sciences'
          },
          'learningSpecification': {
            'ectsCreditPoints': 120,
            'eqfLevel': 7,
            'id':
                'https://leaston.bcdiploma.com/law-economics-management#LearningSpecification',
            'iscedfCode': ['7'],
            'nqfLevel': ['7']
          }
        },
        'evidence': {
          'documentPresence': ['Physical'],
          'evidenceDocument': ['Passport'],
          'id':
              'https://essif.europa.eu/tsr-va/evidence/f2aeec97-fc0d-42bf-8ca7-0548192d5678',
          'subjectPresence': 'Physical',
          'type': ['DocumentVerification'],
          'verifier': 'did:ebsi:2962fb784df61baa267c8132497539f8c674b37c1244a7a'
        },
        'id': 'urn:uuid:6b1d8411-9ed5-4566-9c7f-4c24165ff236',
        'issuanceDate': '2023-02-08T15:10:56Z',
        'issued': '2023-02-08T15:10:56Z',
        'issuer': 'did:ebsi:zhSw5rPXkcHjvquwnVcTzzB',
        'proof': {
          'created': '2022-04-27T12:25:07Z',
          'creator': 'did:ebsi:zdRvvKbXhVVBsXhatjuiBhs',
          'domain': 'https://api.preprod.ebsi.eu',
          'jws':
              'eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFUzI1NksifQ..mIBnM8XDQqSYKQNX_LvaJhmsbyCr5OZ5cU2Zk-ReqLpr4doFsgmoobkO5128tZy-8KimVjJkGw0wL1uBWnMLWQ', // ignore: lines_longer_than_80_chars
          'nonce': '3ea68dae-d07a-4daa-932b-fbb58f5c20c4',
          'type': 'EcdsaSecp256k1Signature2019'
        },
        'type': [
          'VerifiableCredential',
          'VerifiableAttestation',
          'VerifiableDiploma'
        ],
        'validFrom': '2023-02-08T15:10:56Z'
      }
    ];

    test('nonce', () {
      expect(verifierTokenParameters.nonce, nonce);
    });

    test('jwtsOfCredentials', () {
      expect(verifierTokenParameters.jsonIdOrJwtList, jwtsOfCredentials);
    });

    test('audience', () {
      expect(verifierTokenParameters.audience, audience);
    });

    group('override test', () {
      final verifierTokenParametersTest = VerifierTokenParametersTest();

      test(
        'public key is P-256K private key without d parameter',
        verifierTokenParametersTest.publicKeyTest,
      );

      test('did EBSI', verifierTokenParametersTest.didTest);

      test('kID EBSI', verifierTokenParametersTest.keyIdTest);

      group('algorithm test', () {
        test(
          "algorithm is ES256K when key's curve is not P-256",
          verifierTokenParametersTest.algorithmIsES256KTest,
        );

        test(
          "algorithm is ES256 when key's curve is P-256",
          verifierTokenParametersTest.algorithmIsES256Test,
        );

        test(
          'if alg is not null then return as it is',
          verifierTokenParametersTest.algorithmIsNotNullTest,
        );
      });

      group('thumbprint test', () {
        test(
          'thumbprint of the public Key',
          verifierTokenParametersTest.thumprintOfKey,
        );

        test(
          'thumbrprint of the Key from exemple in rfc 7638',
          verifierTokenParametersTest.thumprintOfKeyForrfc7638,
        );
      });
    });
  });
}
