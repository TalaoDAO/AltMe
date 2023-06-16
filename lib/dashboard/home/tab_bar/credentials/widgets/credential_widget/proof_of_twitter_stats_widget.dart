import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class ProofOfTwitterStatsWidget extends StatelessWidget {
  const ProofOfTwitterStatsWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final proofOfTwitterStatsModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as ProofOfTwitterStatsModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.twitterStatsCard,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: '',
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(credentialModel.expirationDate!),
    );
  }
}
