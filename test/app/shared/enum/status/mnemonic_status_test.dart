import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MnemonicStatus Extension Test', () {
    test('showOrder should return correct value for each status', () {
      expect(MnemonicStatus.unselected.showOrder, false);
      expect(MnemonicStatus.selected.showOrder, true);
      expect(MnemonicStatus.wrongSelection.showOrder, false);
    });

    test('color should return correct color for each status', () {
      expect(MnemonicStatus.unselected.color, const Color(0xff86809D));
      expect(MnemonicStatus.selected.color, const Color(0xff6600FF));
      expect(MnemonicStatus.wrongSelection.color, const Color(0xffFF0045));
    });
  });
}
