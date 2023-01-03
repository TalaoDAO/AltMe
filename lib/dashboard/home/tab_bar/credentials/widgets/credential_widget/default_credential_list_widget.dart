import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DefaultCredentialListWidget extends StatelessWidget {
  const DefaultCredentialListWidget({
    Key? key,
    required this.credentialModel,
    this.showBgDecoration = true,
    this.descriptionMaxLine = 2,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final int descriptionMaxLine;
  final bool showBgDecoration;

  @override
  Widget build(BuildContext context) {
    final outputDescriptor =
        credentialModel.credentialManifest?.outputDescriptors?.first;
    // If outputDescriptor exist, the credential has a credential manifest
    // telling us what to display

    final backgroundColor = outputDescriptor == null
        ? credentialModel
            .credentialPreview.credentialSubjectModel.credentialSubjectType
            .backgroundColor(credentialModel)
        : getColorFromCredential(
            outputDescriptor.styles?.background,
            Colors.white,
          );

    late Widget descriptionWidget;

    if (outputDescriptor == null) {
      descriptionWidget = DefaultDisplayDescriptor(
        credentialModel: credentialModel,
        descriptionMaxLine: descriptionMaxLine,
      );
    } else {
      descriptionWidget = CredentialManifestCard(
        credentialModel: credentialModel,
        outputDescriptor: outputDescriptor,
      );
    }
    return CredentialContainer(
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: Container(
          decoration: BaseBoxDecoration(
            color: backgroundColor,
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
