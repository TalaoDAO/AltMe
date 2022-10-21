import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    getLogger('AragoEmailPass')
        .i('emailPassModel: ${credentialModel.credentialPreview.issuanceDate}');
    return const CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.aragoEmailProof,
      expirationDate: '--',
    );
  }
}
