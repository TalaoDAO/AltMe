import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/home/home.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayTitleWidget extends StatelessWidget {
  const DisplayTitleWidget(
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
      final textList = <String>[];
      for (final e in object.path) {
        textList.addAll(getTextsFromCredential(e, item.data));
      }
      if (textList.isNotEmpty) {
        return Text(
          textList.first,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: textColor == null
              ? Theme.of(context).textTheme.credentialTitle
              : Theme.of(context)
                  .textTheme
                  .credentialTitle
                  .copyWith(color: textColor),
        );
      }
      if (object.fallback != null) {
        return Text(
          object.fallback ?? '',
          maxLines: 1,
          overflow: TextOverflow.clip,
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
