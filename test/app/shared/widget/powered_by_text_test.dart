import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('PoweredByText', () {
    testWidgets('renders PoweredByText', (tester) async {
      await tester.pumpApp(const PoweredByText());
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders value correctly', (tester) async {
      await tester.pumpApp(const PoweredByText());
      expect(find.text('Powered By ${Parameters.appName}'), findsOneWidget);
    });
  });
}
