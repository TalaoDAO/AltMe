import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EtherlinkAssociatedAddressWidget extends StatelessWidget {
  const EtherlinkAssociatedAddressWidget({
    super.key,
    this.credentialModel,
  });

  final CredentialModel? credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final associatedAddress = credentialModel?.credentialPreview
        .credentialSubjectModel as EtherlinkAssociatedAddressModel?;

    return MyBlockchainAccountBaseWidget(
      background: ImageStrings.etherlinkOwnershipCard,
      proofMessage: l10n.etherlinkProofMessage,
      walletAddress: associatedAddress?.associatedAddress ?? '',
    );
  }
}
