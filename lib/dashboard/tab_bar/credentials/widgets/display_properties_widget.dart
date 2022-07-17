import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayPropertiesWidget extends StatelessWidget {
  const DisplayPropertiesWidget({
    this.properties,
    required this.credentialModel,
    this.textColor,
    Key? key,
  }) : super(key: key);

  final List<DisplayMapping>? properties;
  final CredentialModel credentialModel;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    properties?.forEach((element) {
      widgets.add(
        LabeledDisplayMappingWidget(
          displayMapping: element,
          credentialModel: credentialModel,
          textColor: textColor,
        ),
      );
    });
    if (widgets.isNotEmpty) {
      return Column(
        children: widgets,
      );
    }
    return const SizedBox.shrink();
  }
}
