import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ErrorDialog Widget Tests', () {
    testWidgets(
      'displays the ErrorDialog with the correct title and description',
      (WidgetTester tester) async {
        const title = 'Error Title';
        const description = 'An error occurred';

        await tester.pumpApp(
          const Scaffold(
            body: ErrorDialog(title: title, erroDescription: description),
          ),
        );

        expect(find.text(title), findsOneWidget);
        expect(find.text('More Details'.toUpperCase()), findsOneWidget);

        await tester.tap(find.text('More Details'.toUpperCase()));
        await tester.pumpAndSettle();

        expect(find.byType(ErrorDetailsDialog), findsOneWidget);
        expect(find.text(description), findsOneWidget);
      },
    );

    testWidgets('Popup works correctly', (WidgetTester tester) async {
      const title = 'Error Title';
      const description = 'An error occurred';

      await tester.pumpApp(
        const Scaffold(
          body: ErrorDialog(title: title, erroDescription: description),
        ),
      );

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
