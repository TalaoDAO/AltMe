import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget() {
    return MaterialApp(
      home: MarkdownPage(
        title: 'title',
        file: 'assets/notices/notices_en.md',
        key: GlobalKey(),
      ),
    );
  }

  testWidgets('MarkdownPage should load and display markdown content',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(Spinner), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(Markdown), findsOneWidget);
    expect(
      find.text(
        'The Altme wallet is an open source project under Apache 2.0 licence',
      ),
      findsOneWidget,
    );
  });

  testWidgets('MarkdownPage should handle loading errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MarkdownPage(title: 'Test', file: 'invalid_file.md'),
      ),
    );

    expect(find.byType(Spinner), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(Markdown), findsNothing);
  });
}
