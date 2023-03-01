part of 'pin_code_view_cubit.dart';

class PinCodeViewState extends Equatable {
  const PinCodeViewState({
    this.enteredPasscode = '',
  });

  final String enteredPasscode;

  PinCodeViewState copyWith({String? enteredPasscode}) {
    return PinCodeViewState(
      enteredPasscode: enteredPasscode ?? this.enteredPasscode,
    );
  }

  @override
  List<Object?> get props => [enteredPasscode];
}
