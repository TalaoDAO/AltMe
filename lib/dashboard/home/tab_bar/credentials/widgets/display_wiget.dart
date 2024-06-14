import 'package:altme/dashboard/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';

class DisplayWidget extends StatelessWidget {
  const DisplayWidget({
    super.key,
    required this.display,
  });

  final Display display;

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).colorScheme.secondaryContainer;
    final valueColor = Theme.of(context).colorScheme.onSurface;

    final textTheme = Theme.of(context).textTheme;
    final titleTheme = textTheme.bodyMedium!.copyWith(color: titleColor);
    final valueTheme =
        Theme.of(context).textTheme.bodyMedium!.copyWith(color: valueColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (display.description != null)
          DescriptionText(
            text: display.description!,
            titleTheme: titleTheme,
            valueTheme: valueTheme,
          ),
      ],
    );
  }
}
