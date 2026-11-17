import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardCubit', () {
    test('starts on the wallet tab', () {
      expect(DashboardCubit().state.tab, DashboardTab.wallet);
    });

    blocTest<DashboardCubit, DashboardState>(
      'selectTab emits the selected tab',
      build: DashboardCubit.new,
      act: (cubit) => cubit
        ..selectTab(DashboardTab.discover)
        ..selectTab(DashboardTab.search),
      expect: () => [
        isA<DashboardState>().having(
          (state) => state.tab,
          'tab',
          DashboardTab.discover,
        ),
        isA<DashboardState>().having(
          (state) => state.tab,
          'tab',
          DashboardTab.search,
        ),
      ],
    );
  });

  group('DashboardState', () {
    test('loading keeps the tab', () {
      const state = DashboardState(tab: DashboardTab.search);
      expect(state.loading().tab, DashboardTab.search);
    });

    test('round-trips the tab through JSON', () {
      const state = DashboardState(tab: DashboardTab.discover);
      expect(
        DashboardState.fromJson(state.toJson()).tab,
        DashboardTab.discover,
      );
    });

    test('defaults to the wallet tab when JSON has none', () {
      expect(
        DashboardState.fromJson(const <String, dynamic>{'status': 'init'}).tab,
        DashboardTab.wallet,
      );
    });
  });
}
