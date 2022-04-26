import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });
}
