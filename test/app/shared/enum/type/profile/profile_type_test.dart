import 'package:altme/app/shared/enum/type/profile/profile_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileType Extension', () {
    test('Get Title', () {
      expect(ProfileType.custom.getTitle(name: ''), 'Custom');
      expect(
        ProfileType.diipv5.getTitle(name: ''),
        'Decentralized Identity Interop Profile (DIIP v5.0)',
      );
      expect(ProfileType.defaultOne.getTitle(name: ''), 'Default');
      expect(ProfileType.enterprise.getTitle(name: ''), 'Enterprise');
      expect(ProfileType.enterprise.getTitle(name: 'Test'), 'Test');
      expect(ProfileType.EUDIW.getTitle(name: ''), 'Prototype for EWC pilot');
    });

    test('Get VC ID', () {
      expect(ProfileType.custom.getVCId, 'A7G9B4C');
      expect(ProfileType.diipv5.getVCId, 'M5K8Y2W');
      expect(ProfileType.defaultOne.getVCId, 'Z4C7T1X');
      expect(ProfileType.enterprise.getVCId, 'L8F6V3P');
      expect(ProfileType.EUDIW.getVCId, 'M3FN2K8');
    });

    test('Profile ID matches enum name', () {
      for (final type in ProfileType.values) {
        expect(type.profileId, type.name);
      }
    });
  });
}
