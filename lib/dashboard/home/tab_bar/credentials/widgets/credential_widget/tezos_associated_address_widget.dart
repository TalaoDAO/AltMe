import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TezosAssociatedAddressWidget extends StatelessWidget {
  const TezosAssociatedAddressWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final associatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as TezosAssociatedAddressModel;
    return MyBlockchainAccountBaseWidget(
      image: IconStrings.tezos,
      name: l10n.tezosNetwork,
      walletAddress: associatedAddress.associatedAddress ?? '',
    );
  }
}
