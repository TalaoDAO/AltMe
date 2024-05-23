import 'package:altme/app/app.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  testWidgets('MyRichText displays the correct rich text',
      (WidgetTester tester) async {
    const textSpan = TextSpan(
      text: 'Hello ',
      children: [
        TextSpan(
          text: 'World',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );

    await tester
        .pumpApp(const Scaffold(body: MyRichText(text: textSpan, maxLines: 1)));

    await tester.pumpAndSettle();

    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('MyRichText respects maxLines', (WidgetTester tester) async {
    const longTextSpan = TextSpan(
      text: 'This is a long text that should be truncated',
    );

    // Build the widget
    await tester.pumpApp(
      const Scaffold(
        body: SizedBox(
          width: 100,
          child: MyRichText(
            text: longTextSpan,
            maxLines: 1,
          ),
        ),
      ),
    );

    final richTextWidget =
        tester.widget<AutoSizeText>(find.byType(AutoSizeText));
    expect(richTextWidget.maxLines, 1);
  });
}
