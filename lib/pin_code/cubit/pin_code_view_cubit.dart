import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:secure_storage/secure_storage.dart';

part 'pin_code_view_state.dart';

class PinCodeViewCubit extends Cubit<PinCodeViewState> {
  PinCodeViewCubit({
    this.totalPermitedLoginAttempt = 3,
  }) : super(const PinCodeViewState());

  final int totalPermitedLoginAttempt;

  void loginAttempt() {
    final loginAttemptCount = state.loginAttemptCount + 1;
    final loginAttemptsRemaining =
        totalPermitedLoginAttempt - state.loginAttemptCount - 1;
    const allowAction = true;
    // if (loginAttemptCount >= totalPermitedLoginAttempt) {
    //   allowAction = false;
    //   _startLockTimer();
    // }
    emit(
      state.copyWith(
        loginAttemptCount: loginAttemptCount,
        loginAttemptsRemaining: loginAttemptsRemaining,
        allowAction: allowAction,
      ),
    );
  }

  Timer? _timer;

  void _startLockTimer() {
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _resetloginAttemptCount();
      _timer?.cancel();
    });
  }

  void _resetloginAttemptCount() {
    emit(
      state.copyWith(
        loginAttemptCount: 0,
        allowAction: true,
        loginAttemptsRemaining: totalPermitedLoginAttempt,
      ),
    );
  }

  void setEnteredPasscode(String enteredPasscode) {
    emit(
      state.copyWith(
        enteredPasscode: enteredPasscode,
      ),
    );
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
            emit(
              state.copyWith(
                isPincodeSeries: true,
                enteredPasscode: passCode,
              ),
            );
            return;
          }
          if (isPincodeSequence(
            digit: passCode,
            passwordDigits: passwordDigits,
          )) {
            emit(
              state.copyWith(
                isPincodeSequence: true,
                enteredPasscode: passCode,
              ),
            );
            return;
          }
          await getSecureStorage.set(SecureStorageKeys.pinCode, passCode);
        } else {
          final isValid =
              (await getSecureStorage.get(SecureStorageKeys.pinCode)) ==
                  passCode;
          if (!isValid) {
            setEnteredPasscode(passCode);
            loginAttempt();
            return;
          }
        }
        emit(
          state.copyWith(
            isPinCodeValid: true,
            enteredPasscode: passCode,
          ),
        );

// on new pincode
        // void _onPasscodeEntered(String enteredPasscode) {
        //   Navigator.pushReplacement<dynamic, dynamic>(
        //     context,
        //     ConfirmPinCodePage.route(
        //       storedPassword: enteredPasscode,
        //       isValidCallback: widget.isValidCallback,
        //       isFromOnboarding: widget.isFromOnboarding,
        //     ),
        //   );
        // }
      } else {
        setEnteredPasscode(passCode);
      }
    } else {
      emit(
        state.copyWith(
          enteredPasscode: text,
          isPincodeSequence: false,
          isPincodeSeries: false,
        ),
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
      // test if pin code is a serie asc or desc
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
