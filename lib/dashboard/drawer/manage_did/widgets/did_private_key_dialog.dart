import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DIDPrivateKeyDialog extends StatelessWidget {
  const DIDPrivateKeyDialog({Key? key, this.onContinueClick}) : super(key: key);

  final VoidCallback? onContinueClick;

  static void show({
    required BuildContext context,
    VoidCallback? onContinueClick,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => DIDPrivateKeyDialog(
        onContinueClick: onContinueClick,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceNormal,
        vertical: Sizes.spaceSmall,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogCloseButton(),
            const SizedBox(height: Sizes.spaceSmall),
            Text(
              l10n.didPrivateKey,
              style: Theme.of(context).textTheme.defaultDialogTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Text(
              l10n.didPrivateKeyDescriptionAlert,
              style: Theme.of(context).textTheme.defaultDialogBody,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Padding(
              padding: const EdgeInsets.all(Sizes.spaceNormal),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: MyOutlinedButton(
                      text: l10n.cancel.toUpperCase(),
                      verticalSpacing: 15,
                      fontSize: 15,
                      borderRadius: 12,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: Sizes.spaceNormal,
                  ),
                  Expanded(
                    child: MyElevatedButton(
                      text: l10n.proceed.toUpperCase(),
                      verticalSpacing: 15,
                      fontSize: 15,
                      borderRadius: 12,
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
