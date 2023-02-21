import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DefaultCredentialListWidget extends StatelessWidget {
  const DefaultCredentialListWidget({
    super.key,
    required this.credentialModel,
    this.showBgDecoration = true,
    this.descriptionMaxLine = 2,
  });

  final CredentialModel credentialModel;
  final int descriptionMaxLine;
  final bool showBgDecoration;

  @override
  Widget build(BuildContext context) {
    final outputDescriptors =
        credentialModel.credentialManifest?.outputDescriptors;
    // If outputDescriptor exist, the credential has a credential manifest
    // telling us what to display

    late Color backgroundColor;
    late Widget descriptionWidget;

    if (outputDescriptors == null) {
      backgroundColor = credentialModel
          .credentialPreview.credentialSubjectModel.credentialSubjectType
          .backgroundColor(credentialModel);

      descriptionWidget = DefaultDisplayDescriptor(
        credentialModel: credentialModel,
        descriptionMaxLine: descriptionMaxLine,
      );
    } else {
      backgroundColor = getColorFromCredential(
        outputDescriptors.first.styles?.background,
        Colors.white,
      )!;

      descriptionWidget = CredentialManifestCard(
        credentialModel: credentialModel,
        outputDescriptor: outputDescriptors.first,
      );
    }

    return CredentialContainer(
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: DecoratedBox(
          decoration: BaseBoxDecoration(
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
          child: descriptionWidget,
        ),
      ),
    );
  }
}
