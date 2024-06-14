import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('BaseTextField Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    testWidgets('renders BaseTextField with default properties',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: BaseTextField(
            controller: controller,
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(SizedBox), findsNWidgets(2));
    });

    testWidgets('renders BaseTextField with label',
        (WidgetTester tester) async {
      const label = 'Test Label';

      await tester.pumpApp(
        Scaffold(
          body: BaseTextField(
            controller: controller,
            label: label,
          ),
        ),
      );

      expect(find.text(label), findsOneWidget);
    });

    testWidgets('renders BaseTextField with hint', (WidgetTester tester) async {
      const hint = 'Test Hint';

      await tester.pumpApp(
        Scaffold(
          body: BaseTextField(
            controller: controller,
            hint: hint,
          ),
        ),
      );

      expect(find.text(hint), findsOneWidget);
    });

    testWidgets('renders BaseTextField with error text',
        (WidgetTester tester) async {
      const error = 'Test Error';

      await tester.pumpApp(
        Scaffold(
          body: BaseTextField(
            controller: controller,
            error: error,
          ),
        ),
      );

      expect(find.text(error), findsOneWidget);
    });

    testWidgets('renders BaseTextField with prefix and suffix icons',
        (WidgetTester tester) async {
      const prefixIcon = Icon(Icons.email);
      const suffixIcon = Icon(Icons.visibility);

      await tester.pumpApp(
        Scaffold(
          body: BaseTextField(
            controller: controller,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      );

      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('input text updates the controller',
        (WidgetTester tester) async {
      const inputText = 'Hello, Flutter!';

      await tester.pumpApp(
        Scaffold(
          body: BaseTextField(
            controller: controller,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), inputText);
      expect(controller.text, inputText);
    });

    testWidgets('obscureText property works correctly',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: BaseTextField(
            controller: controller,
            obscureText: true,
          ),
        ),
      );

      final TextField textField = tester.widget(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });
  });
}
