import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class NationalityWidget extends StatelessWidget {
  const NationalityWidget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final nationalityModel = credentialModel
        .credentialPreview.credentialSubjectModel as NationalityModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.nationalityProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: nationalityModel.nationality,
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
