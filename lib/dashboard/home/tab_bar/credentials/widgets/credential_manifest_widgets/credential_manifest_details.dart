import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/widgets/credential_widget/expansion_tile_title.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CredentialManifestDetails extends StatelessWidget {
  const CredentialManifestDetails({
    Key? key,
    required this.credentialModel,
    required this.outputDescriptor,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final OutputDescriptor outputDescriptor;

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).colorScheme.titleColor;
    final valueColor = Theme.of(context).colorScheme.valueColor;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTileContainer(
          child: ExpansionTile(
            initiallyExpanded: true,
            childrenPadding: EdgeInsets.zero,
            tilePadding: const EdgeInsets.symmetric(horizontal: 8),
            title: ExpansionTileTitle(
              title: l10n.credentialManifestDescription,
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: DisplayDescriptionWidget(
                  displayMapping: outputDescriptor.display?.description,
                  credentialModel: credentialModel,
                  textColor: valueColor,
                ),
              ),
            ],
          ),
        ),
        ExpansionTileContainer(
          child: ExpansionTile(
            initiallyExpanded: true,
            childrenPadding: EdgeInsets.zero,
            tilePadding: const EdgeInsets.symmetric(horizontal: 8),
            title: ExpansionTileTitle(
              title: l10n.credentialManifestInformations,
            ),
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DisplayPropertiesWidget(
                    properties: outputDescriptor.display?.properties,
                    credentialModel: credentialModel,
                    titleColor: titleColor,
                    valueColor: valueColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
