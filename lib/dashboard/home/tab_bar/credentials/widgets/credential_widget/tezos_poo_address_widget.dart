import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TezosPooAddressWidget extends StatelessWidget {
  const TezosPooAddressWidget({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pooAddress = credentialModel.credentialPreview.credentialSubjectModel
        as TezosPooAddressModel;
    return PooAddressBaseWidget(
      image: IconStrings.tezos,
      name: l10n.tezosNetwork,
      walletAddress: pooAddress.associatedAddress ?? '',
      issuerName: pooAddress.issuedBy!.name,
      issuedOn: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
    );
  }
}
