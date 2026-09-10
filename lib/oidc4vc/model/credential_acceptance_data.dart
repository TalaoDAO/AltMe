import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:equatable/equatable.dart';

/// One fetched-but-not-yet-recorded credential, shown as a selectable row
/// on the "Add credential to your wallet?" confirmation screen.
class CredentialAcceptanceItem extends Equatable {
  const CredentialAcceptanceItem({
    required this.credentialDisplayName,
    required this.claims,
    required this.credentialModel,
  });

  final String credentialDisplayName;
  final List<ClaimEntry> claims;
  final CredentialModel credentialModel;

  @override
  List<Object?> get props => [credentialDisplayName, claims, credentialModel];
}

/// Data shown on the "Add credential to your wallet?" confirmation screen,
/// carried through QRCodeScanCubit's pauseForCredentialAcceptance state
/// since the credential fetch happens outside of any widget context. The
/// issuer/trust badge is shared by every item, since they all come from the
/// same issuer. Selected items are inserted directly by the blocListener
/// once the user consents.
class CredentialAcceptanceData extends Equatable {
  const CredentialAcceptanceData({
    required this.issuerName,
    required this.isTrusted,
    required this.items,
    required this.uri,
  });

  final String issuerName;
  final bool isTrusted;
  final List<CredentialAcceptanceItem> items;
  final Uri uri;

  @override
  List<Object?> get props => [issuerName, isTrusted, items, uri];
}
