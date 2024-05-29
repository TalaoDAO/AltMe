import 'package:altme/onboarding/onboarding.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnBoardingTosCubit', () {
    late OnBoardingTosCubit onBoardingTosCubit;

    setUp(() {
      onBoardingTosCubit = OnBoardingTosCubit();
    });

    tearDown(() {
      onBoardingTosCubit.close();
    });

    test('initial state is correct', () {
      expect(onBoardingTosCubit.state, equals(const OnBoardingTosState()));
    });

    blocTest<OnBoardingTosCubit, OnBoardingTosState>(
      'emits [scrollIsOver] when setScrolledIsOver is called',
      build: () => onBoardingTosCubit,
      act: (cubit) => cubit.setScrolledIsOver(scrollIsOver: true),
      expect: () => [const OnBoardingTosState(scrollIsOver: true)],
    );

    blocTest<OnBoardingTosCubit, OnBoardingTosState>(
      'emits [agreeTerms] when setAgreeTerms is called',
      build: () => onBoardingTosCubit,
      act: (cubit) => cubit.setAgreeTerms(agreeTerms: true),
      expect: () => [const OnBoardingTosState(agreeTerms: true)],
    );

    blocTest<OnBoardingTosCubit, OnBoardingTosState>(
      'emits [readTerms] when setReadTerms is called',
      build: () => onBoardingTosCubit,
      act: (cubit) => cubit.setReadTerms(readTerms: true),
      expect: () => [const OnBoardingTosState(readTerms: true)],
    );

    blocTest<OnBoardingTosCubit, OnBoardingTosState>(
      'emits [acceptanceButtonEnabled] when setAcceptanceButtonEnabled is called',
      build: () => onBoardingTosCubit,
      act: (cubit) =>
          cubit.setAcceptanceButtonEnabled(acceptanceButtonEnabled: true),
      expect: () => [const OnBoardingTosState(acceptanceButtonEnabled: true)],
    );
  });
}
