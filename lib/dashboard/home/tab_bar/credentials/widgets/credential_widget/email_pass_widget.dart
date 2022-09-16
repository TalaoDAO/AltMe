import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/widgets/credential_widget/identity_credential_base_widget.dart';
import 'package:flutter/material.dart';

class EmailPassDisplayInList extends StatelessWidget {
  const EmailPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return EmailPassRecto(credentialModel: credentialModel);
  }
}

class EmailPassDisplayInSelectionList extends StatelessWidget {
  const EmailPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return EmailPassRecto(credentialModel: credentialModel);
  }
}

class EmailPassDisplayDetail extends StatelessWidget {
  const EmailPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmailPassRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class EmailPassRecto extends Recto {
  const EmailPassRecto({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final emailPassModel = credentialModel
        .credentialPreview.credentialSubjectModel as EmailPassModel;
    getLogger('className')
        .i('emailPassModel: ${credentialModel.credentialPreview.issuanceDate}');

    return IdentityCredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.emailProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: emailPassModel.email,
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
