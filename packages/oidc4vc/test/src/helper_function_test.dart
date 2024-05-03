import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/src/helper_function.dart';

void main() {
  group('listToString', () {
    test('converts list of strings to a single string with spaces', () {
      final inputList = ['This', 'is', 'Bibash'];
      expect(listToString(inputList), 'This is Bibash');
    });

    test('converts list of numbers to a single string with spaces', () {
      final inputList = [1, 2, 3, 4];
      expect(listToString(inputList), '1 2 3 4');
    });

    test('returns empty string for empty input list', () {
      final inputList = <String>[];
      expect(listToString(inputList), '');
    });
  });
}
