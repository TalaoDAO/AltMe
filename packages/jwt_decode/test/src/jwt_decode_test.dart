import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';

void main() {
  late final JWTDecode jwtDecode;

  const validJwtToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImRpZDp3ZWI6dGFsYW8uY28ja2'
      'V5LTIifQ.eyJzY29wZSI6Im9wZW5pZCIsInJlc3BvbnNlX3R5cGUiOiJpZF90b2tlbiIsI'
      'mNsaWVudF9pZCI6ImRpZDp3ZWI6dGFsYW8uY28iLCJyZWRpcmVjdF91cmkiOiJodHRwczo'
      'vL3RhbGFvLmNvL2dhaWF4L2xvZ2luX3JlZGlyZWN0Lzc3MTVlODZmLWI0YTktMTFlYy1hM'
      'jhlLTBhMTYyODk1ODU2MCIsInJlc3BvbnNlX21vZGUiOiJwb3N0IiwiY2xhaW1zIjoie1w'
      'iaWRfdG9rZW5cIjp7fSxcInZwX3Rva2VuXCI6e1wicHJlc2VudGF0aW9uX2RlZmluaXRpb'
      '25cIjp7XCJpZFwiOlwicGFzc19mb3JfZ2FpYXhcIixcImlucHV0X2Rlc2NyaXB0b3JzXCI'
      '6W3tcImlkXCI6XCJQYXJ0aWNpcGFudENyZWRlbnRpYWwgaXNzdWVkIGJ5IFRhbGFvXCIsX'
      'CJwdXJwb3NlXCI6XCJUZXN0IGZvciBHYWlhLVggaGFja2F0aG9uXCIsXCJjb25zdHJhaW5'
      '0c1wiOntcImxpbWl0X2Rpc2Nsb3N1cmVcIjpcInJlcXVpcmVkXCIsXCJmaWVsZHNcIjpbe'
      '1wicGF0aFwiOltcIiQuY3JlZGVudGlhbFN1YmplY3QudHlwZVwiXSxcInB1cnBvc2VcIjp'
      'cIk9uZSBjYW4gb25seSBhY2NlcHQgUGFydGljaXBhbnRDcmVkZW50aWFsXCIsXCJmaWx0Z'
      'XJcIjp7XCJ0eXBlXCI6XCJzdHJpbmdcIixcInBhdHRlcm5cIjpcIlBhcnRpY2lwYW50Q3J'
      'lZGVudGlhbFwifX0se1wicGF0aFwiOltcIiQuaXNzdWVyXCJdLFwicHVycG9zZVwiOlwiT'
      '25lIGNhbiBhY2NlcHQgb25seSBQYXJ0aWNpcGFudENyZWRlbnRpYWwgc2lnbmVkIGJ5IFR'
      'hbGFvXCIsXCJmaWx0ZXJcIjp7XCJ0eXBlXCI6XCJzdHJpbmdcIixcInBhdHRlcm5cIjpcI'
      'mRpZDp3ZWI6dGFsYW8uY29cIn19XX19XX19fSIsIm5vbmNlIjoiV1A1RDFnUXpVUSIsInJ'
      'lcXVlc3RfdXJpIjoiaHR0cHM6Ly90YWxhby5jby9nYWlheC9sb2dpbl9yZXF1ZXN0X3Vya'
      'S83NzE1ZTg2Zi1iNGE5LTExZWMtYTI4ZS0wYTE2Mjg5NTg1NjAifQ.MZGFgaNp-Ux5ev4h'
      '4u3BTXZRWPIhdXpFiC1xkKKuGgfHmWKf9nPDG3N7DOdBrcIBR_NXJN3frNz5xnlrf7GVkB'
      'JJk43Pa5syZtpZnzW7Gu6Q0KrxrgxogcZEiWtwrWXggUabEZiCKtqJ-rfwW8UgEulDkree'
      'J-yeJGev_iSAO6qIRqK6GTQCMhwnfxhnrQpBOgDzHc_YTpadGEz3Z-Ey0BDTEr0GN62zRE'
      'wDBTOHX1DEC83Os26IT-6VGZpWPjCpOOk5p4EzO1zz09zgR962cNEnlgx62GhJi5ATfnCk'
      'VvqgKjEw171KNfotzlAp84Gqw0m5Ef0KzmLKSzD9pssFZA';

  const validJwtTokenOne =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImRpZDp3ZWI6dGFsYW8uY28ja2V5'
      'LTIifQ.eyJzY29wZSI6Im9wZW5pZCIsInJlc3BvbnNlX3R5cGUiOiJpZF90b2tlbiIsImNsa'
      'WVudF9pZCI6ImRpZDp3ZWI6dGFsYW8uY28iLCJyZWRpcmVjdF91cmkiOiJodHRwczovL3Rhb'
      'GFvLmNvL2dhaWF4L2xvZ2luX3JlZGlyZWN0LzI4N2Y1OGU5LWE1MGMtMTFlYy1iZWEwLTBhM'
      'TYyODk1ODU2MCIsInJlc3BvbnNlX21vZGUiOiJwb3N0IiwiY2xhaW1zIjoie1wiaWRfdG9rZ'
      'W5cIjp7fSxcInZwX3Rva2VuXCI6e1wicHJlc2VudGF0aW9uX2RlZmluaXRpb25cIjp7XCJpZ'
      'FwiOlwicGFzc19mb3JfZ2FpYXhcIixcImlucHV0X2Rlc2NyaXB0b3JzXCI6W3tcImlkXCI6X'
      'CJHYWlheFBhc3MgaXNzdWVkIGJ5IFRhbGFvXCIsXCJwdXJwb3NlXCI6XCJUZXN0IGZvciBHY'
      'WlhLVggaGFja2F0aG9uXCIsXCJmb3JtYXRcIjp7XCJsZHBfdmNcIjp7XCJwcm9vZl90eXBlX'
      'CI6W1wiSnNvbldlYlNpZ25hdHVyZTIwMjBcIl19fSxcImNvbnN0cmFpbnRzXCI6e1wibGlta'
      'XRfZGlzY2xvc3VyZVwiOlwicmVxdWlyZWRcIixcImZpZWxkc1wiOlt7XCJwYXRoXCI6W1wiJ'
      'C5jcmVkZW50aWFsU3ViamVjdC50eXBlXCJdLFwicHVycG9zZVwiOlwiT25lIGNhbiBvbmx5I'
      'GFjY2VwdCBHYWlheFBhc3NcIixcImZpbHRlclwiOntcInR5cGVcIjpcInN0cmluZ1wiLFwic'
      'GF0dGVyblwiOlwiR2FpYXhQYXNzXCJ9fSx7XCJwYXRoXCI6W1wiJC5pc3N1ZXJcIl0sXCJwd'
      'XJwb3NlXCI6XCJPbmUgY2FuIGFjY2VwdCBvbmx5IEdhaWF4UGFzcyBzaWduZWQgYnkgVGFsY'
      'W9cIixcImZpbHRlclwiOntcInR5cGVcIjpcInN0cmluZ1wiLFwicGF0dGVyblwiOlwiZGlkO'
      'ndlYjp0YWxhby5jb1wifX1dfX1dfX19Iiwibm9uY2UiOiI2ajBSQVRaZUlqIiwicmVnaXN0c'
      'mF0aW9uIjoie1wiaWRfdG9rZW5fc2lnbmluZ19hbGdfdmFsdWVzX3N1cHBvcnRlZFwiOltcI'
      'lJTMjU2XCIsXCJFUzI1NlwiLFwiRVMyNTZLXCIsXCJFZERTQVwiXSxcInN1YmplY3Rfc3lud'
      'GF4X3R5cGVzX3N1cHBvcnRlZFwiOltcImRpZDp3ZWJcIixcImRpZDp0elwiLFwiZGlkOmtle'
      'VwiLFwiZGlkOmlvblwiLFwiZGlkOnBraFwiLFwiZGlkOmV0aHJcIl19IiwicmVxdWVzdF91c'
      'mkiOiJodHRwczovL3RhbGFvLmNvL2dhaWF4L2xvZ2luX3JlcXVlc3RfdXJpLzI4N2Y1OGU5L'
      'WE1MGMtMTFlYy1iZWEwLTBhMTYyODk1ODU2MCJ9.XU17UUTA1CZU6vHtV5nOxVYb9J6lI2jj'
      '9GDn8aoRiOhFjvEbylg_ycCHBSZmR6aoAXTVv9bQxBvvg6z0UmxEeo29slVLzSFVvmysY5nL'
      '3zw5I0A-IBnpHxMkt44GNIZTJEnrkne7bdOSYhxETt4cE42ZXAA61MJIu--iFJ53E_CnhKym'
      'wn7yCoddt9RRVIiOYKEegBMTXsOO5HnQDcxv39vpuHxmAuOd1seZB8zZs7cTtqcKRjU_YnuB'
      'CZwF0xGHCe6Su5zgfXKivvaTYrXK0Bgl3y614vN3_qSXFeJ-CoLyy0AJkIYxvxD7PKMHswRr'
      'Y-NVqJ6_YmUo3uDIr9BmSw';

  const validJwtTokenWithInvalidPayload =
      '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.W3siSGVsbG8iOjEyfV0.vfPVZG-CndvivC2JaWA4leWl_1F3pm1lr-l3BISqVAc''';
  const jsonStringOfValidTokenOne =
      r'''{scope: openid, response_type: id_token, client_id: did:web:altme.co, redirect_uri: https://altme.co/gaiax/login_redirect/287f58e9-a50c-11ec-bea0-0a1628958560, response_mode: post, claims: {"id_token":{},"vp_token":{"presentation_definition":{"id":"pass_for_gaiax","input_descriptors":[{"id":"GaiaxPass issued by altme","purpose":"Test for Gaia-X hackathon","format":{"ldp_vc":{"proof_type":["JsonWebSignature2020"]}},"constraints":{"limit_disclosure":"required","fields":[{"path":["$.credentialSubject.type"],"purpose":"One can only accept GaiaxPass","filter":{"type":"string","pattern":"GaiaxPass"}},{"path":["$.issuer"],"purpose":"One can accept only GaiaxPass signed by altme","filter":{"type":"string","pattern":"did:web:altme.co"}}]}}]}}}, nonce: 6j0RATZeIj, registration: {"id_token_signing_alg_values_supported":["RS256","ES256","ES256K","EdDSA"],"subject_syntax_types_supported":["did:web","did:tz","did:key","did:ion","did:pkh","did:ethr"]}, request_uri: https://altme.co/gaiax/login_request_uri/287f58e9-a50c-11ec-bea0-0a1628958560}''';

  const inValidJwtTokenWithLessThanThreePart = 'partOne.partTwo';
  const inValidJwtTokenWithThreePart = 'partOne.partTwo.partThree';

  setUpAll(() {
    jwtDecode = JWTDecode();
  });

  group('JwtDecode', () {
    test('can be instantiated', () {
      expect(jwtDecode, isNotNull);
    });

    test('valid jwt token results some data', () {
      final result = jwtDecode.parseJwt(validJwtToken);
      expect(result, isNotNull);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('valid jwt token results string correctly', () {
      final result = jwtDecode.parseJwt(validJwtTokenOne);
      expect(result, isNotNull);
      expect(result.toString(), equals(jsonStringOfValidTokenOne));
    });

    test('inValid jwt token with less than three part throws exception', () {
      expect(
        () => jwtDecode.parseJwt(inValidJwtTokenWithLessThanThreePart),
        throwsA(
          isA<Exception>().having(
            (p0) => p0.toString(),
            'toString()',
            'Exception: Invalid Token',
          ),
        ),
      );
    });

    test('inValid jwt token with three part throws exception', () {
      expect(
        () => jwtDecode.parseJwt(inValidJwtTokenWithThreePart),
        throwsA(
          isA<FormatException>(),
        ),
      );
    });

    test('valid jwt token with invalid payload', () {
      expect(
        () => jwtDecode.parseJwt(validJwtTokenWithInvalidPayload),
        throwsA(
          isA<Exception>().having(
            (p0) => p0.toString(),
            'toString()',
            'Exception: Invalid Payload',
          ),
        ),
      );
    });
  });
}
