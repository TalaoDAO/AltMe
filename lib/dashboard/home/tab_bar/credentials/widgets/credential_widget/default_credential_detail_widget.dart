import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DefaultCredentialDetailWidget extends StatelessWidget {
  const DefaultCredentialDetailWidget({
    super.key,
    required this.credentialModel,
    required this.showBgDecoration,
    required this.fromCredentialOffer,
  });

  final CredentialModel credentialModel;
  final bool showBgDecoration;
  final bool fromCredentialOffer;

  @override
  Widget build(BuildContext context) {
    final outputDescriptors =
        credentialModel.credentialManifest?.outputDescriptors;
    // If outputDescriptor exist, the credential has a credential manifest
    // telling us what to display
    if (outputDescriptors == null) {
      return AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: DefaultSelectionDisplayDescriptor(
          credentialModel: credentialModel,
          showBgDecoration: showBgDecoration,
        ),
      );
    } else {
      if (fromCredentialOffer) {
        return AspectRatio(
          aspectRatio: Sizes.credentialAspectRatio,
          child: DecoratedBox(
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: getColorFromCredential(
                outputDescriptors.first.styles?.background,
                Colors.white,
              ),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: showBgDecoration
                  ? const <Alignment>[Alignment.bottomRight]
                  : const <Alignment>[],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CredentialManifestCard(
                credentialModel: credentialModel,
                outputDescriptor: outputDescriptors.first,
              ),
            ),
          ),
        );
      }

      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: Sizes.credentialAspectRatio,
          child: DecoratedBox(
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: getColorFromCredential(
                outputDescriptors.first.styles?.background,
                Colors.white,
              ),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: showBgDecoration
                  ? const <Alignment>[Alignment.bottomRight]
                  : const <Alignment>[],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CredentialManifestCard(
                credentialModel: credentialModel,
                outputDescriptor: outputDescriptors.first,
              ),
            ),
          ),
        ),
      );
    }
  }
}
