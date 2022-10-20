import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class AragoOver18DisplayInList extends StatelessWidget {
  const AragoOver18DisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoOver18Recto(credentialModel: credentialModel);
  }
}

class AragoOver18DisplayInSelectionList extends StatelessWidget {
  const AragoOver18DisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoOver18Recto(credentialModel: credentialModel);
  }
}

class AragoOver18DisplayDetail extends StatelessWidget {
  const AragoOver18DisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoOver18Recto(credentialModel: credentialModel);
  }
}

class AragoOver18Recto extends Verso {
  const AragoOver18Recto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.aragoOver18,
      expirationDate: '--',
    );
  }
}
