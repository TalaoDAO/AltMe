import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class EUVerifiableIdWidget extends StatelessWidget {
  const EUVerifiableIdWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final euVerifiableIdModel = credentialModel
        .credentialPreview.credentialSubjectModel as EUVerifiableIdModel;
    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.euVerifiableId,
      // issuerName: credentialModel
      //     .credentialPreview.credentialSubjectModel.issuedBy?.name,
      issuerName: euVerifiableIdModel
              .awardingOpportunity?.awardingBody?.preferredName ??
          '',
      value: euVerifiableIdModel.learningAchievement?.title ?? '',
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(credentialModel.expirationDate!),
    );
  }
}
