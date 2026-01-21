import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers/helpers.dart';

void main() {
  final navigator = MockNavigator();

  setUpAll(() {
    when(navigator.canPop).thenReturn(true);
    when(
      () => navigator.pushReplacement<void, void>(any()),
    ).thenAnswer((_) async {});
    when(() => navigator.push<void>(any())).thenAnswer((_) async {});
  });

  testWidgets('sensibleRoute pushes replacement route if isSameRoute is true', (
    WidgetTester tester,
  ) async {
    await tester.pumpApp(
      MockNavigatorProvider(
        navigator: navigator,
        child: Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                sensibleRoute(
                  context: context,
                  route: StarterPage.route(),
                  isSameRoute: true,
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    verify(
      () => navigator.pushReplacement<void, void>(
        any(that: isRoute<void>(whereName: equals('/starterPage'))),
      ),
    ).called(1);
  });

  testWidgets(
    'sensibleRoute pushes replacement route if isSameRoute is false',
    (WidgetTester tester) async {
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  sensibleRoute(
                    context: context,
                    route: StarterPage.route(),
                    isSameRoute: false,
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/starterPage'))),
        ),
      ).called(1);
    },
  );
}
