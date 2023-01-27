import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CredentialDynamicDetial extends StatelessWidget {
  const CredentialDynamicDetial({
    super.key,
    required this.title,
    required this.value,
    this.titleColor,
    this.valueColor,
    this.padding = const EdgeInsets.all(8),
    required this.format,
  });

  final String? title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;
  final EdgeInsetsGeometry padding;
  final String? format;

  @override
  Widget build(BuildContext context) {
    String valueData = value;

    if (format != null) {
      if (format == AltMeStrings.date) {
        if (DateTime.tryParse(value) != null) {
          final DateTime dt = DateTime.parse(value);
          valueData = UiDate.formatDate(dt);
        }
      }

      if (format == AltMeStrings.time) {
        final String? time = UiDate.formatTime(value);
        if (time != null) {
          valueData = time;
        }
      }
    }

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

    return Padding(
      padding: padding,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(text: '$title: ', style: titleTheme),
            TextSpan(
              text: (format != null && format == AltMeStrings.uri)
                  ? context.l10n.link
                  : valueData,
              style: (format != null &&
                      (format == AltMeStrings.uri ||
                          format == AltMeStrings.email))
                  ? valueTheme.copyWith(
                      color: Theme.of(context).colorScheme.markDownA,
                    )
                  : valueTheme,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (format != null) {
                    if (format == AltMeStrings.uri) {
                      await LaunchUrl.launch(valueData);
                    } else if (format == AltMeStrings.email) {
                      await LaunchUrl.launch('mailto:$valueData');
                    }
                  }
                },
            ),
            if (format != null && format == AltMeStrings.uri)
              WidgetSpan(
                child: TransparentInkWell(
                  onTap: () async {
                    await LaunchUrl.launch(valueData);
                  },
                  child: ImageIcon(
                    const AssetImage(IconStrings.link),
                    color: Theme.of(context).colorScheme.markDownA,
                    size: 17,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
