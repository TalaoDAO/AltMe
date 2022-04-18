import 'package:altme/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseBoxDecoration class', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                decoration: const BaseBoxDecoration(),
              ),
            ),
          ),
        ),
      );

      final result = find.byElementPredicate(
        (element) =>
            (element is Container) &&
            ((element as Container).decoration is BaseBoxDecoration),
      );
      expect(result, greaterThan(0));
    });
  });
}
