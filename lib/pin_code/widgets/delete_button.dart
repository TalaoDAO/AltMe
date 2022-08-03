import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
    required this.cancelButton,
    required this.deleteButton,
    KeyboardUIConfig? keyboardUIConfig,
    this.cancelCallback,
  })  : keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig(),
        super(key: key);

  final Widget cancelButton;
  final Widget deleteButton;
  final KeyboardUIConfig keyboardUIConfig;

  final CancelCallback? cancelCallback;

  @override
  Widget build(BuildContext context) {
    final PinCodeViewCubit pinCodeViewCubit = context.read<PinCodeViewCubit>();
    final passCode = pinCodeViewCubit.state.enteredPasscode;
    return CupertinoButton(
      onPressed: () => context
          .read<PinCodeViewCubit>()
          .onDeleteCancelButtonPressed(cancelCallback),
      child: Container(
        margin: keyboardUIConfig.digitInnerMargin,
        child: passCode.isEmpty ? cancelButton : deleteButton,
      ),
    );
  }
}
