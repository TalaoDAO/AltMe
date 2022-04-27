import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('Onboarding Second Page', () {
    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<void>(OnBoardingSecondPage.route());
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingSecondPage), findsOneWidget);
    });

    testWidgets('renders OnBoardingSecondPage', (tester) async {
      await tester.pumpApp(const OnBoardingSecondPage());
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingSecondPage), findsOneWidget);
    });

    testWidgets('navigates to OnBoardingTosPage when button is pressed',
        (tester) async {
      await tester.pumpApp(const OnBoardingSecondPage());
      await tester.tap(find.byType(BaseButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    testWidgets('animation value change after 1 sec', (tester) async {
      await tester.pumpApp(const OnBoardingSecondPage());
      final dynamic appState = tester.state(find.byType(OnBoardingSecondPage));
      expect(appState.animate, true);
      appState.disableAnimation();
      expect(appState.animate, false);
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      expect(appState.animate, true);
    });

    testWidgets('navigates to OnBoardingSecondPage on right swipe',
        (tester) async {
      await tester.pumpApp(const OnBoardingSecondPage());
      final finder = find.byKey(const Key('second_page_gesture_detector'));
      await tester.drag(finder, const Offset(-2.1, 0));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      expect(find.byType(OnBoardingThirdPage), findsOneWidget);
    });

    testWidgets('Navigator.pop triggered on left swipe', (tester) async {
      final MockNavigator navigator = MockNavigator();
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: const OnBoardingSecondPage(),
        ),
      );
      final finder = find.byKey(const Key('second_page_gesture_detector'));
      await tester.drag(finder, const Offset(2.1, 0));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      verify(navigator.pop).called(1);
    });
  });
}
