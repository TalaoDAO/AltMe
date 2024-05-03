import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('VCFormatTypeX', () {
    test('formattedString', () {
      expect(VCFormatType.ldpVc.formattedString, 'ldp_vc');
      expect(VCFormatType.jwtVc.formattedString, 'jwt_vc');
      expect(VCFormatType.jwtVcJson.formattedString, 'jwt_vc_json');
      expect(VCFormatType.jwtVcJsonLd.formattedString, 'jwt_vc_json-ld');
      expect(VCFormatType.vcSdJWT.formattedString, 'vc+sd-jwt');
    });

    test('value', () {
      expect(VCFormatType.ldpVc.value, 'ldp_vc');
      expect(VCFormatType.jwtVc.value, 'jwt_vc');
      expect(VCFormatType.jwtVcJson.value, 'jwt_vc_json');
      expect(VCFormatType.jwtVcJsonLd.value, 'jwt_vc_json-ld');
      expect(VCFormatType.vcSdJWT.value, 'vc+sd-jwt');
    });

    test('urlValue', () {
      expect(VCFormatType.ldpVc.urlValue, 'ldp_vc');
      expect(VCFormatType.jwtVc.urlValue, 'jwt_vc');
      expect(VCFormatType.jwtVcJson.urlValue, 'jwt_vc_json');
      expect(VCFormatType.jwtVcJsonLd.urlValue, 'jwt_vc_json-ld');
      expect(VCFormatType.vcSdJWT.urlValue, 'vcsd-jwt');
    });

    test('supportCryptoCredential', () {
      expect(VCFormatType.ldpVc.supportCryptoCredential, true);
      expect(VCFormatType.jwtVc.supportCryptoCredential, false);
      expect(VCFormatType.jwtVcJson.supportCryptoCredential, true);
      expect(VCFormatType.jwtVcJsonLd.supportCryptoCredential, false);
      expect(VCFormatType.vcSdJWT.supportCryptoCredential, false);
    });
  });
}
