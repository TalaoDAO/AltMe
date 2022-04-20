import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget() {
    return MaterialApp(
      home: CredentialField(
        key: GlobalKey(),
        value: 'value',
        title: 'title',
      ),
    );
  }

  Widget makeTestableWidgetWithEmptyValue() {
    return MaterialApp(
      home: CredentialField(
        key: GlobalKey(),
        value: '',
        title: 'title',
      ),
    );
  }

  group('CredentialField widget', () {
    testWidgets('verify widget exist in tree', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());
      final result = find.byType(CredentialField);
      expect(result, findsOneWidget);
    });

    testWidgets('verify property is correct', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());
      final credentialFieldWidget =
          tester.widget<CredentialField>(find.byType(CredentialField));
      expect(credentialFieldWidget.value, 'value');
      expect(credentialFieldWidget.title, 'title');
      expect(credentialFieldWidget.key, isA<GlobalKey>());
    });

    testWidgets('find sub widgets', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());
      final findHasDisplay = find.byType(HasDisplay);
      final findDisplayCredentialField = find.byType(DisplayCredentialField);
      expect(findHasDisplay, findsOneWidget);
      expect(findDisplayCredentialField, findsOneWidget);
    });

    testWidgets('verify DisplayCredentialField is gone when title is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidgetWithEmptyValue());
      final findDisplayCredentialField = find.byType(DisplayCredentialField);
      expect(findDisplayCredentialField, findsNothing);
    });
  });
}
