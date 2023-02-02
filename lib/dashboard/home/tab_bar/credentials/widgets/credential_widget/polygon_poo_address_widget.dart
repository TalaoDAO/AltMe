import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PolygonPooAddressWidget extends StatelessWidget {
  const PolygonPooAddressWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pooAddress = credentialModel.credentialPreview.credentialSubjectModel
        as PolygonPooAddressModel;
    return PooAddressBaseWidget(
      image: IconStrings.polygon,
      name: l10n.polygonNetwork,
      walletAddress: pooAddress.associatedAddress ?? '',
      issuerName: pooAddress.issuedBy!.name,
      issuedOn: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
    );
  }
}
