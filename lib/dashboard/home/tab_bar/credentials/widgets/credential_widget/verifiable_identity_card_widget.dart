import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class VerifiableIdCardDisplayInList extends StatelessWidget {
  const VerifiableIdCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return VerifiableIdCardRecto(credentialModel: credentialModel);
  }
}

class VerifiableIdCardDisplayInSelectionList extends StatelessWidget {
  const VerifiableIdCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return VerifiableIdCardRecto(credentialModel: credentialModel);
  }
}

class VerifiableIdCardDisplayDetail extends StatelessWidget {
  const VerifiableIdCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return VerifiableIdCardRecto(credentialModel: credentialModel);
  }
}

class VerifiableIdCardRecto extends StatelessWidget {
  const VerifiableIdCardRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final verifiableIdCardModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as VerifiableIdCardModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.verifiableIdCard,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: '',
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
