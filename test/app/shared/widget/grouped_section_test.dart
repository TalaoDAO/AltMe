import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  testWidgets('GroupedSection renders children correctly', (
    WidgetTester tester,
  ) async {
    final testChildren = <Widget>[
      const Text('Child 1'),
      const Text('Child 2'),
      const Text('Child 3'),
    ];

    await tester.pumpApp(
      Scaffold(body: GroupedSection(children: testChildren)),
    );

    // Verify the children are displayed
    for (final child in testChildren) {
      expect(find.byWidget(child), findsOneWidget);
    }
  });
}
