import 'package:altme/app/shared/message_handler/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('MessageHandler Test', () {
    testWidgets('returns Unknown message', (tester) async {
      final MessageHandler messageHandler = MessageHandler();
      await tester.pumpApp(Container());
      final BuildContext context = tester.element(find.byType(Container));
      final String text = messageHandler.getMessage(context, messageHandler);
      expect(text, 'Unknown message');
    });
  });
}
