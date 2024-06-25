import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.title,
    this.erroDescription,
    this.erroUrl,
    this.dialogColor,
    this.bgColor,
    this.textColor,
  });

  final String title;
  final String? erroDescription;
  final String? erroUrl;
  final Color? dialogColor;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final background = bgColor ?? Theme.of(context).colorScheme.onSurface;
    final textColor = this.textColor ?? Theme.of(context).colorScheme.surface;

    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (erroDescription != null || erroUrl != null) ...[
            MyOutlinedButton(
              text: l10n.moreDetails,
              verticalSpacing: 14,
              fontSize: 15,
              borderColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              backgroundColor: background,
              textColor: textColor,
              borderRadius: Sizes.smallRadius,
              elevation: 0,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) => ErrorDetailsDialog(
                    erroDescription: erroDescription,
                    erroUrl: erroUrl,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
          MyElevatedButton(
            text: l10n.ok,
            verticalSpacing: 14,
            borderRadius: Sizes.smallRadius,
            elevation: 0,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
