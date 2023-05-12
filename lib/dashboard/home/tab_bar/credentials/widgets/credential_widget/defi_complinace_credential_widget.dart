import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DefiComplianceCredentialWidget extends StatelessWidget {
  const DefiComplianceCredentialWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final defiComplianceModel = credentialModel
        .credentialPreview.credentialSubjectModel as DefiComplianceModel;
    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.defiComplianceCard,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: defiComplianceModel.ageCheck ?? '',
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.expirationDate,
      ),
    );
  }
}
