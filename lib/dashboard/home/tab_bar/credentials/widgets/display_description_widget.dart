import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayDescriptionWidget extends StatelessWidget {
  const DisplayDescriptionWidget({
    this.displayMapping,
    required this.credentialModel,
    this.textColor,
    super.key,
  });
  final DisplayMapping? displayMapping;
  final CredentialModel credentialModel;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final object = displayMapping;

    final style = textColor == null
        ? Theme.of(context).textTheme.credentialDescription
        : Theme.of(context)
            .textTheme
            .credentialDescription
            .copyWith(color: textColor);

    if (object is DisplayMappingText) {
      return ManifestText(text: object.text, style: style);
    }

    if (object is DisplayMappingPath) {
      final textList = <String>[];
      for (final e in object.path) {
        textList.addAll(getTextsFromCredential(e, credentialModel.data));
      }
      if (textList.isNotEmpty) {
        return ManifestText(text: textList.first, style: style);
      }
      if (object.fallback != null) {
        return ManifestText(text: object.fallback ?? '', style: style);
      }
    }

    return const SizedBox.shrink();
  }
}

class ManifestText extends StatelessWidget {
  const ManifestText({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}
