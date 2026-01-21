import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumKeyboard extends StatelessWidget {
  const NumKeyboard({
    super.key,
    KeyboardUIConfig? keyboardUIConfig,
    this.passwordDigits = 4,
    this.cancelCallback,
    required this.allowAction,
    this.isNewCode = false,
    required this.keyboardButton,
  }) : keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig();

  final KeyboardUIConfig keyboardUIConfig;
  final int passwordDigits;
  final CancelCallback? cancelCallback;
  final bool allowAction;
  final bool isNewCode;
  final Widget keyboardButton;
  @override
  Widget build(BuildContext context) {
    return NumericKeyboard(
      allowAction: true,
      onKeyboardTap: (text) {
        if (!allowAction) return;
        context.read<PinCodeViewCubit>().onKeyboardButtonPressed(
          passwordDigits: passwordDigits,
          text: text,
          cancelCallback: cancelCallback,
          isNewCode: isNewCode,
        );
      },
      keyboardUIConfig: keyboardUIConfig,
      trailingButton: keyboardButton,
    );
  }
}
