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

    /// be careful, BaseBottomSheet is a custom widget from jeprouvemonage 
    return BaseBottomSheet(
      body: Column(
        children: [
          Image.asset(
            ImageStrings.warningCircle,
            width: Sizes.icon80,
          ),
          const SizedBox(
            height: Sizes.spaceLarge,
          ),
          Text(
            l10n.codeSecretIncorrect,
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
