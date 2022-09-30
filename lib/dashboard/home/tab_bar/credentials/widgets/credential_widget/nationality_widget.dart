import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/identity_credential_base_widget.dart';
import 'package:flutter/material.dart';

class NationalityDisplayInList extends StatelessWidget {
  const NationalityDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return NationalityRecto(credentialModel: credentialModel);
  }
}

class NationalityDisplayInSelectionList extends StatelessWidget {
  const NationalityDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return NationalityRecto(credentialModel: credentialModel);
  }
}

class NationalityDisplayDetail extends StatelessWidget {
  const NationalityDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NationalityRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class NationalityRecto extends Recto {
  const NationalityRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final nationalityModel = credentialModel
        .credentialPreview.credentialSubjectModel as NationalityModel;

    return IdentityCredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.nationalityProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: nationalityModel.nationality,
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
