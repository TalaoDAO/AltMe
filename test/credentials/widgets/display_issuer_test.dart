import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisplayIssuer Widget work correctly', () {
    const authorName = 'Taleb';

    const author = Author(authorName);

    testWidgets('find issuer name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DisplayIssuer(issuer: author),
        ),
      );
      expect(find.text(authorName), findsOneWidget);
    });

    testWidgets('find issuer model', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DisplayIssuer(issuer: author),
        ),
      );
      final displayIssuer =
          tester.widget(find.byType(DisplayIssuer)) as DisplayIssuer;
      expect(displayIssuer.issuer, author);
    });

    testWidgets('find all widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DisplayIssuer(issuer: author),
        ),
      );
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(MyText), findsOneWidget);
    });
  });
}
