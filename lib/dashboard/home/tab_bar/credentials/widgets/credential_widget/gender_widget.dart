import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/identity_credential_base_widget.dart';
import 'package:flutter/material.dart';

class GenderDisplayInList extends StatelessWidget {
  const GenderDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return GenderRecto(credentialModel: credentialModel);
  }
}

class GenderDisplayInSelectionList extends StatelessWidget {
  const GenderDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return GenderRecto(credentialModel: credentialModel);
  }
}

class GenderDisplayDetail extends StatelessWidget {
  const GenderDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenderRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class GenderRecto extends Recto {
  const GenderRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final genderModel =
        credentialModel.credentialPreview.credentialSubjectModel as GenderModel;

    return IdentityCredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.genderProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: genderModel.gender ?? '',
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
