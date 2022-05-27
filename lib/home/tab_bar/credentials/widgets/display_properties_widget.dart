import 'package:altme/home/home.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayPropertiesWidget extends StatelessWidget {
  const DisplayPropertiesWidget(
    this.properties,
    this.item,
    this.textColor, {
    Key? key,
  }) : super(key: key);

  final List<DisplayMapping>? properties;
  final CredentialModel item;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    properties?.forEach((element) {
      widgets.add(
        LabeledDisplayMappingWidget(
          element,
          item,
          textColor,
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
