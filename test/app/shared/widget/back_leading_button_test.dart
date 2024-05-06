import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BackLeadingButton', () {
    testWidgets('pops when IconButton is tapped', (tester) async {
      bool popTriggered = false;

      await tester.pumpApp(
        BackLeadingButton(
          onPressed: () {
            popTriggered = true;
          },
        ),
      );
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(popTriggered, isTrue);
    });
  });
}
