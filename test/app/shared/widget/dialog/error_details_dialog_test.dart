import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ErrorDetailsDialog Widget Tests', () {
    testWidgets('renders ErrorDetailsDialog with error description',
        (WidgetTester tester) async {
      const errorDescription = 'An error occurred';

      await tester.pumpApp(
        const ErrorDetailsDialog(
          erroDescription: errorDescription,
        ),
      );

      expect(find.text(errorDescription), findsOneWidget);
    });

    testWidgets('renders ErrorDetailsDialog with more details link',
        (WidgetTester tester) async {
      const errorDescription = 'An error occurred';
      const errorUrl = 'https://example.com';

      await tester.pumpApp(
        const ErrorDetailsDialog(
          erroDescription: errorDescription,
          erroUrl: errorUrl,
        ),
      );

      expect(find.text(errorDescription), findsOneWidget);
      expect(find.text('More Details'), findsOneWidget);
    });

    testWidgets('clicking OK button closes the dialog',
        (WidgetTester tester) async {
      const errorDescription = 'An error occurred';

      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => const ErrorDetailsDialog(
                    erroDescription: errorDescription,
                  ),
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(errorDescription), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text(errorDescription), findsNothing);
    });
  });
}
