import 'dart:typed_data';
import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uint8ListExtension', () {
    test(
        'filterPayload returns the original list '
        'if length is less than or equal to 6', () {
      final list = Uint8List.fromList([1, 2, 3]);
      expect(list.filterPayload, list);

      final shortList = Uint8List.fromList([1, 2, 3, 4, 5, 6]);
      expect(shortList.filterPayload, shortList);
    });

    test(
        'filterPayload returns the original list '
        'if the first two elements do not match the test list', () {
      final list = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9]);
      expect(list.filterPayload, list);

      final differentFirstElement =
          Uint8List.fromList([6, 1, 3, 4, 5, 6, 7, 8, 9]);
      expect(differentFirstElement.filterPayload, differentFirstElement);

      final differentSecondElement =
          Uint8List.fromList([5, 5, 3, 4, 5, 6, 7, 8, 9]);
      expect(differentSecondElement.filterPayload, differentSecondElement);
    });

    test(
        'filterPayload returns a sublist starting from index 6 '
        'if the first two elements match the test list', () {
      final list = Uint8List.fromList([5, 1, 3, 4, 5, 6, 7, 8, 9]);
      final expected = Uint8List.fromList([7, 8, 9]);
      expect(list.filterPayload, expected);
    });
  });
}
