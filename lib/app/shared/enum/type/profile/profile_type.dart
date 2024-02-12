import 'package:altme/l10n/l10n.dart';

enum ProfileType { custom, ebsiV3, dutch, enterprise, owfBaselineProfile }

extension ProfileTypeX on ProfileType {
  String getTitle({
    required AppLocalizations l10n,
    required String name,
  }) {
    switch (this) {
      case ProfileType.custom:
        return l10n.profileCustom;
      case ProfileType.ebsiV3:
        return l10n.profileEbsiV3;
      case ProfileType.dutch:
        return l10n.decentralizedIdentityInteropProfile;
      case ProfileType.enterprise:
        return name.isEmpty ? 'Enterprise' : name;
      case ProfileType.owfBaselineProfile:
        return 'OWF Baseline Profile';
    }
  }

  bool get showSponseredBy {
    switch (this) {
      case ProfileType.custom:
      case ProfileType.dutch:
        return false;
      case ProfileType.ebsiV3:
      case ProfileType.enterprise:
      case ProfileType.owfBaselineProfile:
        return true;
    }
  }
}
