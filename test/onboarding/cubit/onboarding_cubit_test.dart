import 'package:altme/app/app.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingCubit', () {
    test('initial state is correct', () {
      expect(OnboardingCubit().state, const OnboardingState());
    });

    blocTest<OnboardingCubit, OnboardingState>(
      'emits [loading] when emitOnboardingProcessing is called',
      build: OnboardingCubit.new,
      act: (cubit) => cubit.emitOnboardingProcessing(),
      expect: () => [const OnboardingState(status: AppStatus.loading)],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'emits [success] when emitOnboardingDone is called',
      build: OnboardingCubit.new,
      act: (cubit) => cubit.emitOnboardingDone(),
      expect: () => [const OnboardingState(status: AppStatus.success)],
    );
  });
}
