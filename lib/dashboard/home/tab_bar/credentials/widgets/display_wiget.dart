import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DisplayWidget extends StatelessWidget {
  const DisplayWidget({
    super.key,
    required this.display,
  });

  final Display display;

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).colorScheme.titleColor;
    final valueColor = Theme.of(context).colorScheme.valueColor;

    final textTheme = Theme.of(context).textTheme;
    final titleTheme =
        textTheme.credentialFieldTitle.copyWith(color: titleColor);
    final valueTheme = Theme.of(context)
        .textTheme
        .credentialFieldDescription
        .copyWith(color: valueColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (display.descriptionFallback.isNotEmpty)
          DescriptionText(
            text: display.descriptionFallback,
            titleTheme: titleTheme,
            valueTheme: valueTheme,
          ),
      ],
    );
  }
}
