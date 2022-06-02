part of 'pin_code_view_cubit.dart';

class PinCodeViewState {
  PinCodeViewState({this.enteredPasscode = ''});

  final String enteredPasscode;

  PinCodeViewState copyWith(String? enteredPasscode) {
    return PinCodeViewState(
      enteredPasscode: enteredPasscode ?? this.enteredPasscode,
    );
  }
}
