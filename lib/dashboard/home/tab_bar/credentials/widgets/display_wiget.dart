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
    final textTheme = Theme.of(context).textTheme.bodyMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (display.description != null)
          DescriptionText(
            text: display.description!,
            titleTheme: textTheme!.copyWith(fontWeight: FontWeight.bold),
            valueTheme: textTheme,
          ),
      ],
    );
  }
}
