import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget() {
    return MaterialApp(
      home: MarkdownPage(
        title: 'title',
        file: 'assets/notices.md',
        key: GlobalKey(),
      ),
    );
  }

  group('MarkdownPage widget', () {
    late Widget widget;

    setUp(() {
      //do mock the assets
      TestWidgetsFlutterBinding.ensureInitialized();
      services.ServicesBinding.instance?.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) {
        final Uint8List encoded = utf8.encoder.convert('<a href="https://www.toto.app">link</a>');
        return Future.value(encoded.buffer.asByteData());
      });
      widget = makeTestableWidget();
    });

    testWidgets('verify property set correctly', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      expect(find.byType(MarkdownPage), findsOneWidget);
      final markdownWidget =
          tester.widget<MarkdownPage>(find.byType(MarkdownPage));
      expect(markdownWidget.file, 'assets/notices.md');
      expect(markdownWidget.title, 'title');
      expect(markdownWidget.key, isA<GlobalKey>());
    });

    testWidgets('sub widget founded', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      expect(find.byType(MarkdownPage), findsOneWidget);
      expect(find.byType(BasePage), findsOneWidget);
      expect(find.byType(BackLeadingButton), findsOneWidget);
      expect(find.byType(Spinner), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(Markdown), findsOneWidget);
      expect(find.byType(Spinner), findsNothing);
    });

    testWidgets('tap on markdown widget', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      expect(find.byType(Markdown), findsOneWidget);
      await tester.tap(find.byType(Markdown));
      await tester.pumpAndSettle();
    });
  });

  group('MarkdownPage bad state work properly', () {
    late Widget widget;

    setUp(() {
      //do mock the assets
      widget = makeTestableWidget();
      TestWidgetsFlutterBinding.ensureInitialized();
      services.ServicesBinding.instance?.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) {
        throw FlutterError('Unable to load asset');
      });
    });

    testWidgets('trigger error ', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });
  });
}
