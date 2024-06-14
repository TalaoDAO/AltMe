import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/helpers.dart';

class MockKeyboardTapCallback extends Mock {
  void call(String text);
}

void main() {
  group('NumericKeyboard', () {
    testWidgets('renders keyboard buttons correctly', (tester) async {
      final mockCallback = MockKeyboardTapCallback();

      await tester.pumpApp(
        Scaffold(
          body: NumericKeyboard(
            keyboardUIConfig: const KeyboardUIConfig(),
            onKeyboardTap: mockCallback.call,
            allowAction: true,
          ),
        ),
      );

      expect(find.byType(KeyboardButton), findsNWidgets(10));
    });

    testWidgets('tapping a keyboard button triggers the callback',
        (tester) async {
      final mockCallback = MockKeyboardTapCallback();

      await tester.pumpApp(
        Scaffold(
          body: NumericKeyboard(
            keyboardUIConfig: const KeyboardUIConfig(),
            onKeyboardTap: mockCallback.call,
            allowAction: true,
          ),
        ),
      );

      await tester.tap(find.text('1'));
      verify(() => mockCallback.call('1')).called(1);
    });
  });

  group('KeyboardButton', () {
    testWidgets('renders label correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Scaffold(
            body: KeyboardButton(
              semanticsLabel: '1',
              label: '1',
              onTap: (_) {},
              allowAction: true,
            ),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('renders icon correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Scaffold(
            body: KeyboardButton(
              semanticsLabel: 'delete',
              icon: const Icon(Icons.delete),
              onTap: (_) {},
              allowAction: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      final mockCallback = MockKeyboardTapCallback();
      await tester.pumpApp(
        Scaffold(
          body: Scaffold(
            body: KeyboardButton(
              semanticsLabel: '1',
              label: '1',
              onTap: mockCallback.call,
              allowAction: true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('1'));
      verify(() => mockCallback.call('1')).called(1);
    });

    testWidgets('does not trigger onTap callback when disabled',
        (tester) async {
      final mockCallback = MockKeyboardTapCallback();
      await tester.pumpApp(
        Scaffold(
          body: Scaffold(
            body: KeyboardButton(
              semanticsLabel: '1',
              label: '1',
              onTap: mockCallback.call,
              allowAction: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('1'));
      verifyNever(() => mockCallback.call(any()));
    });

    testWidgets('triggers onLongPress callback when long pressed',
        (tester) async {
      final mockCallback = MockKeyboardTapCallback();
      await tester.pumpApp(
        Scaffold(
          body: Scaffold(
            body: KeyboardButton(
              semanticsLabel: '1',
              label: '1',
              onLongPress: mockCallback.call,
              allowAction: true,
            ),
          ),
        ),
      );

      await tester.longPress(find.text('1'));
      verify(() => mockCallback.call('1')).called(1);
    });

    testWidgets('does not trigger onLongPress callback when disabled',
        (tester) async {
      final mockCallback = MockKeyboardTapCallback();
      await tester.pumpApp(
        Scaffold(
          body: Scaffold(
            body: KeyboardButton(
              semanticsLabel: '1',
              label: '1',
              onLongPress: mockCallback.call,
              allowAction: false,
            ),
          ),
        ),
      );

      await tester.longPress(find.text('1'));
      verifyNever(() => mockCallback.call(any()));
    });
  });
}
