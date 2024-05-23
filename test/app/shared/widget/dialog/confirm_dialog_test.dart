import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ConfirmDialog Widget Tests', () {
    testWidgets('renders ConfirmDialog with title',
        (WidgetTester tester) async {
      const title = 'Test Title';

      await tester.pumpApp(
        const ConfirmDialog(
          title: title,
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('renders ConfirmDialog with subtitle',
        (WidgetTester tester) async {
      const title = 'Test Title';
      const subtitle = 'Test Subtitle';

      await tester.pumpApp(
        const ConfirmDialog(
          title: title,
          subtitle: subtitle,
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('renders ConfirmDialog with yes and no buttons',
        (WidgetTester tester) async {
      const title = 'Test Title';
      const yesText = 'Yes';
      const noText = 'No';

      await tester.pumpApp(
        const ConfirmDialog(
          title: title,
          yes: yesText,
          no: noText,
        ),
      );

      expect(find.text(yesText.toUpperCase()), findsOneWidget);
      expect(find.text(noText.toUpperCase()), findsOneWidget);
    });

    testWidgets('clicking no button closes the dialog with false',
        (WidgetTester tester) async {
      const title = 'Test Title';
      const noText = 'No';

      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => const ConfirmDialog(
                    title: title,
                    no: noText,
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

      expect(find.text(title), findsOneWidget);
      expect(find.text(noText.toUpperCase()), findsOneWidget);

      await tester
          .tap(find.widgetWithText(MyOutlinedButton, noText.toUpperCase()));
      await tester.pumpAndSettle();

      expect(find.text(title), findsNothing);
    });

    testWidgets('clicking yes button closes the dialog with true',
        (WidgetTester tester) async {
      const title = 'Test Title';
      const yesText = 'Yes';
      bool? result;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                result = await showDialog<bool>(
                  context: context,
                  builder: (_) => const ConfirmDialog(
                    title: title,
                    yes: yesText,
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

      expect(find.text(title), findsOneWidget);
      expect(find.text(yesText.toUpperCase()), findsOneWidget);

      await tester
          .tap(find.widgetWithText(MyElevatedButton, yesText.toUpperCase()));
      await tester.pumpAndSettle();

      expect(find.text(title), findsNothing);
      expect(result, isTrue);
    });

    testWidgets(
        'ConfirmDialog shows only yes button when showNoButton is false',
        (WidgetTester tester) async {
      const title = 'Test Title';
      const yesText = 'Yes';
      const noText = 'No';

      await tester.pumpApp(const ConfirmDialog(
        title: title,
        yes: yesText,
        no: noText,
        showNoButton: false,
      ),);

      expect(find.text(yesText.toUpperCase()), findsOneWidget);
      expect(find.text(noText.toUpperCase()), findsNothing);
    });
  });
}
