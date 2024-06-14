import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('OIDC4VPDraftTypeX', () {
    test('formattedString', () {
      expect(OIDC4VPDraftType.draft10.formattedString, 'Draft 10');
      expect(OIDC4VPDraftType.draft13.formattedString, 'Draft 13');
      expect(OIDC4VPDraftType.draft18.formattedString, 'Draft 18');
      expect(OIDC4VPDraftType.draft20.formattedString, 'Draft 20');
    });
  });
}
