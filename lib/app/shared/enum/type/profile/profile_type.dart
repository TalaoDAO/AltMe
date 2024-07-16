enum ProfileType {
  defaultOne,
  ebsiV3,
  dutch,
  owfBaselineProfile,
  custom,
  enterprise,
}

extension ProfileTypeX on ProfileType {
  String getTitle({required String name}) {
    switch (this) {
      case ProfileType.custom:
        return 'Custom';
      case ProfileType.ebsiV3:
        return 'European Blockchain Services Infrastructure';
      case ProfileType.dutch:
        return 'Decentralized Identity Interop Profile (DIIP v2.1)';
      case ProfileType.enterprise:
        return name.isEmpty ? 'Enterprise' : name;
      case ProfileType.owfBaselineProfile:
        return 'OWF Baseline Profile';
      case ProfileType.defaultOne:
        return 'Default';
    }
  }

  bool get showSponseredBy {
    switch (this) {
      case ProfileType.custom:
      case ProfileType.defaultOne:
      case ProfileType.dutch:
        return false;
      case ProfileType.ebsiV3:
      case ProfileType.enterprise:
      case ProfileType.owfBaselineProfile:
        return true;
    }
  }
}
