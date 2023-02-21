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

    late Color backgroundColor;

    if (outputDescriptors == null) {
      backgroundColor = credentialModel
          .credentialPreview.credentialSubjectModel.credentialSubjectType
          .backgroundColor(credentialModel);

      return AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: DefaultSelectionDisplayDescriptor(
          credentialModel: credentialModel,
          showBgDecoration: showBgDecoration,
        ),
      );
    } else {
      backgroundColor = getColorFromCredential(
        outputDescriptors.first.styles?.background,
        Colors.white,
      )!;

      if (fromCredentialOffer) {
        return AspectRatio(
          aspectRatio: Sizes.credentialAspectRatio,
          child: DecoratedBox(
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.credentialAspectRatio),
              color: backgroundColor,
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: showBgDecoration
                  ? const <Alignment>[Alignment.bottomRight]
                  : const <Alignment>[],
            ),
            child: Padding(
              padding: const EdgeInsets.all(Sizes.credentialAspectRatio),
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
              borderRadius: BorderRadius.circular(Sizes.credentialBorderRadius),
              color: backgroundColor,
              gradient: isVerifiableDiplomaType(credentialModel)
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff0B67C5),
                        Color(0xff200072),
                      ],
                    )
                  : null,
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
