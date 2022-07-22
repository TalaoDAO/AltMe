import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayDescriptionWidget extends StatelessWidget {
  const DisplayDescriptionWidget({
    this.displayMapping,
    required this.credentialModel,
    this.textColor,
    Key? key,
  }) : super(key: key);
  final DisplayMapping? displayMapping;
  final CredentialModel credentialModel;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final object = displayMapping;

    final color = textColor == null
        ? Theme.of(context).textTheme.credentialDescription
        : Theme.of(context)
            .textTheme
            .credentialDescription
            .copyWith(color: textColor);

    if (object is DisplayMappingText) {
      return MyText(object.text, style: color, maxLines: 2);
    }

    if (object is DisplayMappingPath) {
      final textList = <String>[];
      for (final e in object.path) {
        textList.addAll(getTextsFromCredential(e, credentialModel.data));
      }
      if (textList.isNotEmpty) {
        return MyText(textList.first, style: color, maxLines: 2);
      }
      if (object.fallback != null) {
        return MyText(object.fallback ?? '', style: color, maxLines: 2);
      }
    }

    return const SizedBox.shrink();
  }
}
