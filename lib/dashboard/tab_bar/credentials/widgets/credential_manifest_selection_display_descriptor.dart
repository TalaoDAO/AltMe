import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CredentialSelectionManifestDisplayDescriptor extends StatelessWidget {
  const CredentialSelectionManifestDisplayDescriptor({
    Key? key,
    required this.credentialModel,
    required this.outputDescriptors,
    this.showTile = true,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final List<OutputDescriptor> outputDescriptors;
  final bool showTile;

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).colorScheme.titleColor;
    final valueColor = Theme.of(context).colorScheme.valueColor;
    return showTile
        ? ListView.builder(
            itemCount: outputDescriptors.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, i) {
              final element = outputDescriptors[i];
              return BackgroundCard(
                color: Theme.of(context).colorScheme.surfaceContainer,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.only(bottom: 8),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor:
                        Theme.of(context).colorScheme.onPrimary,
                    dividerColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: EdgeInsets.zero,
                    title: DisplayMappingWidget(
                      displayMapping: element.display?.title,
                      credentialModel: credentialModel,
                      style:
                          Theme.of(context).textTheme.credentialManifestTitle2,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DisplayMappingWidget(
                              displayMapping: element.display?.subtitle,
                              credentialModel: credentialModel,
                              style: Theme.of(context)
                                  .textTheme
                                  .credentialManifestDescription,
                            ),
                            DisplayMappingWidget(
                              displayMapping: element.display?.description,
                              credentialModel: credentialModel,
                              style: Theme.of(context)
                                  .textTheme
                                  .credentialManifestDescription,
                            ),
                            DisplayPropertiesWidget(
                              properties: element.display?.properties,
                              credentialModel: credentialModel,
                              titleColor: titleColor,
                              valueColor: valueColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : Column(
            children: [
              ListView.builder(
                itemCount: outputDescriptors.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, i) {
                  final element = outputDescriptors[i];
                  return BackgroundCard(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: [
                        DisplayMappingWidget(
                          displayMapping: element.display?.title,
                          credentialModel: credentialModel,
                          style: Theme.of(context)
                              .textTheme
                              .credentialManifestTitle1,
                        ),
                        DisplayMappingWidget(
                          displayMapping: element.display?.subtitle,
                          credentialModel: credentialModel,
                          style: Theme.of(context)
                              .textTheme
                              .credentialManifestDescription,
                        ),
                        DisplayMappingWidget(
                          displayMapping: element.display?.description,
                          credentialModel: credentialModel,
                          style: Theme.of(context)
                              .textTheme
                              .credentialManifestDescription,
                        ),
                        DisplayPropertiesWidget(
                          properties: element.display?.properties,
                          credentialModel: credentialModel,
                          titleColor: titleColor,
                          valueColor: valueColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
  }
}
