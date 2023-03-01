import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumKeyboard extends StatelessWidget {
  const NumKeyboard({
    super.key,
    KeyboardUIConfig? keyboardUIConfig,
    this.passwordDigits = 4,
    required this.passwordEnteredCallback,
    this.cancelCallback,
    required this.allowAction,
  }) : keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig();

  final KeyboardUIConfig keyboardUIConfig;
  final int passwordDigits;
  final PasswordEnteredCallback passwordEnteredCallback;
  final CancelCallback? cancelCallback;
  final bool allowAction;

  @override
  Widget build(BuildContext context) {
    return NumericKeyboard(
      allowAction: allowAction,
      onKeyboardTap: (text) {
        if (!allowAction) return;
        context.read<PinCodeViewCubit>().onKeyboardButtonPressed(
              passwordDigits: passwordDigits,
              passwordEnteredCallback: passwordEnteredCallback,
              text: text,
              cancelCallback: cancelCallback,
            );
      },
      keyboardUIConfig: keyboardUIConfig,
    );
  }
}
