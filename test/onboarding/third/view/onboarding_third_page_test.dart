import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('Onboarding Third Page', () {
    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<void>(OnBoardingThirdPage.route());
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingThirdPage), findsOneWidget);
    });

    testWidgets('renders OnBoardingThirdPage', (tester) async {
      await tester.pumpApp(const OnBoardingThirdPage());
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingThirdPage), findsOneWidget);
    });

    testWidgets('navigates to OnBoardingTosPage when button is pressed',
        (tester) async {
      await tester.pumpApp(const OnBoardingThirdPage());
      await tester.tap(find.byType(BaseButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    testWidgets('animation value change after 1 sec', (tester) async {
      await tester.pumpApp(const OnBoardingThirdPage());
      final dynamic appState = tester.state(find.byType(OnBoardingThirdPage));
      expect(appState.animate, true);
      appState.disableAnimation();
      expect(appState.animate, false);
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      expect(appState.animate, true);
    });

    testWidgets('Navigator.pop triggered on left swipe', (tester) async {
      final MockNavigator navigator = MockNavigator();
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: const OnBoardingThirdPage(),
        ),
      );
      final finder = find.byKey(const Key('third_page_gesture_detector'));
      await tester.drag(finder, const Offset(2.1, 0));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      verify(navigator.pop).called(1);
    });
  });
}
