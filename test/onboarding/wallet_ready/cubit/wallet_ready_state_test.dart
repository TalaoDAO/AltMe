import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WalletReadyState', () {
    test('can be serialized to JSON', () {
      const state = WalletReadyState(isAgreeWithTerms: true);
      expect(state.toJson(), {'isAgreeWithTerms': true});
    });

    test('can be deserialized from JSON', () {
      final json = {'isAgreeWithTerms': true};
      expect(
        WalletReadyState.fromJson(json),
        const WalletReadyState(isAgreeWithTerms: true),
      );
    });

    test('copyWith returns a new instance with updated values', () {
      const state = WalletReadyState(isAgreeWithTerms: false);
      final newState = state.copyWith(isAgreeWithTerms: true);

      expect(newState.isAgreeWithTerms, true);
      expect(newState, isNot(state));
    });

    test('copyWith maintains the same values if no parameters are passed', () {
      const state = WalletReadyState(isAgreeWithTerms: false);
      final newState = state.copyWith();

      expect(newState.isAgreeWithTerms, false);
      expect(newState, isNot(same(state)));
    });
  });
}
