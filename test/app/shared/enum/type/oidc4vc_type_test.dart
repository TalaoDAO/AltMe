import 'package:oidc4vc/oidc4vc.dart';
import 'package:test/test.dart';

void main() {
  group('OIDC4VCType Extension Tests', () {
    test('OIDC4VCType isEnabled returns correct value', () {
      expect(OIDC4VCType.DEFAULT.isEnabled, equals(true));
      expect(OIDC4VCType.GAIAX.isEnabled, equals(true));
      expect(OIDC4VCType.GREENCYPHER.isEnabled, equals(true));
      expect(OIDC4VCType.EBSI.isEnabled, equals(true));
      expect(OIDC4VCType.JWTVC.isEnabled, equals(false));
      expect(OIDC4VCType.HAIP.isEnabled, equals(true));
    });
  });
}
