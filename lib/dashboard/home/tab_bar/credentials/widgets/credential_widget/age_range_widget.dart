import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class AgeRangeWidget extends StatelessWidget {
  const AgeRangeWidget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final ageRangeModel = credentialModel
        .credentialPreview.credentialSubjectModel as AgeRangeModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.ageRangeProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value:
          (ageRangeModel.ageRange != null && ageRangeModel.ageRange!.isNotEmpty)
              ? '${ageRangeModel.ageRange} YO'
              : '--',
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
