import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('ImportedTag', () {
    testWidgets('renders importedTag', (tester) async {
      await tester.pumpApp(const ImportedTag());
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders value correctly', (tester) async {
      await tester.pumpApp(const ImportedTag());
      expect(find.text('IMPORTED'), findsOneWidget);
    });
  });
}
