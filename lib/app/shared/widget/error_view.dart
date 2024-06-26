import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onTap});

  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      // ignore: require_trailing_commas
      children: [
        Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: Sizes.spaceSmall),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: MyOutlinedButton(
            text: l10n.tryAgain,
            backgroundColor: Colors.transparent,
            onPressed: onTap,
            fontSize: 14,
            verticalSpacing: 10,
          ),
        ),
      ],
    );
  }
}
