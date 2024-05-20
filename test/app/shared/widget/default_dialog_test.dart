import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  testWidgets('DefaultDialog displays title and description',
      (WidgetTester tester) async {
    const title = 'Test Title';
    const description = 'Test Description';

    await tester.pumpApp(
      const Scaffold(
        body: DefaultDialog(
          title: title,
          description: description,
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);
    expect(find.text(description), findsOneWidget);
  });

  testWidgets(
      'DefaultDialog displays button with label and handles button click',
      (WidgetTester tester) async {
    bool triggerred = false;
    const title = 'Test Title';
    const description = 'Test Description';
    const buttonLabel = 'Button';

    await tester.pumpApp(
      Scaffold(
        body: DefaultDialog(
          title: title,
          description: description,
          buttonLabel: buttonLabel,
          onButtonClick: () {
            triggerred = true;
          },
        ),
      ),
    );

    expect(find.byType(MyElevatedButton), findsOneWidget);

    await tester.tap(find.byType(MyElevatedButton));
    await tester.pumpAndSettle();
    expect(triggerred, isTrue);
  });
}
