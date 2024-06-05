import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('Text Field Dialog', () {
    testWidgets('TextFieldDialog widget test', (WidgetTester tester) async {
      await tester.pumpApp(
        const TextFieldDialog(
          title: 'Title',
          label: 'Label',
          subtitle: 'Subtitle',
          initialValue: 'Initial Value',
          yes: 'Yes',
          no: 'No',
        ),
      );
      // Verify that the title, label, subtitle,
      // and initial value are displayed.
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Label'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.text('Initial Value'), findsOneWidget);

      // Verify that the Yes and No buttons are displayed.
      expect(find.text('Yes'.toUpperCase()), findsOneWidget);
      expect(find.text('No'.toUpperCase()), findsOneWidget);

      // Tap on the Yes button and verify that the text is popped.
      await tester.tap(find.text('Yes'.toUpperCase()));
      await tester.pumpAndSettle();
      expect(find.text('Initial Value'), findsNothing);
    });

    testWidgets('Popup works correctly', (WidgetTester tester) async {
      await tester.pumpApp(
        const TextFieldDialog(
          title: 'Title',
          label: 'Label',
          subtitle: 'Subtitle',
          initialValue: 'Initial Value',
          yes: 'Yes',
          no: 'No',
        ),
      );

      expect(find.text('No'.toUpperCase()), findsOneWidget);

      await tester.tap(find.text('No'.toUpperCase()));
      await tester.pumpAndSettle();
      expect(find.text('No'.toUpperCase()), findsNothing);
    });
  });
}
