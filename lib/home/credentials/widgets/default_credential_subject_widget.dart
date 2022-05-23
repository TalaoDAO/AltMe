import 'package:altme/app/app.dart';
import 'package:altme/home/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DefaultCredentialSubjectDisplayInList extends StatelessWidget {
  const DefaultCredentialSubjectDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final credential = Credential.fromJsonOrDummy(credentialModel.data);
    return CredentialContainer(
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BaseBoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: credentialModel
              .credentialPreview.credentialSubjectModel.credentialSubjectType
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
                            style: Theme.of(context)
                                .textTheme
                                .credentialDescription,
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
              ],
            ),
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
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BaseBoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: credentialModel
              .credentialPreview.credentialSubjectModel.credentialSubjectType
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
                      style: Theme.of(context).textTheme.credentialDescription,
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
    );
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
    final l10n = context.l10n;
    return CredentialBackground(
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
    );
  }
}
