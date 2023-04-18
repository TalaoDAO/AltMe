import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.cancelButton,
    required this.deleteButton,
    this.cancelCallback,
    this.margin = EdgeInsets.zero,
  });

  final Widget cancelButton;
  final Widget deleteButton;
  final EdgeInsets margin;

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
        margin: margin,
        child: passCode.isEmpty ? cancelButton : deleteButton,
      ),
    );
  }
}
