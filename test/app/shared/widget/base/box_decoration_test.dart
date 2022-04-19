import 'package:altme/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseBoxDecoration class', () {
    late BaseBoxDecoration decoration;

    setUp(() {
      decoration = const BaseBoxDecoration();
    });

    testWidgets('find BaseBoxDecoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: decoration,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isA<BaseBoxDecoration>());
    });

    testWidgets('find BaseBoxDecoration with non null property',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BaseBoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.blueGrey,
                  shapeColor: Colors.white12,
                  gradient: LinearGradient(
                    colors: [
                      Colors.black26,
                      Colors.black12,
                    ],
                  ),
                  boxShadow: [BoxShadow(color: Colors.grey)],
                  anchors: [Alignment.topRight, Alignment.bottomLeft],
                ),
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isA<BaseBoxDecoration>());
    });

    testWidgets('find BaseBoxDecoration with null borderRadius',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BaseBoxDecoration(
                  borderRadius: null,
                ),
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isA<BaseBoxDecoration>());
      expect(
        (container.decoration as BaseBoxDecoration?)?.borderRadius,
        isNull,
      );
    });

    testWidgets('verify default property value', (WidgetTester tester) async {
      expect(decoration.color, isNull);
      expect(decoration.anchors, const <Alignment>[]);
      expect(decoration.borderRadius, isNull);
      expect(decoration.boxShadow, isNull);
      expect(decoration.gradient, isNull);
      expect(decoration.value, 0.0);
      expect(decoration.shapeSize, 128.0);
      expect(decoration.shapeColor, Colors.white10);
    });

    testWidgets('verify copyWith function', (WidgetTester tester) async {
      const color = Colors.blueGrey;
      const shapeColor = Colors.white;
      const borderRadius = BorderRadius.all(Radius.circular(8));
      const boxShadow = [BoxShadow(color: Colors.black12)];
      const gradient = LinearGradient(colors: [Colors.red, Colors.deepOrange]);

      final copiedDecoration = decoration.copyWith(
        color: color,
        shapeColor: shapeColor,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
      );

      expect(copiedDecoration.color, color);
      expect(copiedDecoration.shapeColor, shapeColor);
      expect(copiedDecoration.borderRadius, borderRadius);
      expect(copiedDecoration.boxShadow, boxShadow);
      expect(copiedDecoration.gradient, gradient);
      expect(copiedDecoration.shapeSize, 128.0);
      expect(copiedDecoration.value, 0.0);
      expect(copiedDecoration.anchors, const <Alignment>[]);
    });

    testWidgets('getClipPath()', (WidgetTester tester) async {
      final path = decoration.getClipPath(
        Offset.zero & const Size(100, 100),
        TextDirection.ltr,
      );
      expect(path.fillType, PathFillType.nonZero);
      final decorationWithBorderRadius = decoration.copyWith(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      );

      final pathWithBorderRadius = decorationWithBorderRadius.getClipPath(
        Offset.zero & const Size(100, 100),
        TextDirection.ltr,
      );
      expect(pathWithBorderRadius.fillType, PathFillType.nonZero);
    });

    testWidgets('toString()', (WidgetTester tester) async {
      expect(decoration.toString(), startsWith('BaseBoxDecoration'));
      expect(
        decoration.createBoxPainter().toString(),
        startsWith('BaseBoxPainter for'),
      );
      expect(decoration.toStringShort(), startsWith('BaseBoxDecoration'));
    });

    testWidgets('scale function', (WidgetTester tester) async {
      const scaleFactor = 0.5;
      const gradient = LinearGradient(colors: [Colors.red, Colors.orange]);
      final baseDecoration = decoration.copyWith(
        gradient: gradient,
      );
      final scaledDecoration = baseDecoration.scale(scaleFactor);
      expect(scaledDecoration.gradient, gradient.scale(scaleFactor));
    });

    testWidgets('lerpFrom function', (WidgetTester tester) async {
      final lerpT = decoration.lerpFrom(null, 0.5);
      expect(lerpT, isNotNull);

      final anotherBaseDecoration = decoration.copyWith(color: Colors.blueGrey);
      final lerpAT = decoration.lerpFrom(anotherBaseDecoration, 0.5);
      expect(lerpAT, isNotNull);

      const anotherBoxDecoration = BoxDecoration();
      final lerpFromSuper = decoration.lerpFrom(anotherBoxDecoration, 0.5);
      expect(lerpFromSuper, isNull);
    });

    testWidgets('hashCode function', (WidgetTester tester) async {
      const hashCodeWithDefaultConstructor = 81498275;
      expect(decoration.hashCode, hashCodeWithDefaultConstructor);
    });

    testWidgets('operator function', (WidgetTester tester) async {
      const boxDecoration = BoxDecoration();
      expect(decoration == boxDecoration, false);

      const anotherBaseDecoration = BaseBoxDecoration(
        gradient: RadialGradient(colors: [Colors.blue, Colors.blueGrey]),
      );
      final result = decoration == anotherBaseDecoration;
      expect(result, false);
    });

    testWidgets('lerpTo function', (WidgetTester tester) async {
      final result = decoration.lerpTo(null, 0.5);
      expect(result, isNotNull);

      const anotherBaseDecoration = BaseBoxDecoration();
      final result1 = decoration.lerpTo(anotherBaseDecoration, 0.5);
      expect(result1, isNotNull);

      const boxDecoration = BoxDecoration();
      final result2 = decoration.lerpTo(boxDecoration, 0.5);
      expect(result2, isNull);
    });

    testWidgets('hitTest function', (WidgetTester tester) async {
      final result = decoration.hitTest(const Size(100, 100), Offset.zero);
      expect(result, true);

      final result1 = decoration
          .copyWith(borderRadius: const BorderRadius.all(Radius.circular(5)))
          .hitTest(const Size(100, 100), Offset.zero);
      expect(result1, false);
    });
  });
}
