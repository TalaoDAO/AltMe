import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnBoardingVerifyPhraseState', () {
    test('success method returns a new state with updated status and message',
        () {
      final state = OnBoardingVerifyPhraseState();
      final newState = state.success(messageHandler: ResponseMessage());

      expect(newState.status, AppStatus.success);
      expect(newState.message, isNotNull);
      expect(newState.isVerified, state.isVerified);
      expect(newState.mnemonicStates, state.mnemonicStates);
    });

    test('toJson and fromJson work correctly', () {
      final state = OnBoardingVerifyPhraseState(
        status: AppStatus.success,
        isVerified: true,
      );

      final json = state.toJson();
      final newState = OnBoardingVerifyPhraseState.fromJson(json);

      expect(state, newState);
    });
  });

  group('MnemonicState', () {
    test('toJson and fromJson work correctly', () {
      const mnemonicState = MnemonicState(
        mnemonicStatus: MnemonicStatus.selected,
        order: 1,
      );

      final json = mnemonicState.toJson();
      final newState = MnemonicState.fromJson(json);

      expect(newState, mnemonicState);
    });
  });
}
