import 'package:altme/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('StringExtension', () {
    test('formatNumber formats numbers correctly', () {
      expect('1000'.formatNumber, equals('1,000'));
      expect('123456789'.formatNumber, equals('123,456,789'));
      expect('12345.6789'.formatNumber, equals('12,345.6789'));
      expect('0.12345'.formatNumber, equals('0.12345'));
      expect('123'.formatNumber, equals('123'));
      expect('abc'.formatNumber, equals('abc'));
    });

    test('isValidEmail validates email addresses', () {
      expect('email@example.com'.isValidEmail(), true);
      expect('invalid.email@'.isValidEmail(), false);
      expect('another.invalid.email@domain'.isValidEmail(), false);
    });

    test('char2Bytes converts string to hex bytes', () {
      expect('hello'.char2Bytes, '68656c6c6f');
      expect(''.char2Bytes, '');
    });

    test('isEVM identifies EVM-based currencies', () {
      expect('ETH'.isEVM, true);
      expect('MATIC'.isEVM, true);
      expect('FTM'.isEVM, true);
      expect('BNB'.isEVM, true);
      expect('BTC'.isEVM, false);
    });

    test('decimalNumber formats decimal numbers correctly', () {
      expect('123.456'.decimalNumber(2), '123.45');
      expect('123.456'.decimalNumber(4), '123.456');
      expect('123'.decimalNumber(3), '123');
    });

    test('invalid decimalNumber throws FormatException', () {
      expect(() => 'abc'.decimalNumber(2), throwsFormatException);
    });

    test('Characters getter returns correct characters', () {
      const input = 'Hello, world!';
      final characters = input.characters;

      expect(characters.length, input.length);

      for (int i = 0; i < input.length; i++) {
        expect(characters.elementAt(i), input[i]);
      }
    });
  });
}
