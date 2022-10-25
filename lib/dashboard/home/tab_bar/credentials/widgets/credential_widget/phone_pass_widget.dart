import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class PhonePassDisplayInList extends StatelessWidget {
  const PhonePassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return PhonePassDisplayDetail(
      credentialModel: credentialModel,
    );
  }
}

class PhonePassDisplayInSelectionList extends StatelessWidget {
  const PhonePassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return PhonePassDisplayDetail(
      credentialModel: credentialModel,
    );
  }
}

class PhonePassDisplayDetail extends StatelessWidget {
  const PhonePassDisplayDetail({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final phonePassModel = credentialModel
        .credentialPreview.credentialSubjectModel as PhonePassModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.phoneProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: phonePassModel.phone,
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
