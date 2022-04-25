import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('Router Test', () {
    testWidgets('right to left transition works correctly', (tester) async {
      final rightToLeftRoute = RightToLeftRoute<void>(
        builder: (context) => const OnBoardingSecondPage(),
        settings: const RouteSettings(name: '/onBoardingSecondPage'),
      );
      await tester.pumpApp(
        Builder(
          builder: (BuildContext context) {
            return TextButton(
              child: const Text('I am button'),
              onPressed: () => Navigator.push<void>(context, rightToLeftRoute),
            );
          },
        ),
      );
      await tester.tap(find.text('I am button'));
      await tester.pump();
      expect(rightToLeftRoute.settings.name, '/onBoardingSecondPage');
      expect(rightToLeftRoute.animation!.status, AnimationStatus.forward);
      expect(rightToLeftRoute.animation!.value, 0.0);
      expect(find.byType(SlideTransition), findsOneWidget);
      expect(find.byType(OnBoardingSecondPage), findsNothing);

      await tester.pumpAndSettle();
      expect(rightToLeftRoute.settings.name, '/onBoardingSecondPage');
      expect(rightToLeftRoute.animation!.status, AnimationStatus.completed);
      expect(rightToLeftRoute.animation!.value, 1.0);
      expect(find.byType(SlideTransition), findsOneWidget);
      expect(find.byType(OnBoardingSecondPage), findsOneWidget);
    });
  });
}
