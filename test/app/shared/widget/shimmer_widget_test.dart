import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helpers/helpers.dart';

void main() {
  group('ShimmerWidget', () {
    testWidgets('ShimmerWidget.rectangular displays correctly',
        (WidgetTester tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: ShimmerWidget.rectangular(height: 100),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);

      final constraints =
          tester.firstWidget<Container>(find.byType(Container)).constraints;
      expect(constraints!.minWidth, double.infinity);
      expect(constraints.maxWidth, double.infinity);
      expect(constraints.minHeight, 100.0);
      expect(constraints.maxHeight, 100.0);

      final container = tester.widget<Container>(find.byType(Container));

      final shapeDecoration = container.decoration! as ShapeDecoration;
      expect(shapeDecoration.shape, isA<RoundedRectangleBorder>());
      final roundedRectBorder = shapeDecoration.shape as RoundedRectangleBorder;
      expect(
        roundedRectBorder.borderRadius,
        const BorderRadius.all(Radius.circular(10)),
      );
    });

    testWidgets('ShimmerWidget.circular displays correctly',
        (WidgetTester tester) async {
      await tester.pumpApp(
        const Scaffold(body: ShimmerWidget.circular(height: 100)),
      );

      expect(find.byType(Shimmer), findsOneWidget);

      final constraints =
          tester.firstWidget<Container>(find.byType(Container)).constraints;
      expect(constraints!.minWidth, double.infinity);
      expect(constraints.maxWidth, double.infinity);
      expect(constraints.minHeight, 100.0);
      expect(constraints.maxHeight, 100.0);

      final container = tester.widget<Container>(find.byType(Container));
      final shapeDecoration = container.decoration! as ShapeDecoration;
      expect(shapeDecoration.shape, isA<CircleBorder>());
    });
  });
}
