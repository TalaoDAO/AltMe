import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class LinkedinCardWidget extends StatelessWidget {
  const LinkedinCardWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.linkedInCard,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: '',
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(
              credentialModel.expirationDate!,
            ),
    );
  }
}
