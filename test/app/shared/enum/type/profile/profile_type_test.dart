import 'package:altme/app/shared/enum/type/profile/profile_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileType Extension', () {
    test('Get Title', () {
      expect(ProfileType.custom.getTitle(name: ''), 'Custom');
      expect(
        ProfileType.ebsiV3.getTitle(name: ''),
        'European Blockchain Services Infrastructure (EBSI v3.x)',
      );
      expect(
        ProfileType.diipv3.getTitle(name: ''),
        'Decentralized Identity Interop Profile (DIIP v3.0)',
      );
      expect(ProfileType.defaultOne.getTitle(name: ''), 'Default');
      expect(ProfileType.enterprise.getTitle(name: ''), 'Enterprise');
      expect(ProfileType.enterprise.getTitle(name: 'Test'), 'Test');
      expect(ProfileType.europeanWallet.getTitle(name: ''),
          'Prototype for EWC pilot');
      expect(ProfileType.inji.getTitle(name: ''), 'Inji by MOSIP');
    });

    test('Get VC ID', () {
      expect(ProfileType.custom.getVCId, 'A7G9B4C');
      expect(ProfileType.ebsiV3.getVCId, 'Q2X5T8L');
      expect(ProfileType.diipv3.getVCId, 'M5K8Y2W');
      expect(ProfileType.defaultOne.getVCId, 'Z4C7T1X');
      expect(ProfileType.enterprise.getVCId, 'L8F6V3P');
      expect(ProfileType.europeanWallet.getVCId, 'M3FN2K8');
      expect(ProfileType.inji.getVCId, 'P9K4H7M');
    });

    test('Profile ID matches enum name', () {
      for (final type in ProfileType.values) {
        expect(type.profileId, type.name);
      }
    });
  });
}
