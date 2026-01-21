import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  testWidgets('MnemonicDisplay shows the correct words', (
    WidgetTester tester,
  ) async {
    final mnemonic = [
      'apple',
      'banana',
      'cherry',
      'date',
      'elderberry',
      'fig',
      'grape',
      'honeydew',
      'kiwi',
      'lemon',
      'mango',
      'nectarine',
    ];

    await tester.pumpApp(Scaffold(body: MnemonicDisplay(mnemonic: mnemonic)));

    await tester.pumpAndSettle();

    for (int i = 0; i < mnemonic.length; i++) {
      expect(find.text('${i + 1}. ${mnemonic[i]}'), findsOneWidget);
    }
  });
}
