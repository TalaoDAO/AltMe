import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DefaultDialog extends StatelessWidget {
  const DefaultDialog({
    super.key,
    required this.title,
    required this.description,
    this.buttonLabel,
    this.onButtonClick,
  });

  final String title;
  final String description;
  final String? buttonLabel;
  final VoidCallback? onButtonClick;

  @override
  Widget build(BuildContext context) {
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
              title,
              style: Theme.of(context).textTheme.defaultDialogTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Text(
              description,
              style: Theme.of(context).textTheme.defaultDialogBody,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            if (buttonLabel != null)
              MyElevatedButton(
                text: buttonLabel!,
                verticalSpacing: 18,
                fontSize: 18,
                borderRadius: 20,
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pop();
                  onButtonClick?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}
