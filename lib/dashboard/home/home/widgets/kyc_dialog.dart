import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class KycDialog extends StatelessWidget {
  const KycDialog({
    super.key,
    required this.startVerificationPressed,
  });

  final VoidCallback startVerificationPressed;

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
            const SizedBox(height: 15),
            Text(
              l10n.kycDialogTitle,
              style: Theme.of(context).textTheme.kycDialogTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceLarge),
            Text(
              l10n.idVerificationProcess,
              style: Theme.of(context).textTheme.kycDialogBodySmall,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.spaceNormal,
                vertical: Sizes.spaceXSmall,
              ),
              child: Divider(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(
                      IconStrings.checkCircleBlue,
                      width: Sizes.icon,
                    ),
                    Text(
                      l10n.idCheck,
                      style: Theme.of(context).textTheme.kycDialogBody,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(width: Sizes.spaceNormal),
                Row(
                  children: [
                    Image.asset(
                      IconStrings.checkCircleBlue,
                      width: Sizes.icon,
                    ),
                    Text(
                      l10n.facialRecognition,
                      style: Theme.of(context).textTheme.kycDialogBody,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: Sizes.spaceLarge,
            ),
            MyElevatedButton(
              text: l10n.kycDialogButton.toUpperCase(),
              verticalSpacing: 18,
              fontSize: 18,
              borderRadius: 20,
              backgroundColor:
                  Theme.of(context).colorScheme.kycVerifyButtonColor,
              onPressed: () {
                Navigator.of(context).pop();
                startVerificationPressed.call();
              },
            ),
            const SizedBox(
              height: Sizes.spaceSmall,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  IconStrings.lockCircle,
                  width: Sizes.icon,
                ),
                Text(
                  l10n.kycDialogFooter,
                  style: Theme.of(context).textTheme.kycDialogFooter,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
