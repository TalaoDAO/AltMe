import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:flutter/gestures.dart';
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

  bool isFirstCase = true;

  setUpAll(() {
    ///do mock the assets
    TestWidgetsFlutterBinding.ensureInitialized();
    services.ServicesBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) {
      if (isFirstCase) {
        final Uint8List encoded =
            utf8.encoder.convert('[Link `with nested code` Text](href)');
        return Future.value(encoded.buffer.asByteData());
      } else {
        return null;
      }
    });
  });

  group('MarkdownPage widget', () {
    late Widget widget;

    setUp(() {
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
      final richText = tester.widget<RichText>(find.byType(RichText).first);
      final span = richText.text as TextSpan;

      final gestureRecognizerTypes = <Type>[];
      span.visitChildren((InlineSpan inlineSpan) {
        if (inlineSpan is TextSpan) {
          final recognizer = inlineSpan.recognizer;
          gestureRecognizerTypes.add(recognizer?.runtimeType ?? Null);
          if (recognizer != null && recognizer is TapGestureRecognizer) {
            recognizer.onTap!();
          }
        }
        return true;
      });

      expect(span.children!.length, 3);
      expect(gestureRecognizerTypes.length, 3);
      expect(gestureRecognizerTypes, everyElement(TapGestureRecognizer));
      await tester.pumpAndSettle();
    });
  });

  group('MarkdownPage bad state work properly', () {
    final widget = MaterialApp(
      home: MarkdownPage(
        title: 'title',
        file: 'assets1/notices.md',
      ),
    );

    testWidgets('trigger message ', (WidgetTester tester) async {
      isFirstCase = false;
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
    });
  });
}
