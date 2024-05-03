import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('SIOPV2DraftTypeX', () {
    test('formattedString', () {
      expect(SIOPV2DraftType.draft12.formattedString, 'Draft 12');
    });
  });
}
