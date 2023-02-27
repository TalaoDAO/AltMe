import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class EUDiplomaCardWidget extends StatelessWidget {
  const EUDiplomaCardWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final euDiplomaCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as EUDiplomaCardModel;
    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.euDiplomaCard,
      // issuerName: credentialModel
      //     .credentialPreview.credentialSubjectModel.issuedBy?.name,
      issuerName:
          euDiplomaCardModel.awardingOpportunity?.awardingBody?.preferredName ??
              '',
      value: euDiplomaCardModel.learningAchievement?.title ?? '',
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(credentialModel.expirationDate!),
    );
  }
}
