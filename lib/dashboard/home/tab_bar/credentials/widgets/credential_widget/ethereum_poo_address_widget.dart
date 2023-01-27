import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EthereumPooAddressWidget extends StatelessWidget {
  const EthereumPooAddressWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pooAddress = credentialModel.credentialPreview.credentialSubjectModel
        as EthereumPooAddressModel;

    return PooAddressBaseWidget(
      image: IconStrings.ethereum,
      name: l10n.ethereumNetwork,
      walletAddress: pooAddress.associatedAddress ?? '',
      issuerName: pooAddress.issuedBy!.name,
      issuedOn: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
    );
  }
}
