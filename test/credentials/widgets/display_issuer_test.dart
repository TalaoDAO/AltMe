import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisplayIssuer Widget work correctly', () {
    late Author issuerWithLogo;
    late Author issuerWithoutLogo;
    const authorName = 'Taleb';

    setUp(() {
      issuerWithLogo = const Author(authorName);
      issuerWithoutLogo = const Author(authorName);
    });

    testWidgets('find issuer name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DisplayIssuer(issuer: issuerWithLogo),
        ),
      );
      expect(find.text(authorName), findsOneWidget);
    });

    testWidgets('find issuer model', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DisplayIssuer(issuer: issuerWithLogo),
        ),
      );
      final displayIssuer =
          tester.widget(find.byType(DisplayIssuer)) as DisplayIssuer;
      expect(displayIssuer.issuer, issuerWithLogo);
    });

    testWidgets('find CachedImageFromNetwork', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DisplayIssuer(issuer: issuerWithLogo),
        ),
      );
      expect(find.byType(CachedImageFromNetwork), findsOneWidget);
    });

    testWidgets('CachedImageFromNetwork gone when logo is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DisplayIssuer(issuer: issuerWithoutLogo),
        ),
      );
      expect(find.byType(CachedImageFromNetwork), findsNothing);
    });

    testWidgets('find all widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DisplayIssuer(issuer: issuerWithLogo),
        ),
      );
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(CachedImageFromNetwork), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(SizedBox), findsNWidgets(2));
    });
  });
}
