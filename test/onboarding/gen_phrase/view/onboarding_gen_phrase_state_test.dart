import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnBoardingGenPhraseState', () {
    test('toJson/fromJson works correctly', () {
      const state = OnBoardingGenPhraseState(
        status: AppStatus.loading,
        isTicked: true,
      );
      final json = state.toJson();
      final newState = OnBoardingGenPhraseState.fromJson(json);

      expect(newState, state);
    });

    test('loading returns correct state', () {
      final state = const OnBoardingGenPhraseState().loading();
      expect(state.status, AppStatus.loading);
      expect(state.isTicked, false);
    });

    test('error returns correct state', () {
      final messageHandler = ResponseMessage(
        message: ResponseString
            .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER,
      );

      final state = const OnBoardingGenPhraseState().error(
        messageHandler: messageHandler,
      );

      expect(state.status, AppStatus.error);
      expect(state.message, StateMessage.error(messageHandler: messageHandler));
      expect(state.isTicked, false);
    });

    test('success returns correct state', () {
      final messageHandler = ResponseMessage();
      final state = const OnBoardingGenPhraseState().success(
        messageHandler: messageHandler,
      );

      expect(state.status, AppStatus.success);
      expect(
        state.message,
        StateMessage.success(messageHandler: messageHandler),
      );
      expect(state.isTicked, false);
    });
  });
}
