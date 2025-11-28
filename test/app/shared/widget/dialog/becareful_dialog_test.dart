import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('BeCarefulDialog Widget Tests', () {
    testWidgets('renders BeCarefulDialog with title', (
      WidgetTester tester,
    ) async {
      const title = 'Test Title';

      await tester.pumpApp(const Scaffold(body: BeCarefulDialog(title: title)));

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('renders BeCarefulDialog with subtitle', (
      WidgetTester tester,
    ) async {
      const title = 'Test Title';
      const subtitle = 'Test Subtitle';

      await tester.pumpApp(
        const Scaffold(
          body: BeCarefulDialog(title: title, subtitle: subtitle),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('renders BeCarefulDialog with yes and no buttons', (
      WidgetTester tester,
    ) async {
      const title = 'Test Title';
      const yesText = 'Yes';
      const noText = 'No';

      await tester.pumpApp(
        const Scaffold(
          body: BeCarefulDialog(title: title, yes: yesText, no: noText),
        ),
      );

      expect(find.text(yesText.toUpperCase()), findsOneWidget);
      expect(find.text(noText.toUpperCase()), findsOneWidget);
    });

    testWidgets('clicking no button closes the dialog', (
      WidgetTester tester,
    ) async {
      const title = 'Test Title';
      const noText = 'No';

      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  BeCarefulDialog.show(
                    context: context,
                    title: title,
                    no: noText,
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(noText.toUpperCase()), findsOneWidget);

      await tester.tap(find.text(noText.toUpperCase()));
      await tester.pumpAndSettle();

      expect(find.text(title), findsNothing);
    });

    testWidgets(
      'clicking yes button triggers onContinueClick and closes the dialog',
      (WidgetTester tester) async {
        const title = 'Test Title';
        const yesText = 'Yes';
        bool onContinueClicked = false;

        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    BeCarefulDialog.show(
                      context: context,
                      title: title,
                      yes: yesText,
                      onContinueClick: () {
                        onContinueClicked = true;
                      },
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text(title), findsOneWidget);
        expect(find.text(yesText.toUpperCase()), findsOneWidget);

        await tester.tap(find.text(yesText.toUpperCase()));
        await tester.pumpAndSettle();

        expect(find.text(title), findsNothing);
        expect(onContinueClicked, isTrue);
      },
    );
  });
}
