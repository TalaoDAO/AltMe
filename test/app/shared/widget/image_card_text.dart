import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImageCarText widget', () {
    testWidgets('property set properly', (WidgetTester tester) async {
      const testableWidget = MaterialApp(
        home: ImageCardText(text: 'Test'),
      );

      await tester.pumpWidget(testableWidget);

      final imageCardFinder = find.byType(ImageCardText);
      expect(imageCardFinder, findsOneWidget);
      final imageCardText = tester.widget<ImageCardText>(
        find.byType(ImageCardText),
      );
      expect(imageCardText.text, 'Test');
      expect(imageCardText.textStyle, null);
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
