import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class EmailPassWidget extends StatelessWidget {
  const EmailPassWidget({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final emailPassModel = credentialModel
        .credentialPreview.credentialSubjectModel as EmailPassModel;
    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.emailProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: emailPassModel.email,
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
