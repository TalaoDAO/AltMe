// to enable ebsi profile again revert commit with label: 
// Remove EBSI from profile list #3504
enum ProfileType { defaultOne, diipv5, EUDIW, custom, enterprise }

extension ProfileTypeX on ProfileType {
  String getTitle({required String name}) {
    switch (this) {
      case ProfileType.custom:
        return 'Custom';
      case ProfileType.enterprise:
        return name.isEmpty ? 'Enterprise' : name;
      case ProfileType.diipv5:
        return 'DIIP V5.0';
      case ProfileType.defaultOne:
        return 'Default';
      case ProfileType.EUDIW:
        return 'EUDI Wallet';
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
      case ProfileType.EUDIW:
        return 'M3FN2K8';
    }
  }
}
