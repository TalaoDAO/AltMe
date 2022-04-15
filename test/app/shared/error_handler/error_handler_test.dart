import 'package:altme/app/shared/error_handler/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('ErrorHandler Test', () {
    testWidgets('returns Unknown error', (tester) async {
      final ErrorHandler errorHandler = ErrorHandler();
      await tester.pumpApp(Container());
      final BuildContext context = tester.element(find.byType(Container));
      final String text = errorHandler.getErrorMessage(context, errorHandler);
      expect(text, 'Unknown error');
    });
  });
}
