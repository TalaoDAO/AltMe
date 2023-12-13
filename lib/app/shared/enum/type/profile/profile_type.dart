import 'package:altme/l10n/l10n.dart';

enum ProfileType {
  custom,
  ebsiV3,
  dutch,
  enterprise,
}

extension ProfileTypeX on ProfileType {
  String getTitle({
    required AppLocalizations l10n,
    String? name,
  }) {
    switch (this) {
      case ProfileType.custom:
        return l10n.profileCustom;
      case ProfileType.ebsiV3:
        return l10n.profileEbsiV3;
      case ProfileType.dutch:
        return l10n.profileDutchBlockchainCoalition;
      case ProfileType.enterprise:
        return name ?? 'Enterprise';
    }
  }
}
