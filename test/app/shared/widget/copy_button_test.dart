import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('CopyButton', () {
    testWidgets('CopyButton displays correctly', (tester) async {
      await tester.pumpApp(const Scaffold(body: CopyButton()));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
    });

    testWidgets('CopyButton responds to tap correctly', (tester) async {
      bool triggerred = false;
      await tester.pumpApp(
        Scaffold(
          body: CopyButton(
            onTap: () {
              triggerred = true;
            },
          ),
        ),
      );
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(triggerred, isTrue);
    });
  });
}
