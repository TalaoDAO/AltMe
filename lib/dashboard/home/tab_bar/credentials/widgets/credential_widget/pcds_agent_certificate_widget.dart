import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class PcdsAgentCertificateDisplayInList extends StatelessWidget {
  const PcdsAgentCertificateDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return PcdsAgentCertificateRecto(credentialModel: credentialModel);
  }
}

class PcdsAgentCertificateDisplayInSelectionList extends StatelessWidget {
  const PcdsAgentCertificateDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return PcdsAgentCertificateRecto(credentialModel: credentialModel);
  }
}

class PcdsAgentCertificateDisplayDetail extends StatelessWidget {
  const PcdsAgentCertificateDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return PcdsAgentCertificateRecto(credentialModel: credentialModel);
  }
}

class PcdsAgentCertificateRecto extends Verso {
  const PcdsAgentCertificateRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.pcdsAgentCertificate,
      expirationDate: '--',
    );
  }
}
