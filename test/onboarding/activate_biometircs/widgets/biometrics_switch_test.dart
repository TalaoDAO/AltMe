import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BiometricsSwitch', () {
    testWidgets('renders value correctly', (tester) async {
      await tester.pumpApp(const BiometricsSwitch(value: true));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  IconStrings.fingerprint2,
        ),
        findsOneWidget,
      );
      expect(find.byType(CupertinoSwitch), findsOneWidget);
    });
  });
}
