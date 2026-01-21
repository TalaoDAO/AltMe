import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('ShareButton', () {
    testWidgets('ShareButton displays the correct icon and text', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(const Scaffold(body: ShareButton()));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets('ShareButton responds to tap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpApp(
        Scaffold(
          body: ShareButton(
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });
  });
}
