import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class AragoIdentityCardWidget extends StatelessWidget {
  const AragoIdentityCardWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.aragoIdentityCard,
      expirationDate: '--',
    );
  }
}
