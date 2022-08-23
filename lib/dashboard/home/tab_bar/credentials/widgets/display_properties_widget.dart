import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayPropertiesWidget extends StatelessWidget {
  const DisplayPropertiesWidget({
    this.properties,
    required this.credentialModel,
    this.titleColor,
    this.valueColor,
    Key? key,
  }) : super(key: key);

  final List<DisplayMapping>? properties;
  final CredentialModel credentialModel;
  final Color? titleColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    properties?.forEach((element) {
      widgets.add(
        LabeledDisplayMappingWidget(
          displayMapping: element,
          credentialModel: credentialModel,
          titleColor: titleColor,
          valueColor: valueColor,
        ),
      );
    });
    if (widgets.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }
    return const SizedBox.shrink();
  }
}
