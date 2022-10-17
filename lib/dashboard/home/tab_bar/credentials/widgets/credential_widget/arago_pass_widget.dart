import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/identity_credential_base_widget.dart';
import 'package:flutter/material.dart';

class AragoPassDisplayInList extends StatelessWidget {
  const AragoPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoPassRecto(credentialModel: credentialModel);
  }
}

class AragoPassDisplayInSelectionList extends StatelessWidget {
  const AragoPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoPassRecto(credentialModel: credentialModel);
  }
}

class AragoPassDisplayDetail extends StatelessWidget {
  const AragoPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoPassRecto(credentialModel: credentialModel);
  }
}

class AragoPassRecto extends Verso {
  const AragoPassRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const IdentityCredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.aragoPass,
      // issuerName: credentialModel
      //     .credentialPreview.credentialSubjectModel.issuedBy?.name,
      // issuanceDate: UiDate.formatDateForCredentialCard(
      //   credentialModel.credentialPreview.issuanceDate,
      // ),
      expirationDate: '--',
    );
  }
}
