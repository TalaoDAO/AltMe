import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnBoardingTosState', () {
    test('copyWith method should create a new instance with updated values',
        () {
      const state = OnBoardingTosState(
        agreeTerms: true,
        scrollIsOver: false,
        readTerms: true,
        acceptanceButtonEnabled: false,
      );

      final newState =
          state.copyWith(scrollIsOver: true, acceptanceButtonEnabled: true);

      expect(newState, isNot(same(state)));
      expect(newState.scrollIsOver, true);
      expect(newState.acceptanceButtonEnabled, true);
      expect(newState.agreeTerms, true);
      expect(newState.readTerms, true);
    });

    test(
        'toJson and fromJson methods should serialize and deserialize correctly',
        () {
      const state = OnBoardingTosState(
        agreeTerms: true,
        scrollIsOver: false,
        readTerms: true,
        acceptanceButtonEnabled: false,
      );

      final json = state.toJson();
      final newState = OnBoardingTosState.fromJson(json);

      expect(newState, equals(state));
    });

    test('props should return correct list of properties', () {
      const state = OnBoardingTosState(
        agreeTerms: true,
        scrollIsOver: false,
        readTerms: true,
        acceptanceButtonEnabled: false,
      );

      expect(state.props, [true, false, true, false]);
    });
  });
}
