import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/dashboard.dart';
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
      children: [
        BackgroundCard(
          color: Theme.of(context).colorScheme.surfaceContainer,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.only(bottom: 8),
          child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
              dividerColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              childrenPadding: EdgeInsets.zero,
              tilePadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(
                l10n.credentialManifestDescription,
                style: Theme.of(context).textTheme.credentialManifestTitle2,
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
        ),
        BackgroundCard(
          color: Theme.of(context).colorScheme.surfaceContainer,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.only(bottom: 8),
          child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
              dividerColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              childrenPadding: EdgeInsets.zero,
              tilePadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(
                l10n.credentialManifestInformations,
                style: Theme.of(context).textTheme.credentialManifestTitle2,
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DisplayPropertiesWidget(
                    properties: outputDescriptor.display?.properties,
                    credentialModel: credentialModel,
                    titleColor: titleColor,
                    valueColor: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        BackgroundCard(
          color: Theme.of(context).colorScheme.surfaceContainer,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.only(bottom: 8),
          child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
              dividerColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              childrenPadding: EdgeInsets.zero,
              tilePadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(
                l10n.credentialManifestActivity,
                style: Theme.of(context).textTheme.credentialManifestTitle2,
              ),
              children: const <Widget>[],
            ),
          ),
        ),
      ],
    );
  }
}
