import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DeveloperDetails extends StatelessWidget {
  const DeveloperDetails({
    super.key,
    required this.credentialModel,
    required this.showVertically,
  });

  final CredentialModel credentialModel;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final String issuerDid = credentialModel.credentialPreview.issuer;
    final String subjectDid =
        credentialModel.credentialPreview.credentialSubjectModel.id ?? '';
    final String type = credentialModel.credentialPreview.type.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.format,
          value: credentialModel.getFormat,
          titleColor: Theme.of(context).colorScheme.titleColor,
          valueColor: Theme.of(context).colorScheme.valueColor,
          showVertically: showVertically,
        ),
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.issuerDID,
          value: issuerDid,
          titleColor: Theme.of(context).colorScheme.titleColor,
          valueColor: Theme.of(context).colorScheme.valueColor,
          showVertically: showVertically,
        ),
        if (credentialModel.credentialPreview.credentialSubjectModel
                is! WalletCredentialModel &&
            subjectDid.isNotEmpty)
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.subjectDID,
            value: subjectDid,
            titleColor: Theme.of(context).colorScheme.titleColor,
            valueColor: Theme.of(context).colorScheme.valueColor,
            showVertically: showVertically,
          ),
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.type,
          value: type,
          titleColor: Theme.of(context).colorScheme.titleColor,
          valueColor: Theme.of(context).colorScheme.valueColor,
          showVertically: showVertically,
        ),
      ],
    );
  }
}
