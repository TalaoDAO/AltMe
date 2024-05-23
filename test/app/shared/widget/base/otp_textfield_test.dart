import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('OtpTextField', () {
    late List<TextEditingController> controllers;

    setUp(() {
      controllers = List.generate(
        6,
        (index) => TextEditingController(
          text: '',
        ),
      );
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: OtpTextField(
            controllers: controllers,
            index: 0,
            autoFocus: false,
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('autofocus works correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: OtpTextField(
            controllers: controllers,
            index: 0,
            autoFocus: true,
          ),
        ),
      );

      await tester.pump();

      final finder = find.byType(TextField);
      expect(finder, findsOneWidget);
      final textField = tester.widget<TextField>(finder);
      expect(textField.autofocus, true);
    });

    testWidgets('moves to next field when a digit is entered', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Row(
            children: List.generate(6, (index) {
              return OtpTextField(
                controllers: controllers,
                index: index,
                autoFocus: index == 0,
              );
            }),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(1), '1');
      await tester.pump();

      expect(controllers[1].text, '1');
      expect(
          FocusScope.of(tester.element(find.byType(TextField).at(1))).hasFocus,
          true,);
    });

    testWidgets('onTap moves cursor to end of text', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: OtpTextField(
            controllers: controllers,
            index: 0,
            autoFocus: true,
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.pump();

      expect(
        controllers[0].selection,
        TextSelection.fromPosition(
            TextPosition(offset: controllers[0].text.length),),
      );
    });
  });
}
