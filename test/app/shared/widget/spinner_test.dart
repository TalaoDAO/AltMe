import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('Spinner', () {
    testWidgets('renders spinner', (tester) async {
      await tester.pumpApp(const Spinner());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders value correctly', (tester) async {
      await tester.pumpApp(const Spinner());
      final progressWidget = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final BuildContext context =
          tester.element(find.byType(CircularProgressIndicator));

      expect(progressWidget.strokeWidth, 3.0);
      expect(
        progressWidget.valueColor?.value,
        Theme.of(context).colorScheme.primary,
      );
    });
  });
}
