import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DefaultCredentialWidget extends StatelessWidget {
  const DefaultCredentialWidget({
    super.key,
    required this.credentialModel,
    required this.isDiscover,
    this.showBgDecoration = true,
    this.descriptionMaxLine = 2,
    this.displyalDescription = true,
  });

  final CredentialModel credentialModel;
  final int descriptionMaxLine;
  final bool showBgDecoration;
  final bool displyalDescription;
  final bool isDiscover;

  @override
  Widget build(BuildContext context) {
    final outputDescriptors =
        credentialModel.credentialManifest?.outputDescriptors;
    // If outputDescriptor exist, the credential has a credential manifest
    // telling us what to display

    if (outputDescriptors == null) {
      return DefaultDisplayDescriptor(
        credentialModel: credentialModel,
        descriptionMaxLine: descriptionMaxLine,
        showBgDecoration: showBgDecoration,
        displyalDescription: displyalDescription,
        isDiscover: isDiscover,
      );
    } else {
      return CredentialManifestCard(
        credentialModel: credentialModel,
        outputDescriptor: outputDescriptors.first,
        showBgDecoration: showBgDecoration,
      );
    }
  }
}
