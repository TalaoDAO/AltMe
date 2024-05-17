import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  testWidgets('DialogCloseButton displays text and icon',
      (WidgetTester tester) async {
    await tester.pumpApp(
      const Scaffold(body: DialogCloseButton()),
    );

    expect(find.text('Close'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('DialogCloseButton does not display text when showText is false',
      (WidgetTester tester) async {
    await tester.pumpApp(
      const Scaffold(body: DialogCloseButton(showText: false)),
    );

    expect(find.text('Close'), findsNothing);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('DialogCloseButton closes the dialog when tapped',
      (WidgetTester tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (context) => Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const AlertDialog(
                      content: DialogCloseButton(),
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(DialogCloseButton), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(DialogCloseButton), findsNothing);
  });
}
