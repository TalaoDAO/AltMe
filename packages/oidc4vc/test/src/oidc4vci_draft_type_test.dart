import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('OIDC4VCIDraftTypeX', () {
    test('formattedString', () {
      expect(OIDC4VCIDraftType.draft11.formattedString, 'Draft 11');
      expect(OIDC4VCIDraftType.draft13.formattedString, 'Draft 13');
    });

    test('numbering', () {
      expect(OIDC4VCIDraftType.draft11.numbering, '11');
      expect(OIDC4VCIDraftType.draft13.numbering, '13');
    });
  });
}
