import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/home/home.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayMappingWidget extends StatelessWidget {
  const DisplayMappingWidget(
    this.displayMapping,
    this.item,
    this.textColor, {
    Key? key,
  }) : super(key: key);
  final DisplayMapping? displayMapping;
  final CredentialModel item;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final object = displayMapping;
    if (object is DisplayMappingText) {
      return CredentialField(
        value: object.text,
        textColor: textColor,
      );
    }
    if (object is DisplayMappingPath) {
      final widgets = <Widget>[];
      for (final e in object.path) {
        final textList = getTextsFromCredential(e, item.data);
        for (final element in textList) {
          widgets.add(
            CredentialField(
              value: element,
              textColor: textColor,
            ),
          );
        }
      }

      if (widgets.isNotEmpty) {
        return Column(
          children: widgets,
        );
      }
      if (object.fallback != null) {
        return CredentialField(
          value: object.fallback ?? '',
          textColor: textColor,
        );
      }
    }
    return const SizedBox.shrink();
  }
}
