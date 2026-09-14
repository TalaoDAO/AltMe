import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:equatable/equatable.dart';

/// One fetched-but-not-yet-recorded credential, shown as a selectable row
/// on the "Add credential to your wallet?" pick screen
/// (Oidc4vcCredentialPickPage), together with its translated claims.
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
