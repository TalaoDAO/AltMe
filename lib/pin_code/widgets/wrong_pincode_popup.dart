import 'package:altme/app/shared/constants/icon_strings.dart';
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

    return ConfirmDialog(
      icon: IconStrings.alert,
      title: l10n.userPinIsIncorrect,
      subtitle: l10n.codeSecretIncorrectDescription(
        loginAttemptsRemaining,
        loginAttemptsRemaining == 1 ? '' : 's',
      ),
      yes: l10n.tryAgain,
    );
  }
}
