import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class BeCarefulDialog extends StatelessWidget {
  const BeCarefulDialog({
    super.key,
    this.onContinueClick,
    required this.title,
    this.subtitle,
    this.yes,
    this.no,
  });

  final VoidCallback? onContinueClick;
  final String title;
  final String? subtitle;
  final String? yes;
  final String? no;

  static void show({
    required BuildContext context,
    VoidCallback? onContinueClick,
    required String title,
    String? subtitle,
    String? yes,
    String? no,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => BeCarefulDialog(
        onContinueClick: onContinueClick,
        title: title,
        subtitle: subtitle,
        yes: yes,
        no: no,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceNormal,
        vertical: Sizes.spaceSmall,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.shortestSide * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogCloseButton(
              showText: false,
              color: Theme.of(context).colorScheme.surface,
            ),
            Image.asset(
              IconStrings.alert,
              width: Sizes.icon4x,
            ),
            Text(
              l10n.beCareful,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: Sizes.spaceSmall),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: Sizes.spaceSmall),
            Padding(
              padding: const EdgeInsets.all(Sizes.space2XSmall),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: MyOutlinedButton(
                      text: no ?? l10n.no,
                      verticalSpacing: 15,
                      fontSize: 15,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceXSmall),
                  Expanded(
                    child: MyElevatedButton(
                      text: yes ?? l10n.yes,
                      verticalSpacing: 15,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onContinueClick?.call();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
