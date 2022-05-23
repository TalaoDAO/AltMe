import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseButton widget', () {
    testWidgets('BaseButton default verify property value work exactly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (context) {
            return MaterialPageRoute<dynamic>(
              builder: (context) {
                return Scaffold(
                  body: BaseButton(
                    context: context,
                    onPressed: () {},
                    key: GlobalKey(),
                    borderColor: Colors.yellow,
                    margin: const EdgeInsets.all(10),
                    gradient: const LinearGradient(
                      colors: [Colors.blueGrey, Colors.grey],
                    ),
                    child: const Text('Test Button'),
                  ),
                );
              },
            );
          },
        ),
      );
      expect(find.byType(BaseButton), findsOneWidget);
      final baseButton = tester.widget<BaseButton>(find.byType(BaseButton));

      expect(baseButton.key, isA<GlobalKey>());
      expect(baseButton.context, isNotNull);
      expect(baseButton.borderColor, Colors.yellow);
      expect(baseButton.onPressed, isA<VoidCallback>());
      expect(baseButton.margin, const EdgeInsets.all(10));
      expect(
        baseButton.gradient,
        const LinearGradient(
          colors: [Colors.blueGrey, Colors.grey],
        ),
      );
      expect(
        baseButton.child,
        isA<Text>().having((p0) => p0.data, 'Text', 'Test Button'),
      );
    });

    testWidgets('BaseButton.white verify property value work exactly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkThemeData,
          darkTheme: AppTheme.darkThemeData,
          onGenerateRoute: (context) {
            return MaterialPageRoute<dynamic>(
              builder: (context) {
                return Scaffold(
                  body: BaseButton.white(
                    context: context,
                    child: const Text('Test Button'),
                  ),
                );
              },
            );
          },
        ),
      );
      final BuildContext context = tester.element(find.byType(Scaffold));

      expect(find.byType(BaseButton), findsOneWidget);
      final baseButton = tester.widget<BaseButton>(find.byType(BaseButton));

      expect(baseButton.key, isNull);
      expect(baseButton.context, isNotNull);
      expect(baseButton.borderColor, isNull);
      expect(baseButton.onPressed, isNull);
      expect(baseButton.margin, EdgeInsets.zero);
      expect(
        baseButton.gradient,
        const LinearGradient(
          colors: [Colors.white, Colors.white],
        ),
      );
      expect(
        baseButton.child,
        isA<Text>().having((p0) => p0.data, 'Text', 'Test Button'),
      );
      expect(
        tester
            .widget<DefaultTextStyle>(find.byType(DefaultTextStyle).last)
            .style
            .color,
        Theme.of(context).colorScheme.button,
      );
    });

    testWidgets('BaseButton.primary verify property value work exactly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkThemeData,
          darkTheme: AppTheme.darkThemeData,
          onGenerateRoute: (context) {
            return MaterialPageRoute<dynamic>(
              builder: (context) {
                return Scaffold(
                  body: BaseButton.primary(
                    context: context,
                    child: const Text('Test Button'),
                  ),
                );
              },
            );
          },
        ),
      );
      final BuildContext context = tester.element(find.byType(Scaffold));

      expect(find.byType(BaseButton), findsOneWidget);
      final baseButton = tester.widget<BaseButton>(find.byType(BaseButton));

      expect(baseButton.key, isNull);
      expect(baseButton.context, isNotNull);
      expect(baseButton.borderColor, isNull);
      expect(baseButton.onPressed, isNull);
      expect(baseButton.margin, EdgeInsets.zero);
      expect(
        baseButton.gradient,
        LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondaryContainer,
            Theme.of(context).colorScheme.secondaryContainer
          ],
        ),
      );
      expect(
        baseButton.child,
        isA<Text>().having((p0) => p0.data, 'Text', 'Test Button'),
      );
      expect(
        tester
            .widget<DefaultTextStyle>(find.byType(DefaultTextStyle).last)
            .style
            .color,
        Theme.of(context).colorScheme.onPrimary,
      );
    });

    testWidgets('BaseButton.transparent verify property value work exactly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkThemeData,
          darkTheme: AppTheme.darkThemeData,
          onGenerateRoute: (context) {
            return MaterialPageRoute<dynamic>(
              builder: (context) {
                return Scaffold(
                  body: BaseButton.transparent(
                    context: context,
                    child: const Text('Test Button'),
                  ),
                );
              },
            );
          },
        ),
      );
      final BuildContext context = tester.element(find.byType(Scaffold));

      expect(find.byType(BaseButton), findsOneWidget);
      final baseButton = tester.widget<BaseButton>(find.byType(BaseButton));

      expect(baseButton.key, isNull);
      expect(baseButton.context, isNotNull);
      expect(
        baseButton.borderColor,
        Theme.of(context).colorScheme.secondaryContainer,
      );
      expect(baseButton.onPressed, isNull);
      expect(baseButton.margin, EdgeInsets.zero);
      expect(
        baseButton.gradient,
        LinearGradient(
          colors: [
            Theme.of(context).colorScheme.transparent,
            Theme.of(context).colorScheme.transparent
          ],
        ),
      );
      expect(
        baseButton.child,
        isA<Text>().having((p0) => p0.data, 'Text', 'Test Button'),
      );
      expect(
        tester
            .widget<DefaultTextStyle>(find.byType(DefaultTextStyle).last)
            .style
            .color,
        Theme.of(context).colorScheme.secondaryContainer,
      );
    });
  });
}
