import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EthereumAssociatedAddressWidget extends StatelessWidget {
  const EthereumAssociatedAddressWidget({
    super.key,
    this.credentialModel,
  });

  final CredentialModel? credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final associatedAddress = credentialModel?.credentialPreview
        .credentialSubjectModel as EthereumAssociatedAddressModel?;

    return MyBlockchainAccountBaseWidget(
      image: IconStrings.ethereum,
      name: l10n.ethereumNetwork,
      walletAddress: associatedAddress?.associatedAddress ?? '',
    );
  }
}
