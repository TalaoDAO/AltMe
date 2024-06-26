import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiscoverDynamicDetial extends StatelessWidget {
  const DiscoverDynamicDetial({
    super.key,
    required this.title,
    required this.value,
    this.padding = const EdgeInsets.all(8),
    this.format,
  });

  final String? title;
  final String value;
  final EdgeInsetsGeometry padding;
  final String? format;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final titleTheme = textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );
    final valueTheme = textTheme.bodyMedium!;

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
                  : value,
              style: valueTheme,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (format != null) {
                    if (format == AltMeStrings.uri) {
                      await LaunchUrl.launch(value);
                    }
                  }
                },
            ),
            if (format != null && format == AltMeStrings.uri)
              WidgetSpan(
                child: TransparentInkWell(
                  onTap: () async {
                    await LaunchUrl.launch(value);
                  },
                  child: ImageIcon(
                    const AssetImage(IconStrings.link),
                    color: Theme.of(context).colorScheme.primary,
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
