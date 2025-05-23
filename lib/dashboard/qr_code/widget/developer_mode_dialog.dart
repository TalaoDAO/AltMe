import 'package:altme/ai/widget/ai_request_analysis_button.dart';
import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DeveloperModeDialog extends StatelessWidget {
  const DeveloperModeDialog({
    super.key,
    required this.onDisplay,
    required this.onSkip,
    this.uri,
  });

  final VoidCallback onDisplay;
  final VoidCallback onSkip;
  final Uri? uri;

  @override
  Widget build(BuildContext context) {
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
      content: SizedBox(
        width: MediaQuery.of(context).size.shortestSide * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              IconStrings.cardReceive,
              width: 50,
              height: 50,
              color: textColor,
            ),
            const SizedBox(height: 15),
            Text(
              // ignore: lines_longer_than_80_chars
              l10n.toStopDisplayingThisPopupDeactivateTheDeveloperModeInTheSettings,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (uri != null && Parameters.isAIServiceEnabled)
              Column(
                children: [
                  AiRequestAnalysisButton(
                    link: uri!.toString(),
                  ),
                  const SizedBox(height: Sizes.spaceSmall),
                ],
              )
            else
              const SizedBox.shrink(),
            MyElevatedButton(
              text: l10n.display,
              verticalSpacing: 14,
              fontSize: 15,
              elevation: 0,
              onPressed: onDisplay,
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
      ),
    );
  }
}
