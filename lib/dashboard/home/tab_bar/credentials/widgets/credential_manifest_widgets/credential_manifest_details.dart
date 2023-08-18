import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CredentialManifestDetails extends StatelessWidget {
  const CredentialManifestDetails({
    super.key,
    required this.credentialModel,
    required this.outputDescriptor,
  });

  final CredentialModel credentialModel;
  final OutputDescriptor outputDescriptor;

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).colorScheme.titleColor;
    final valueColor = Theme.of(context).colorScheme.valueColor;

    final l10n = context.l10n;

    final data = credentialModel.jwt ?? credentialModel.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayDescriptionWidgetWithTitle(
          displayMapping: outputDescriptor.display?.description,
          credentialModel: credentialModel,
          titleColor: titleColor,
          valueColor: valueColor,
        ),
        const SizedBox(height: 10),
        DisplayPropertiesWidget(
          properties: outputDescriptor.display?.properties,
          credentialModel: credentialModel,
          titleColor: titleColor,
          valueColor: valueColor,
        ),
        CredentialField(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          title: l10n.format,
          value: data.toString(),
          titleColor: titleColor,
          valueColor: valueColor,
        ),
      ],
    );
  }
}
