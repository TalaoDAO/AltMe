import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pin_code_view_state.dart';

class PinCodeViewCubit extends Cubit<PinCodeViewState> {
  PinCodeViewCubit({
    required this.profileCubit,
  }) : super(const PinCodeViewState());

  final ProfileCubit profileCubit;

  void setEnteredPasscode(String enteredPasscode) {
    emit(state.copyWith(enteredPasscode: enteredPasscode));
  }

  void onDeleteCancelButtonPressed(CancelCallback? cancelCallback) {
    final enteredPasscode = state.enteredPasscode;
    if (enteredPasscode.isNotEmpty) {
      setEnteredPasscode(
        enteredPasscode.substring(0, enteredPasscode.length - 1),
      );
    } else {
      if (cancelCallback != null) {
        cancelCallback.call();
      }
    }
  }

  void onKeyboardButtonPressed({
    required String text,
    CancelCallback? cancelCallback,
    required int passwordDigits,
    required PasswordEnteredCallback passwordEnteredCallback,
  }) {
    final enteredPasscode = state.enteredPasscode;
    if (text == NumericKeyboard.deleteButton) {
      onDeleteCancelButtonPressed(cancelCallback);
      return;
    }
    if (enteredPasscode.length < passwordDigits) {
      final passCode = enteredPasscode + text;
      setEnteredPasscode(passCode);
      if (passCode.length == passwordDigits) {
        passwordEnteredCallback(passCode);
      }
    }
  }
}
