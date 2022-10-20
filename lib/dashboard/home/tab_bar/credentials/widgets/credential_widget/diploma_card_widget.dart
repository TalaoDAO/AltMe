import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DiplomaCardDisplayInList extends StatelessWidget {
  const DiplomaCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DiplomaCardRecto(credentialModel: credentialModel);
  }
}

class DiplomaCardDisplayInSelectionList extends StatelessWidget {
  const DiplomaCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DiplomaCardRecto(credentialModel: credentialModel);
  }
}

class DiplomaCardDisplayDetail extends StatelessWidget {
  const DiplomaCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DiplomaCardRecto(credentialModel: credentialModel);
  }
}

class DiplomaCardRecto extends StatelessWidget {
  const DiplomaCardRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final diplomaCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as DiplomaCardModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.diplomaCard,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: diplomaCardModel.familyName,
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
