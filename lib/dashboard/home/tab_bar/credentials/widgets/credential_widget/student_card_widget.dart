import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class StudentCardWidget extends StatelessWidget {
  const StudentCardWidget({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final studentCardModel =
        credentialModel.credentialPreview.credentialSubjectModel
            as StudentCardModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.studentCardFront,
      issuerName: studentCardModel.issuedBy!.name,
      value:
          '${studentCardModel.recipient!.givenName}'
          ' ${studentCardModel.recipient!.familyName}',
      expirationDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.expirationDate,
      ),
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
    );
  }
}
