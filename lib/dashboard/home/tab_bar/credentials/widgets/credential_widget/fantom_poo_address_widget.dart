import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class FantomPooAddressWidget extends StatelessWidget {
  const FantomPooAddressWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pooAddress = credentialModel.credentialPreview.credentialSubjectModel
        as FantomPooAddressModel;

    return PooAddressBaseWidget(
      image: IconStrings.fantom,
      name: l10n.fantomNetwork,
      walletAddress: pooAddress.associatedAddress ?? '',
      issuerName: pooAddress.issuedBy!.name,
      issuedOn: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
    );
  }
}
