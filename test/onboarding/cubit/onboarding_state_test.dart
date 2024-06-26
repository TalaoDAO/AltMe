import 'package:altme/app/app.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingState', () {
    test('can be instantiated from JSON', () {
      final json = {'status': 'init'};

      final onboardingState = OnboardingState.fromJson(json);

      expect(onboardingState.status, AppStatus.init);
    });

    test('can be converted to JSON', () {
      const onboardingState = OnboardingState(status: AppStatus.init);
      final json = onboardingState.toJson();

      expect(json, {'status': 'init'});
    });
  });
}
