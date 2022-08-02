import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class FinishKycDialog extends StatelessWidget {
  const FinishKycDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogCloseButton(),
            const SizedBox(height: Sizes.spaceSmall),
            Icon(
              Icons.access_time_filled_rounded,
              size: Sizes.icon4x,
              color: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Text(
              l10n.finishedVerificationTitle,
              style: Theme.of(context).textTheme.finishVerificationDialogTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Text(
              l10n.finishedVerificationDescription,
              style: Theme.of(context).textTheme.finishVerificationDialogBody,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceSmall),
          ],
        ),
      ),
    );
  }
}
