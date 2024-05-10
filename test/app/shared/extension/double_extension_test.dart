import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoubleExtension', () {
    test('decimalNumber returns string with specified decimal places', () {
      const value = 3.14159;
      expect(value.decimalNumber(2), '3.14');
    });

    test('decimalNumber handles values with fewer decimal places', () {
      const value = 123.4512;
      expect(value.decimalNumber(4), '123.4512');
    });

    test('decimalNumber handles values with fewer decimal places with 0s', () {
      const value = 123.4500;
      expect(value.decimalNumber(4), '123.45');
    });

    test('decimalNumber handles values with more decimal places', () {
      const value = 0.123456789;
      expect(value.decimalNumber(5), '0.12345');
    });

    test('decimalNumber returns 0.00 for zero', () {
      const value = 0.0;
      expect(value.decimalNumber(2), '0.0');
    });

    test('decimalNumber handles negative values', () {
      const value = -12.3456;
      expect(value.decimalNumber(3), '-12.346');
    });

    test('decimalNumber handles large values', () {
      const value = 987654321.987656321;
      expect(value.decimalNumber(5), '987654321.98765');
    });
  });
}
