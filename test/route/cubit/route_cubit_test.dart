import 'package:altme/route/route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RouteCubit', () {
    late RouteCubit routeCubit;

    setUp(() {
      routeCubit = RouteCubit();
    });

    tearDown(() {
      routeCubit.close();
    });

    test('initial state is an empty string', () {
      expect(routeCubit.state, equals(''));
    });

    blocTest<RouteCubit, String?>(
      'emits new screen name when setCurrentScreen is called',
      build: () => routeCubit,
      act: (cubit) => cubit.setCurrentScreen('HomeScreen'),
      expect: () => ['HomeScreen'],
    );

    blocTest<RouteCubit, String?>(
      'emits null when setCurrentScreen is called with null',
      build: () => routeCubit,
      act: (cubit) => cubit.setCurrentScreen(null),
      expect: () => [null],
    );
  });
}
