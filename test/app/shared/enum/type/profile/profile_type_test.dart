import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileType Extension', () {
    test('Show Sponsered By', () {
      expect(ProfileType.custom.showSponseredBy, false);
      expect(ProfileType.ebsiV3.showSponseredBy, true);
      //expect(ProfileType.diipv2point1.showSponseredBy, false);
      expect(ProfileType.enterprise.showSponseredBy, true);
      expect(ProfileType.diipv3.showSponseredBy, true);
      expect(ProfileType.defaultOne.showSponseredBy, false);
    });
  });
}
