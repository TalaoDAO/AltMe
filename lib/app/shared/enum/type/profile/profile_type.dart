enum ProfileType {
  defaultOne,
  ebsiV3,
  ebsiV4,
  //diipv2point1,
  diipv3,
  custom,
  enterprise,
}

extension ProfileTypeX on ProfileType {
  String getTitle({required String name}) {
    switch (this) {
      case ProfileType.custom:
        return 'Custom';
      case ProfileType.ebsiV3:
        return 'European Blockchain Services Infrastructure (EBSI v3.x)';
      case ProfileType.ebsiV4:
        return 'European Blockchain Services Infrastructure (EBSI v4.0)';
      case ProfileType.enterprise:
        return name.isEmpty ? 'Enterprise' : name;
      // case ProfileType.diipv2point1:
      //   return 'Decentralized Identity Interop Profile (DIIP v2.1)';
      case ProfileType.diipv3:
        return 'Decentralized Identity Interop Profile (DIIP v3.0)';
      case ProfileType.defaultOne:
        return 'Default';
    }
  }

  String get profileId => name;

  bool get showSponseredBy {
    switch (this) {
      case ProfileType.custom:
      case ProfileType.defaultOne:
        // case ProfileType.diipv2point1:
        return false;
      case ProfileType.ebsiV3:
      case ProfileType.ebsiV4:
      case ProfileType.enterprise:
      case ProfileType.diipv3:
        return true;
    }
  }

  String get getVCId {
    switch (this) {
      case ProfileType.custom:
        return 'A7G9B4C';
      case ProfileType.ebsiV3:
        return 'Q2X5T8L';
      case ProfileType.ebsiV4:
        return 'J9R3N6P';
      case ProfileType.diipv3:
        return 'M5K8Y2W';
      case ProfileType.defaultOne:
        return 'Z4C7T1X';
      case ProfileType.enterprise:
        return 'L8F6V3P';
    }
  }
}
