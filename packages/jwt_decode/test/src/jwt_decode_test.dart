// ignore_for_file: prefer_const_constructors
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

  const inValidJwtTokenWithLessThanThreePart = 'partOne.partTwo';
  const inValidJwtTokenWithThreePart = 'partOne.partTwo.partThree';

  setUpAll(() {
    jwtDecode = JWTDecode();
  });

  group('JwtDecode', () {
    test('can be instantiated', () {
      expect(jwtDecode, isNotNull);
    });

    test('valid jwt token', () {
      final result = jwtDecode.parseJwt(validJwtToken);
      expect(result, isNotNull);
      expect(result, isA<Map<String,dynamic>>());
    });

    test('inValid jwt token with less than three part', () {
      expect(
        () => jwtDecode.parseJwt(inValidJwtTokenWithLessThanThreePart),
        throwsA(isA<Exception>()),
      );
    });

    test('inValid jwt token with three part', () {
      expect(
        () => jwtDecode.parseJwt(inValidJwtTokenWithThreePart),
        throwsA(isA<Exception>()),
      );
    });
  });
}
