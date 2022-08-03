import 'package:altme/app/shared/date/date.dart';
import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class LabeledDisplayMappingWidget extends StatelessWidget {
  const LabeledDisplayMappingWidget({
    required this.displayMapping,
    required this.credentialModel,
    this.titleColor,
    this.valueColor,
    Key? key,
  }) : super(key: key);
  final DisplayMapping displayMapping;
  final CredentialModel credentialModel;
  final Color? titleColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final object = displayMapping;
    if (object is LabeledDisplayMappingText) {
      return CredentialField(
        value: object.text,
        title: object.label,
        titleColor: titleColor,
        valueColor: valueColor,
      );
    }
    if (object is LabeledDisplayMappingPath) {
      final widgets = <Widget>[];
      for (final e in object.path) {
        final textList = getTextsFromCredential(e, credentialModel.data);
        for (final element in textList) {
          String value = element;

          if (object.schema.format == 'date') {
            if (DateTime.tryParse(element) != null) {
              final DateTime dt = DateTime.parse(element);
              value = UiDate.formatDateTime(dt);
            }
          }

          widgets.add(
            CredentialField(
              value: value,
              title: object.label,
              titleColor: titleColor,
              valueColor: valueColor,
            ),
          );
        }
      }

      if (widgets.isNotEmpty) {
        return Column(
          children: widgets,
        );
      }
      final String? fallback = object.fallback;
      if (fallback != null) {
        String value = fallback;

        if (DateTime.tryParse(fallback) != null) {
          final DateTime dt = DateTime.parse(fallback);
          value = UiDate.formatDateTime(dt);
        }

        return CredentialField(
          title: object.label,
          value: value,
          titleColor: titleColor,
          valueColor: valueColor,
        );
      }
    }
    return const SizedBox.shrink();
  }
}
