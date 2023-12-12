import 'package:altme/l10n/l10n.dart';

enum ProfileType {
  custom,
  ebsiV3,
  dutch,
}

extension ProfileTypeX on ProfileType {
  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case ProfileType.custom:
        return l10n.profileCustom;
      case ProfileType.ebsiV3:
        return l10n.profileEbsiV3;
      case ProfileType.dutch:
        return l10n.profileDutchBlockchainCoalition;
    }
  }
}
