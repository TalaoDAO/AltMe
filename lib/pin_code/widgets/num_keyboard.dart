import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumKeyboard extends StatelessWidget {
  const NumKeyboard({
    Key? key,
    KeyboardUIConfig? keyboardUIConfig,
    this.passwordDigits = 4,
    required this.passwordEnteredCallback,
    this.cancelCallback,
  })  : keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig(),
        super(key: key);

  final KeyboardUIConfig keyboardUIConfig;
  final int passwordDigits;
  final PasswordEnteredCallback passwordEnteredCallback;
  final CancelCallback? cancelCallback;

  @override
  Widget build(BuildContext context) {
    return NumericKeyboard(
      onKeyboardTap: (text) =>
          context.read<PinCodeViewCubit>().onKeyboardButtonPressed(
                passwordDigits: passwordDigits,
                passwordEnteredCallback: passwordEnteredCallback,
                text: text,
                cancelCallback: cancelCallback,
              ),
      keyboardUIConfig: keyboardUIConfig,
    );
  }
}
