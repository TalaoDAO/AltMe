import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:secure_storage/secure_storage.dart';

part 'pin_code_view_state.dart';

class PinCodeViewCubit extends Cubit<PinCodeViewState> {
  PinCodeViewCubit({
    required this.secureStorageProvider,
    this.totalPermitedLoginAttempt = 3,
    this.isUserPin = false,
  }) : super(const PinCodeViewState());

  final int totalPermitedLoginAttempt;
  final bool isUserPin;
  final SecureStorageProvider secureStorageProvider;

  void loginAttempt() {
    final loginAttemptCount = state.loginAttemptCount + 1;
    final loginAttemptsRemaining =
        totalPermitedLoginAttempt - state.loginAttemptCount - 1;
    const allowAction = true;

    emit(
      state.copyWith(
        loginAttemptCount: loginAttemptCount,
        loginAttemptsRemaining: loginAttemptsRemaining,
        allowAction: allowAction,
      ),
    );
  }

  void setEnteredPasscode(
    String enteredPasscode,
    PinCodeErrors newPinCodeError,
  ) {
    emit(
      state.copyWith(
        enteredPasscode: enteredPasscode,
        pinCodeError: newPinCodeError,
      ),
    );
  }

  void onDeleteCancelButtonPressed(CancelCallback? cancelCallback) {
    final enteredPasscode = state.enteredPasscode;
    if (enteredPasscode.isNotEmpty) {
      setEnteredPasscode(
        enteredPasscode.substring(0, enteredPasscode.length - 1),
        PinCodeErrors.none,
      );
    } else {
      if (cancelCallback != null) {
        cancelCallback.call();
      }
    }
  }

  Future<void> onKeyboardButtonPressed({
    required String text,
    CancelCallback? cancelCallback,
    required int passwordDigits,
    bool isNewCode = false,
  }) async {
    final enteredPasscode = state.enteredPasscode;
    if (text == NumericKeyboard.deleteButton) {
      onDeleteCancelButtonPressed(cancelCallback);
      return;
    }
    if (enteredPasscode.length < passwordDigits) {
      final passCode = enteredPasscode + text;

      if (passCode.length == passwordDigits) {
        if (isNewCode) {
          if (isPincodeSeries(
            digit: passCode,
            passwordDigits: passwordDigits,
          )) {
            setEnteredPasscode(
              '',
              PinCodeErrors.errorSerie,
            );
            return;
          }
          if (isPincodeSequence(
            digit: passCode,
            passwordDigits: passwordDigits,
          )) {
            setEnteredPasscode(
              '',
              PinCodeErrors.errorSequence,
            );
            return;
          }
          await secureStorageProvider.set(SecureStorageKeys.pinCode, passCode);
        } else {
          if (!isUserPin) {
            final isValid =
                (await secureStorageProvider.get(SecureStorageKeys.pinCode)) ==
                    passCode;
            if (!isValid) {
              emit(
                state.copyWith(
                  enteredPasscode: '',
                  pinCodeError: PinCodeErrors.errorPinCode,
                ),
              );

              loginAttempt();
              return;
            }
          }
        }
        emit(
          state.copyWith(
            pinCodeError: PinCodeErrors.none,
            enteredPasscode: passCode,
          ),
        );
      } else {
        setEnteredPasscode(
          passCode,
          PinCodeErrors.none,
        );
      }
    } else {
      setEnteredPasscode(
        text,
        PinCodeErrors.none,
      );
    }
  }

  bool areAllDigitsIdentical(String number) {
    // Convert the number to a string to easily access its digits

    // Check if all digits are the same
    for (int i = 1; i < number.length; i++) {
      if (number[i] != number[0]) {
        return false;
      }
    }

    return true;
  }

  bool isPincodeSequence({required String digit, required int passwordDigits}) {
    if (digit.length == passwordDigits) {
      bool isValidDesc = false;
      bool isValidAsc = false;
      // test if PIN code is a serie asc or desc
      for (int i = 1; i < digit.length; i++) {
        if (i > 0) {
          if (int.parse(digit[i]) != (int.parse(digit[i - 1]) + 1)) {
            isValidAsc = true;
          }
          if (int.parse(digit[i]) != (int.parse(digit[i - 1]) - 1)) {
            isValidDesc = true;
          }
        }
      }
      if (isValidAsc && isValidDesc) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  bool isPincodeSeries({required String digit, required int passwordDigits}) {
    if (digit.length == passwordDigits) {
      return areAllDigitsIdentical(digit);
    }
    return true;
  }
}
