import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class Over65Widget extends StatelessWidget {
  const Over65Widget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.over65,
      issuerName: credentialModel
          .credentialPreview
          .credentialSubjectModel
          .issuedBy
          ?.name,
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      value: context.l10n.youAreOver65,
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(credentialModel.expirationDate!),
    );
  }
}
