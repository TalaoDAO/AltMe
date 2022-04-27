import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class RectoWidget extends Recto {
  const RectoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      color: Colors.blueGrey,
      child: const Text('Recto'),
    );
  }
}

class VersoWidget extends Verso {
  const VersoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      color: Colors.grey,
      child: const Text('Verso'),
    );
  }
}

void main() {
  late Widget testableWidget;
  setUp(() {
    testableWidget = MaterialApp(
      home: CardAnimationWidget(
        key: GlobalKey(),
        recto: RectoWidget(
          key: GlobalKey(),
        ),
        verso: VersoWidget(
          key: GlobalKey(),
        ),
      ),
    );
  });

  group('CardAnimationWidget widget', () {
    testWidgets('CardAnimationWidget property set correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(CardAnimationWidget), findsOneWidget);
      final carAnimationWidget =
          tester.widget<CardAnimationWidget>(find.byType(CardAnimationWidget));
      expect(carAnimationWidget.recto, isNotNull);
      expect(carAnimationWidget.verso, isNotNull);
      expect(carAnimationWidget.key, isA<GlobalKey>());
    });

    testWidgets('Recto and Verso widgets changed with tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(CardAnimationWidget), findsOneWidget);
      expect(find.byType(RectoWidget), findsOneWidget);
      expect(find.byType(VersoWidget), findsNothing);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));

      expect(find.byType(VersoWidget), findsOneWidget);
      expect(find.byType(RectoWidget), findsNothing);
      expect(find.byType(CardAnimationWidget), findsOneWidget);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));

      expect(find.byType(RectoWidget), findsOneWidget);
      expect(find.byType(VersoWidget), findsNothing);
      expect(find.byType(CardAnimationWidget), findsOneWidget);
    });
  });
}
