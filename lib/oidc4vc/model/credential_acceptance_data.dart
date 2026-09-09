import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:equatable/equatable.dart';

/// Data shown on the "Add credential to your wallet?" confirmation screen,
/// carried through QRCodeScanCubit's pauseForCredentialAcceptance state
/// since the credential fetch happens outside of any widget context. Also
/// carries what's needed to insert the credential once the user consents,
/// since that now happens directly in the blocListener.
class CredentialAcceptanceData extends Equatable {
  const CredentialAcceptanceData({
    required this.credentialDisplayName,
    required this.issuerName,
    required this.isTrusted,
    required this.claims,
    required this.credentialModel,
    required this.showMessage,
    required this.uri,
  });

  final String credentialDisplayName;
  final String issuerName;
  final bool isTrusted;
  final List<ClaimEntry> claims;
  final CredentialModel credentialModel;
  final bool showMessage;
  final Uri uri;

  @override
  List<Object?> get props => [
    credentialDisplayName,
    issuerName,
    isTrusted,
    claims,
    credentialModel,
    showMessage,
    uri,
  ];
}
