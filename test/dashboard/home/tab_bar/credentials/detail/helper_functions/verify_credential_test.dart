import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('verify_credential helper functions', () {
    test('getBit returns correct bit for index 0 and given encoded list', () {
      // Arrange
      const int index = 1;
      const String encodedList = 'H4sIAAMY_WcC_2NgGFgAAJ36qMKAAAAA';

      // Act
      final result = getBit(index: index, encodedList: encodedList);
      // Assert
      expect(
        result,
        equals(0),
      ); // Expected value based on the given encodedList
    });
  });
}
