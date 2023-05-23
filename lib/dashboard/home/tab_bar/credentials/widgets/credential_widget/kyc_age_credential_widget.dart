import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class KYCAgeCredentialWidget extends StatelessWidget {
  const KYCAgeCredentialWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final kycAgeResidenceCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as KYCAgeCredentialModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.kycAgeCredentialCard,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: '${l10n.birthdate}: ${birthDateFormater(
        kycAgeResidenceCardModel.birthday!,
      )}',
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
