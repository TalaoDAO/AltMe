import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ErrorDetailsDialog extends StatelessWidget {
  const ErrorDetailsDialog({
    super.key,
    this.erroDescription,
    this.erroUrl,
    this.icon = IconStrings.alert,
    this.dialogColor,
    this.bgColor,
    this.textColor,
  });

  final String? erroDescription;
  final String? erroUrl;
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
          ),
          const SizedBox(height: 25),
          if (erroDescription != null) ...[
            Text(
              erroDescription!,
              style: Theme.of(context)
                  .textTheme
                  .defaultDialogSubtitle
                  .copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
          if (erroUrl != null) ...[
            const SizedBox(height: Sizes.spaceXSmall),
            TransparentInkWell(
              onTap: () async {
                await LaunchUrl.launch(erroUrl!);
              },
              child: Text(
                l10n.moreDetails,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.markDownA,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.markDownA,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 24),
          MyElevatedButton(
            text: l10n.ok,
            verticalSpacing: 14,
            backgroundColor: color,
            borderRadius: Sizes.smallRadius,
            fontSize: 15,
            elevation: 0,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
