import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.yes,
    this.no,
    this.icon = IconStrings.cardReceive,
    this.dialogColor,
    this.bgColor,
    this.textColor,
    this.showNoButton = true,
  });

  final String title;
  final String? subtitle;
  final String? yes;
  final String? no;
  final Color? dialogColor;
  final Color? bgColor;
  final Color? textColor;
  final String icon;
  final bool showNoButton;

  @override
  Widget build(BuildContext context) {
    final background =
        bgColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final textColor = this.textColor ?? Theme.of(context).colorScheme.onSurface;

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
          Image.asset(
            icon,
            width: 50,
            height: 50,
            color: icon == IconStrings.cardReceive ? textColor : null,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.spaceSmall),
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (showNoButton) ...[
                Expanded(
                  child: MyOutlinedButton(
                    text: no ?? l10n.no,
                    verticalSpacing: 14,
                    fontSize: 15,
                    elevation: 0,
                    textColor: Theme.of(context)
                        .colorScheme
                        .defualtDialogCancelButtonTextColor,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: MyElevatedButton(
                  text: yes ?? l10n.yes,
                  verticalSpacing: 14,
                  fontSize: 15,
                  elevation: 0,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
