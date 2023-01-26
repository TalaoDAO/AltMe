import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class BinancePooAddressWidget extends StatelessWidget {
  const BinancePooAddressWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pooAddress = credentialModel.credentialPreview.credentialSubjectModel
        as BinancePooAddressModel;

    return PooAddressBaseWidget(
      image: IconStrings.binance,
      name: l10n.binanceNetwork,
      walletAddress: pooAddress.associatedAddress ?? '',
      issuerName: pooAddress.issuedBy!.name,
      issuedOn: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
    );
  }
}
