import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
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
  });

  final String title;
  final String? subtitle;
  final String? yes;
  final String? no;
  final Color? dialogColor;
  final Color? bgColor;
  final Color? textColor;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final color = dialogColor ?? Theme.of(context).colorScheme.primary;
    final background = bgColor ?? Theme.of(context).colorScheme.popupBackground;
    final textColor =
        this.textColor ?? Theme.of(context).colorScheme.dialogText;

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
            color: color,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .defaultDialogTitle
                .copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.spaceXSmall),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .defaultDialogSubtitle
                  .copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: MyOutlinedButton(
                  text: no ?? l10n.no,
                  verticalSpacing: 8,
                  fontSize: 13,
                  borderColor: color,
                  backgroundColor: background,
                  textColor: color,
                  elevation: 0,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MyElevatedButton(
                  text: yes ?? l10n.yes,
                  verticalSpacing: 8,
                  backgroundColor: color,
                  textColor: background,
                  fontSize: 13,
                  elevation: 0,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
