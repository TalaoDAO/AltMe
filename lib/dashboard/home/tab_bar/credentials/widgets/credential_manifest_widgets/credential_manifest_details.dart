import 'package:altme/dashboard/dashboard.dart';

import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CredentialManifestDetails extends StatelessWidget {
  const CredentialManifestDetails({
    super.key,
    required this.credentialModel,
    required this.outputDescriptor,
  });

  final CredentialModel credentialModel;
  final OutputDescriptor? outputDescriptor;

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).colorScheme.onSurface;
    final valueColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        DisplayDescriptionWidgetWithTitle(
          displayMapping: outputDescriptor?.display?.description,
          credentialModel: credentialModel,
          titleColor: titleColor,
          valueColor: valueColor,
        ),
        const SizedBox(height: 10),
        DisplayPropertiesWidget(
          properties: outputDescriptor?.display?.properties,
          credentialModel: credentialModel,
          titleColor: titleColor,
          valueColor: valueColor,
        ),
      ],
    );
  }
}
