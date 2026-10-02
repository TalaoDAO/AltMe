// to enable ebsi profile again revert commit with label:
// Remove EBSI from profile list #3504
enum ProfileType { defaultOne, diipv5, custom, enterprise }

extension ProfileTypeX on ProfileType {
  String getTitle({required String name}) {
    switch (this) {
      case ProfileType.custom:
        return 'Custom';
      case ProfileType.enterprise:
        return name.isEmpty ? 'Enterprise' : name;
      case ProfileType.diipv5:
        return 'OID4VC final 1.0';
      case ProfileType.defaultOne:
        return 'Default';
    }
  }

  String get profileId => name;

  String get getVCId {
    switch (this) {
      case ProfileType.custom:
        return 'A7G9B4C';
      case ProfileType.diipv5:
        return 'R4D8F2H';
      case ProfileType.defaultOne:
        return 'Z4C7T1X';
      case ProfileType.enterprise:
        return 'L8F6V3P';
    }
  }
}
