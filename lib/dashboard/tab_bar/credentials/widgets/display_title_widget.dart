import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayTitleWidget extends StatelessWidget {
  const DisplayTitleWidget({
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
    if (object is DisplayMappingText) {
      MyText(
        object.text,
        style: textColor == null
            ? Theme.of(context).textTheme.credentialFieldDescription
            : Theme.of(context)
                .textTheme
                .credentialFieldDescription
                .copyWith(color: textColor),
      );
    }
    if (object is DisplayMappingPath) {
      final textList = <String>[];
      for (final e in object.path) {
        textList.addAll(getTextsFromCredential(e, credentialModel.data));
      }
      if (textList.isNotEmpty) {
        return MyText(
          textList.first,
          maxLines: 1,
          style: textColor == null
              ? Theme.of(context).textTheme.credentialTitle
              : Theme.of(context)
                  .textTheme
                  .credentialTitle
                  .copyWith(color: textColor),
        );
      }
      if (object.fallback != null) {
        return MyText(
          object.fallback ?? '',
          maxLines: 1,
          style: textColor == null
              ? Theme.of(context).textTheme.credentialTitle
              : Theme.of(context)
                  .textTheme
                  .credentialTitle
                  .copyWith(color: textColor),
        );
      }
    }
    return const SizedBox.shrink();
  }
}
