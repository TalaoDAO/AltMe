import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class PcdsAgentCertificateWidget extends StatelessWidget {
  const PcdsAgentCertificateWidget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.pcdsAgentCertificate,
      expirationDate: '--',
    );
  }
}
