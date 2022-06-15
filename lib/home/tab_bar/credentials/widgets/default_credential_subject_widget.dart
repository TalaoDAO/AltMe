import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DefaultCredentialSubjectDisplayInList extends StatelessWidget {
  const DefaultCredentialSubjectDisplayInList(
      {Key? key, required this.credentialModel, this.descriptionMaxLine = 2})
      : super(key: key);

  final CredentialModel credentialModel;
  final int descriptionMaxLine;

  @override
  Widget build(BuildContext context) {
    final credential = Credential.fromJsonOrDummy(credentialModel.data);
    final outputDescriptor =
        credentialModel.credentialManifest?.outputDescriptors?.first;
    // If outputDescriptor exist, the credential has a credential manifest
    // telling us what to display

    if (outputDescriptor == null) {
      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: 584 / 317,
          child: Container(
            decoration: BaseBoxDecoration(
              color: credentialModel.credentialPreview.credentialSubjectModel
                  .credentialSubjectType
                  .backgroundColor(credentialModel),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: const <Alignment>[
                Alignment.bottomRight,
              ],
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
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, bottom: 2),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              DisplayNameCard(
                                credentialModel: credentialModel,
                                style:
                                    Theme.of(context).textTheme.credentialTitle,
                              ),
                              const SizedBox(height: 5),
                              DisplayDescriptionCard(
                                credentialModel: credentialModel,
                                style: Theme.of(context)
                                    .textTheme
                                    .credentialDescription,
                                maxLines: descriptionMaxLine,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: FractionallySizedBox(
                            heightFactor: 0.4,
                            child: DisplayIssuer(
                              issuer: credentialModel.credentialPreview
                                  .credentialSubjectModel.issuedBy!,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      final textColor =
          getColorFromCredential(outputDescriptor.styles?.text, Colors.black);
      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: 584 / 317,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: getColorFromCredential(
                outputDescriptor.styles?.background,
                Colors.white,
              ),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: const <Alignment>[
                Alignment.bottomRight,
              ],
            ),
            child: Material(
              color: Theme.of(context).colorScheme.transparent,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeroFix(
                          tag: 'credential/${credentialModel.id}/icon',
                          child: CredentialIcon(credential: credential),
                        ),
                        const SizedBox(height: 16),
                        DisplayStatus(
                          credentialModel: credentialModel,
                          displayLabel: false,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: outputDescriptor.display?.title != null
                                ? DisplayTitleWidget(
                                    outputDescriptor.display?.title,
                                    credentialModel,
                                    textColor,
                                  )
                                : const Text(''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              height: 48,
                              child: DisplayDescriptionWidget(
                                outputDescriptor.display?.description,
                                credentialModel,
                                textColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          DisplayIssuanceDateWidget(
                            credentialModel.credentialPreview.issuanceDate,
                            textColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class DefaultCredentialSubjectDisplayInSelectionList extends StatelessWidget {
  const DefaultCredentialSubjectDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final outputDescriptor =
        credentialModel.credentialManifest?.outputDescriptors?.first;
    // If outputDescriptor exist, the credential has a credential manifest
    // telling us what to display
    if (outputDescriptor == null) {
      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: 584 / 317,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: credentialModel.credentialPreview.credentialSubjectModel
                  .credentialSubjectType
                  .backgroundColor(credentialModel),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: const <Alignment>[
                Alignment.bottomRight,
              ],
            ),
            child: Material(
              color: Theme.of(context).colorScheme.transparent,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: DisplayNameCard(
                        credentialModel: credentialModel,
                        style: Theme.of(context).textTheme.credentialTitle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: 48,
                        child: DisplayDescriptionCard(
                          credentialModel: credentialModel,
                          style:
                              Theme.of(context).textTheme.credentialDescription,
                        ),
                      ),
                    ),
                    DisplayIssuer(
                      issuer: credentialModel
                          .credentialPreview.credentialSubjectModel.issuedBy!,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      final textColor = getColorFromCredential(
        outputDescriptor.styles?.text,
        Colors.black,
      );

      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: 584 / 317,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: getColorFromCredential(
                outputDescriptor.styles?.background,
                Colors.white,
              ),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: const <Alignment>[
                Alignment.bottomRight,
              ],
            ),
            child: Material(
              color: Theme.of(context).colorScheme.transparent,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: DisplayTitleWidget(
                        outputDescriptor.display?.title,
                        credentialModel,
                        textColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: 48,
                        child: DisplayDescriptionWidget(
                          outputDescriptor.display?.description,
                          credentialModel,
                          textColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    DisplayIssuanceDateWidget(
                      credentialModel.credentialPreview.issuanceDate,
                      textColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class DefaultCredentialSubjectDisplayDetail extends StatelessWidget {
  const DefaultCredentialSubjectDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final outputDescriptor =
        credentialModel.credentialManifest?.outputDescriptors;
    // If outputDescriptor exist, the credential has a credential manifest
    // telling us what to display
    if (outputDescriptor == null) {
      final l10n = context.l10n;

      return AspectRatio(
        aspectRatio: 584 / 317,
        child: CredentialBackground(
          credentialModel: credentialModel,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: DisplayNameCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context).textTheme.credentialTitle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: DisplayDescriptionCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context).textTheme.credentialDescription,
                ),
              ),
              if (credentialModel.credentialPreview.evidence.first.id != '')
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        '${l10n.evidenceLabel}: ',
                        style: Theme.of(context).textTheme.credentialFieldTitle,
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () => LaunchUrl.launch(
                            credentialModel.credentialPreview.evidence.first.id,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text(
                                  credentialModel
                                      .credentialPreview.evidence.first.id,
                                  style: Theme.of(context)
                                      .textTheme
                                      .credentialFieldDescription,
                                  maxLines: 5,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink()
            ],
          ),
        ),
      );
    } else {
      return OutputDescriptorWidget(outputDescriptor, credentialModel);
    }
  }
}
