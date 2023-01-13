import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class FantomAssociatedAddressWidget extends StatelessWidget {
  const FantomAssociatedAddressWidget({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final associatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as FantomAssociatedAddressModel;

    return MyBlockchainAccountBaseWidget(
      image: IconStrings.fantom,
      name: l10n.fantomNetwork,
      walletAddress: associatedAddress.associatedAddress ?? '',
    );
  }
}
