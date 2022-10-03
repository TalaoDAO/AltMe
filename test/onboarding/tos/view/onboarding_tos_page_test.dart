import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('OnBoarding Terms Page', () {
    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                //Navigator.of(context).push<void>(OnBoardingTosPage.route());
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    testWidgets('renders OnBoardingTosPage', (tester) async {
      await tester
          .pumpApp(const OnBoardingTosPage(routeType: WalletRouteType.create));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    testWidgets('nothing happens when button is pressed', (tester) async {
      await tester
          .pumpApp(const OnBoardingTosPage(routeType: WalletRouteType.create));
      await tester.tap(find.byType(MyElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    testWidgets('blocks going back from OnBoardingTosPage start page',
        (tester) async {
      await tester
          .pumpApp(const OnBoardingTosPage(routeType: WalletRouteType.create));
      final dynamic appState = tester.state(find.byType(WidgetsApp));
      expect(await appState.didPopRoute(), true);
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    testWidgets('renders DisplayTerms', (tester) async {
      await tester
          .pumpApp(const OnBoardingTosPage(routeType: WalletRouteType.create));
      await tester.pumpAndSettle();
      expect(find.byType(DisplayTermsofUse), findsOneWidget);
    });
  });
}
