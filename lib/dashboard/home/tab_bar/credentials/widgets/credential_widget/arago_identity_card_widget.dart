import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class AragoIdentityCardDisplayInList extends StatelessWidget {
  const AragoIdentityCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoIdentityCardRecto(credentialModel: credentialModel);
  }
}

class AragoIdentityCardDisplayInSelectionList extends StatelessWidget {
  const AragoIdentityCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoIdentityCardRecto(credentialModel: credentialModel);
  }
}

class AragoIdentityCardDisplayDetail extends StatelessWidget {
  const AragoIdentityCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoIdentityCardRecto(credentialModel: credentialModel);
  }
}

class AragoIdentityCardRecto extends StatelessWidget {
  const AragoIdentityCardRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.aragoIdentityCard,
      expirationDate: '--',
    );
  }
}
