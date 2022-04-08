import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BackLeadingButton', () {
    testWidgets('pops when IconButton is tapped', (tester) async {
      final MockNavigator navigator = MockNavigator();
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: const Material(
            child: BackLeadingButton(),
          ),
        ),
      );
      await tester.tap(find.byType(IconButton));
      verify(navigator.pop).called(1);
    });
  });
}
