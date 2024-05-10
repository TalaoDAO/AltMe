import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IterableExtension', () {
    test('firstWhereOrNull returns first element that satisfies the condition',
        () {
      final list = [1, 2, 3, 4, 5];
      expect(list.firstWhereOrNull((element) => element.isOdd), 1);
      expect(list.firstWhereOrNull((element) => element.isEven), 2);
    });

    test('firstWhereOrNull returns null if no element satisfies the condition',
        () {
      final list = [1, 3, 5, 7, 9];
      expect(list.firstWhereOrNull((element) => element.isEven), null);
    });

    test('lastWhereOrNull returns last element that satisfies the condition',
        () {
      final list = [1, 2, 3, 4, 5];
      expect(list.lastWhereOrNull((element) => element.isOdd), 5);
      expect(list.lastWhereOrNull((element) => element.isEven), 4);
    });

    test('lastWhereOrNull returns null if no element satisfies the condition',
        () {
      final list = [1, 3, 5, 7, 9];
      expect(list.lastWhereOrNull((element) => element.isEven), null);
    });

    test('lastWhereOrNull returns null for empty iterable', () {
      final list = <int>[];
      expect(list.lastWhereOrNull((element) => true), null);
    });
  });
}
