import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/identity_credential_base_widget.dart';
import 'package:flutter/material.dart';

class AragoEmailPassDisplayInList extends StatelessWidget {
  const AragoEmailPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoEmailPassRecto(credentialModel: credentialModel);
  }
}

class AragoEmailPassDisplayInSelectionList extends StatelessWidget {
  const AragoEmailPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoEmailPassRecto(credentialModel: credentialModel);
  }
}

class AragoEmailPassDisplayDetail extends StatelessWidget {
  const AragoEmailPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AragoEmailPassRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class AragoEmailPassRecto extends Recto {
  const AragoEmailPassRecto({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    getLogger('className')
        .i('emailPassModel: ${credentialModel.credentialPreview.issuanceDate}');

    return const IdentityCredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.aragoEmailProof,
      // issuerName: credentialModel
      //     .credentialPreview.credentialSubjectModel.issuedBy?.name,
      // value: emailPassModel.email,
      // issuanceDate: UiDate.formatDateForCredentialCard(
      //   credentialModel.credentialPreview.issuanceDate,
      // ),
      expirationDate: '--',
    );
  }
}
