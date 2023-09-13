import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayTitleWidget extends StatelessWidget {
  const DisplayTitleWidget({
    this.displayMapping,
    required this.credentialModel,
    required this.textStyle,
    super.key,
  });
  final DisplayMapping? displayMapping;
  final CredentialModel credentialModel;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final object = displayMapping;
    if (object is DisplayMappingText) {
      MyText(object.text, style: textStyle);
    }
    if (object is DisplayMappingPath) {
      final textList = <String>[];
      for (final e in object.path) {
        textList.addAll(getTextsFromCredential(e, credentialModel.data));
      }
      if (textList.isNotEmpty) {
        return MyText(textList.first, maxLines: 1, style: textStyle);
      }
      if (object.fallback != null) {
        return MyText(object.fallback ?? '', maxLines: 1, style: textStyle);
      }
    }
    return const SizedBox.shrink();
  }
}
