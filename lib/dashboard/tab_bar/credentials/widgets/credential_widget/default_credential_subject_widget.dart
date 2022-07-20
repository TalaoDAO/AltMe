import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DefaultCredentialSubjectDisplayInList extends StatelessWidget {
  const DefaultCredentialSubjectDisplayInList({
    Key? key,
    required this.credentialModel,
    this.descriptionMaxLine = 2,
    this.showBgDecoration = true,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final int descriptionMaxLine;
  final bool showBgDecoration;

  @override
  Widget build(BuildContext context) {
    final credential = Credential.fromJsonOrDummy(credentialModel.data);
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
      descriptionWidget = CredentialManifestDisplayDescriptor(
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
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HeroFix(
                        tag: 'credential/${credentialModel.id}/icon',
                        child: Container(
                          alignment: Alignment.center,
                          child: FractionallySizedBox(
                            heightFactor: 0.4,
                            child: FittedBox(
                              child: Center(
                                child: CredentialIcon(credential: credential),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: FractionallySizedBox(
                          heightFactor: 0.4,
                          child: FittedBox(
                            child: DisplayStatus(
                              credentialModel: credentialModel,
                              displayLabel: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, bottom: 2),
                  child: descriptionWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultCredentialSubjectDisplayInSelectionList extends StatelessWidget {
  const DefaultCredentialSubjectDisplayInSelectionList({
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
      descriptionWidget = CredentialManifestDisplayDescriptor(
        credentialModel: credentialModel,
        outputDescriptor: outputDescriptor,
      );
    }
    return CredentialContainer(
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: Container(
          decoration: BaseBoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: backgroundColor,
            shapeColor: Theme.of(context).colorScheme.documentShape,
            value: 1,
            anchors: showBgDecoration
                ? const <Alignment>[Alignment.bottomRight]
                : const <Alignment>[],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: descriptionWidget,
          ),
        ),
      ),
    );
  }
}

class DefaultCredentialSubjectDisplayDetail extends StatelessWidget {
  const DefaultCredentialSubjectDisplayDetail({
    Key? key,
    required this.credentialModel,
    required this.showBgDecoration,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final bool showBgDecoration;

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
      final backgroundColor = getColorFromCredential(
        outputDescriptors.first.styles?.background,
        Colors.white,
      );

      final Widget descriptionWidget = CredentialManifestDisplayDescriptor(
        credentialModel: credentialModel,
        outputDescriptor: outputDescriptors.first,
      );

      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: Sizes.credentialAspectRatio,
          child: Container(
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: backgroundColor,
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: showBgDecoration
                  ? const <Alignment>[Alignment.bottomRight]
                  : const <Alignment>[],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: descriptionWidget,
            ),
          ),
        ),
      );
    }
  }
}
