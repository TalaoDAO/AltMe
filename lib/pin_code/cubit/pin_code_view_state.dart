part of 'pin_code_view_cubit.dart';

enum PinCodeErrors {
  none,
  errorConfirmation,
  errorSequence,
  errorSerie,
  errorPinCode,
}

class PinCodeViewState extends Equatable {
  const PinCodeViewState({
    this.enteredPasscode = '',
    this.loginAttemptCount = 0,
    this.loginAttemptsRemaining = 3,
    this.allowAction = true,
    this.pinCodeError = PinCodeErrors.none,
  });

  final String enteredPasscode;
  final int loginAttemptCount;
  final int loginAttemptsRemaining;
  final PinCodeErrors pinCodeError;
  final bool allowAction;

  PinCodeViewState copyWith({
    String? enteredPasscode,
    int? loginAttemptCount,
    int? loginAttemptsRemaining,
    PinCodeErrors? pinCodeError,
    bool? allowAction,
  }) {
    return PinCodeViewState(
      enteredPasscode: enteredPasscode ?? this.enteredPasscode,
      loginAttemptCount: loginAttemptCount ?? this.loginAttemptCount,
      loginAttemptsRemaining:
          loginAttemptsRemaining ?? this.loginAttemptsRemaining,
      allowAction: allowAction ?? this.allowAction,
      pinCodeError: pinCodeError ?? this.pinCodeError,
    );
  }

  @override
  List<Object?> get props => [
        enteredPasscode,
        loginAttemptCount,
        allowAction,
        loginAttemptsRemaining,
        pinCodeError,
      ];
}
