import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

void main() {
  const digits = 6;

  late MockSecureStorageProvider storage;
  late PinCodeViewCubit cubit;

  setUp(() {
    storage = MockSecureStorageProvider();
    when(() => storage.set(any(), any())).thenAnswer((_) async {});
    cubit = PinCodeViewCubit(secureStorageProvider: storage);
  });

  tearDown(() => cubit.close());

  Future<void> type(String code, {bool isNewCode = true}) async {
    for (final digit in code.split('')) {
      await cubit.onKeyboardButtonPressed(
        text: digit,
        passwordDigits: digits,
        isNewCode: isNewCode,
      );
    }
  }

  group('PinCodeViewCubit with a 6 digit PIN', () {
    group('isPincodeSequence', () {
      test('rejects 6 ascending or descending digits', () {
        for (final code in ['123456', '234567', '456789', '654321', '987654']) {
          expect(
            cubit.isPincodeSequence(digit: code, passwordDigits: digits),
            isTrue,
            reason: code,
          );
        }
      });

      test('accepts a 6 digit code that is not a sequence', () {
        for (final code in ['123450', '123465', '135791', '121212', '482915']) {
          expect(
            cubit.isPincodeSequence(digit: code, passwordDigits: digits),
            isFalse,
            reason: code,
          );
        }
      });

      test('does not judge a code shorter than 6 digits', () {
        expect(
          cubit.isPincodeSequence(digit: '1234', passwordDigits: digits),
          isFalse,
        );
      });
    });

    group('isPincodeSeries', () {
      test('rejects 6 identical digits', () {
        expect(
          cubit.isPincodeSeries(digit: '000000', passwordDigits: digits),
          isTrue,
        );
        expect(
          cubit.isPincodeSeries(digit: '777777', passwordDigits: digits),
          isTrue,
        );
      });

      test('accepts 6 digits that are not all identical', () {
        expect(
          cubit.isPincodeSeries(digit: '777778', passwordDigits: digits),
          isFalse,
        );
      });
    });

    group('onKeyboardButtonPressed', () {
      test('keeps collecting digits until the 6th one', () async {
        await type('48291');

        expect(cubit.state.enteredPasscode, '48291');
        expect(cubit.state.pinCodeError, PinCodeErrors.none);
        verifyNever(() => storage.set(any(), any()));
      });

      test('stores a valid new 6 digit PIN on the 6th digit', () async {
        await type('482915');

        expect(cubit.state.enteredPasscode, '482915');
        expect(cubit.state.pinCodeError, PinCodeErrors.none);
        verify(
          () => storage.set(SecureStorageKeys.pinCode, '482915'),
        ).called(1);
      });

      test('flags 6 identical digits as a series and clears them', () async {
        await type('111111');

        expect(cubit.state.enteredPasscode, isEmpty);
        expect(cubit.state.pinCodeError, PinCodeErrors.errorSerie);
        verifyNever(() => storage.set(any(), any()));
      });

      test('flags 6 successive digits as a sequence and clears them', () async {
        await type('123456');

        expect(cubit.state.enteredPasscode, isEmpty);
        expect(cubit.state.pinCodeError, PinCodeErrors.errorSequence);
        verifyNever(() => storage.set(any(), any()));
      });

      test('accepts 4 identical digits followed by two others', () async {
        await type('111123');

        expect(cubit.state.enteredPasscode, '111123');
        expect(cubit.state.pinCodeError, PinCodeErrors.none);
      });

      test('accepts the stored PIN once its 6 digits are entered', () async {
        when(
          () => storage.get(SecureStorageKeys.pinCode),
        ).thenAnswer((_) async => '482915');

        await type('482915', isNewCode: false);

        expect(cubit.state.enteredPasscode, '482915');
        expect(cubit.state.pinCodeError, PinCodeErrors.none);
      });

      test('rejects a wrong PIN and counts the attempt', () async {
        when(
          () => storage.get(SecureStorageKeys.pinCode),
        ).thenAnswer((_) async => '482915');

        await type('482916', isNewCode: false);

        expect(cubit.state.enteredPasscode, isEmpty);
        expect(cubit.state.pinCodeError, PinCodeErrors.errorPinCode);
        expect(cubit.state.loginAttemptCount, 1);
      });
    });
  });
}
