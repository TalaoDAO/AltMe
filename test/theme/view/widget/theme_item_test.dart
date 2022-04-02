import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

abstract class CallFunction {
  void call();
}

class MockCallback extends Mock implements CallFunction {}

void main() {
  group('ThemeItem', () {
    const bool isTrue = true;
    const String title = 'Light Theme';

    late MockCallback mockFunction;

    setUp(() {
      mockFunction = MockCallback();
    });

    testWidgets(
      'renders correct Title',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ThemeItem(
                isTrue: isTrue,
                title: title,
                onTap: () => mockFunction(),
              ),
            ),
          ),
        );
        expect(find.text(title), findsOneWidget);
      },
    );

    testWidgets(
      'renders correct Icon when true case ',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ThemeItem(
                isTrue: isTrue,
                title: title,
                onTap: () => mockFunction(),
              ),
            ),
          ),
        );
        expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      },
    );

    testWidgets(
      'renders correct Icon when true case ',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ThemeItem(
                isTrue: false,
                title: title,
                onTap: () => mockFunction(),
              ),
            ),
          ),
        );
        expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
      },
    );

    testWidgets(
      'triggers correct function',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ThemeItem(
                isTrue: false,
                title: title,
                onTap: () => mockFunction(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byType(InkWell));
        verify(() => mockFunction()).called(1);
      },
    );
  });
}
