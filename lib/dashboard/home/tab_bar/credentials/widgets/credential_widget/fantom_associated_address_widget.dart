import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class FantomAssociatedAddressWidget extends StatelessWidget {
  const FantomAssociatedAddressWidget({super.key, this.credentialModel});

  final CredentialModel? credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final associatedAddress =
        credentialModel?.credentialPreview.credentialSubjectModel
            as FantomAssociatedAddressModel?;

    return MyBlockchainAccountBaseWidget(
      background: ImageStrings.fantomOwnershipCard,
      proofMessage: l10n.fantomProofMessage,
      walletAddress: associatedAddress?.associatedAddress ?? '',
    );
  }
}
