import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('BatchCountBadge', () {
    testWidgets('shows the number of copies', (tester) async {
      await tester.pumpApp(const Scaffold(body: BatchCountBadge(count: 10)));

      expect(find.text('×10'), findsOneWidget);
    });

    testWidgets('reads the number of single-use copies to screen readers', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(const Scaffold(body: BatchCountBadge(count: 3)));

      expect(find.bySemanticsLabel('3 single-use copies'), findsOneWidget);
      handle.dispose();
    });
  });
}
