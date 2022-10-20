import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    return const CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.aragoPass,
      expirationDate: '--',
    );
  }
}
