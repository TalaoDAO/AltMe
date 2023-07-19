import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class CivicPassCredentialWidget extends StatelessWidget {
  const CivicPassCredentialWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final civicPassCredentialModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as CivicPassCredentialModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.civicPassCard,
      issuerName: 'CIVIC',
      value: 'Your ID is verified',
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(credentialModel.expirationDate!),
    );
  }
}
