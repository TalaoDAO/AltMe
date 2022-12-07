import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/transparent_ink_well.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayDescriptionWidgetWithTitle extends StatelessWidget {
  const DisplayDescriptionWidgetWithTitle({
    this.displayMapping,
    required this.credentialModel,
    this.titleColor,
    this.valueColor,
    Key? key,
  }) : super(key: key);
  final DisplayMapping? displayMapping;
  final CredentialModel credentialModel;
  final Color? titleColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final object = displayMapping;

    final textTheme = Theme.of(context).textTheme;
    final titleTheme = titleColor == null
        ? textTheme.credentialFieldTitle
        : textTheme.credentialFieldTitle.copyWith(color: titleColor);
    final valueTheme = valueColor == null
        ? Theme.of(context).textTheme.credentialFieldDescription
        : Theme.of(context)
            .textTheme
            .credentialFieldDescription
            .copyWith(color: valueColor);

    if (object is DisplayMappingText) {
      return DescriptionText(
        //padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        text: object.text,
        titleTheme: titleTheme,
        valueTheme: valueTheme,
      );
    }

    if (object is DisplayMappingPath) {
      final textList = <String>[];
      for (final e in object.path) {
        textList.addAll(getTextsFromCredential(e, credentialModel.data));
      }
      if (textList.isNotEmpty) {
        return DescriptionText(
          text: textList.first,
          titleTheme: titleTheme,
          valueTheme: valueTheme,
        );
      }
      if (object.fallback != null) {
        return DescriptionText(
          text: object.fallback ?? '',
          titleTheme: titleTheme,
          valueTheme: valueTheme,
        );
      }
    }

    return const SizedBox.shrink();
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    Key? key,
    required this.text,
    required this.titleTheme,
    required this.valueTheme,
  }) : super(key: key);

  final String text;
  final TextStyle titleTheme;
  final TextStyle valueTheme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TransparentInkWell(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (context) => DescriptionDialog(text: text),
        );
      },
      child: RichText(
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        maxLines: 200,
        textAlign: TextAlign.left,
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '${l10n.credentialManifestDescription}: ',
              style: titleTheme,
            ),
            TextSpan(
              text: text,
              style: valueTheme,
              //recognizer: TapGestureRecognizer()..onTap = () async {},
            ),
          ],
        ),
      ),
    );
  }
}
