import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:equatable/equatable.dart';

/// Data shown on the "Add credential to your wallet?" confirmation screen,
/// carried through QRCodeScanCubit's pauseForCredentialAcceptance state
/// since the credential fetch happens outside of any widget context.
class CredentialAcceptanceData extends Equatable {
  const CredentialAcceptanceData({
    required this.credentialDisplayName,
    required this.issuerName,
    required this.isTrusted,
    required this.claims,
  });

  final String credentialDisplayName;
  final String issuerName;
  final bool isTrusted;
  final List<ClaimEntry> claims;

  @override
  List<Object?> get props => [
    credentialDisplayName,
    issuerName,
    isTrusted,
    claims,
  ];
}
