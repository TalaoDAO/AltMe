import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:equatable/equatable.dart';

/// One fetched-but-not-yet-recorded credential, shown as a selectable row
/// on the "Add credential to your wallet?" pick screen
/// (Oidc4vcCredentialPickPage), together with its translated claims.
///
/// A batch issuance yields one row for all its copies: [credentialModel] is
/// shown, and [batchCopies] are the other copies, recorded with it.
class CredentialAcceptanceItem extends Equatable {
  const CredentialAcceptanceItem({
    required this.credentialDisplayName,
    required this.claims,
    required this.credentialModel,
    this.batchCopies = const [],
  });

  final String credentialDisplayName;
  final List<ClaimEntry> claims;
  final CredentialModel credentialModel;
  final List<CredentialModel> batchCopies;

  /// Every copy this row records: [credentialModel], then [batchCopies].
  List<CredentialModel> get credentialModels => [
    credentialModel,
    ...batchCopies,
  ];

  @override
  List<Object?> get props => [
    credentialDisplayName,
    claims,
    credentialModel,
    batchCopies,
  ];
}
