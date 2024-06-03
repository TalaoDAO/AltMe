import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class WrongPinCodePopUp extends StatelessWidget {
  const WrongPinCodePopUp({
    super.key,
    required this.loginAttemptsRemaining,
  });

  final int loginAttemptsRemaining;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      body: Column(
        children: [
          Image.asset(
            ImageStrings.cardMissing,
            width: Sizes.icon,
          ),
          const SizedBox(
            height: Sizes.spaceLarge,
          ),
          Text(
            l10n.userPinIsIncorrect,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: Sizes.spaceXSmall,
          ),
          Text(
            l10n.codeSecretIncorrectDescription(
              loginAttemptsRemaining,
              loginAttemptsRemaining == 1 ? '' : 's',
            ),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: Sizes.spaceLarge,
          ),
          MyElevatedButton(
            text: l10n.tryAgain,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
