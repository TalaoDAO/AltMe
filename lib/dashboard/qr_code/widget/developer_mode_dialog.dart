import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DeveloperModeDialog extends StatelessWidget {
  const DeveloperModeDialog({
    super.key,
    required this.onDisplay,
    required this.onDownload,
    required this.onSkip,
  });

  final VoidCallback onDisplay;
  final VoidCallback onDownload;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final background = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;

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
            IconStrings.cardReceive,
            width: 50,
            height: 50,
            color: textColor,
          ),
          const SizedBox(height: 15),
          MyElevatedButton(
            text: l10n.display,
            verticalSpacing: 14,
            fontSize: 15,
            elevation: 0,
            onPressed: onDisplay,
          ),
          const SizedBox(height: Sizes.spaceSmall),
          MyElevatedButton(
            text: l10n.download,
            verticalSpacing: 14,
            fontSize: 15,
            elevation: 0,
            onPressed: onDownload,
          ),
          const SizedBox(height: Sizes.spaceSmall),
          MyElevatedButton(
            text: l10n.skip,
            verticalSpacing: 14,
            fontSize: 15,
            elevation: 0,
            onPressed: onSkip,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
