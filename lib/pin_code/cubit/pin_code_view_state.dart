part of 'pin_code_view_cubit.dart';

class PinCodeViewState extends Equatable {
  const PinCodeViewState({
    this.enteredPasscode = '',
    this.loginAttemptCount = 0,
    this.loginAttemptsRemaining = 3,
    this.allowAction = true,
    this.isPincodeSequence = false,
    this.isPincodeSeries = false,
    this.isPinCodeValid = false,
  });

  final String enteredPasscode;
  final int loginAttemptCount;
  final int loginAttemptsRemaining;
  final bool allowAction;
  final bool isPincodeSeries;
  final bool isPincodeSequence;
  final bool isPinCodeValid;

  PinCodeViewState copyWith({
    String? enteredPasscode,
    int? loginAttemptCount,
    int? loginAttemptsRemaining,
    bool? allowAction,
    bool? isPincodeSequence,
    bool? isPincodeSeries,
    bool? isPinCodeValid,
  }) {
    return PinCodeViewState(
      enteredPasscode: enteredPasscode ?? this.enteredPasscode,
      loginAttemptCount: loginAttemptCount ?? this.loginAttemptCount,
      loginAttemptsRemaining:
          loginAttemptsRemaining ?? this.loginAttemptsRemaining,
      allowAction: allowAction ?? this.allowAction,
      isPincodeSequence: isPincodeSequence ?? this.isPincodeSequence,
      isPincodeSeries: isPincodeSeries ?? this.isPincodeSeries,
      isPinCodeValid: isPinCodeValid ?? this.isPinCodeValid,
    );
  }

  @override
  List<Object?> get props => [
        enteredPasscode,
        loginAttemptCount,
        allowAction,
        loginAttemptsRemaining,
        isPincodeSequence,
        isPincodeSeries,
        isPinCodeValid,
      ];
}
