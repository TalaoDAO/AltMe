import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class Over18DisplayInList extends StatelessWidget {
  const Over18DisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Over18Recto(credentialModel: credentialModel);
  }
}

class Over18DisplayInSelectionList extends StatelessWidget {
  const Over18DisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Over18Recto(credentialModel: credentialModel);
  }
}

class Over18DisplayDetail extends StatelessWidget {
  const Over18DisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Over18Recto(credentialModel: credentialModel);
  }
}

class Over18Recto extends Verso {
  const Over18Recto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.over18,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
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
