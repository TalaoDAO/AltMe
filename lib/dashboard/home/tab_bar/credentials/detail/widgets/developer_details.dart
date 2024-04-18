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
    required this.statusListUri,
    required this.statusListIndex,
  });

  final CredentialModel credentialModel;
  final bool showVertically;
  final String? statusListUri;
  final int? statusListIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final String issuerDid = credentialModel.credentialPreview.issuer;
    final String subjectDid =
        credentialModel.credentialPreview.credentialSubjectModel.id ?? '';
    final String type = credentialModel.credentialPreview.type.toString();

    final titleColor = Theme.of(context).colorScheme.titleColor;
    final valueColor = Theme.of(context).colorScheme.valueColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.format,
          value: credentialModel.getFormat,
          titleColor: titleColor,
          valueColor: valueColor,
          showVertically: showVertically,
        ),
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.issuerDID,
          value: issuerDid,
          titleColor: titleColor,
          valueColor: valueColor,
          showVertically: showVertically,
        ),
        if (credentialModel.credentialPreview.credentialSubjectModel
                is! WalletCredentialModel &&
            subjectDid.isNotEmpty)
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.subjectDID,
            value: subjectDid,
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: showVertically,
          ),
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.type,
          value: type,
          titleColor: titleColor,
          valueColor: valueColor,
          showVertically: showVertically,
        ),
        if (statusListUri != null) ...[
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.statusList,
            value: statusListUri.toString(),
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: false,
          ),
        ],
        if (statusListIndex != null) ...[
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.statusListIndex,
            value: statusListIndex.toString(),
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: false,
          ),
        ],
      ],
    );
  }
}
