import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BigIntExtension', () {
    test('toBytes converts BigInt to byte list', () {
      final bigInt = BigInt.from(16909060); // Example value: 0x01020304
      final bytes = bigInt.toBytes;
      expect(bytes, [1, 2, 3, 4]);
    });

    test('toBytes returns empty list for zero', () {
      final bigInt = BigInt.zero;
      final bytes = bigInt.toBytes;
      expect(bytes, <int>[]);
    });

    test('toBytes handles large BigInt values', () {
      final bigInt = BigInt.parse('123456789012345678901234567890');
      final bytes = bigInt.toBytes;
      expect(bytes, [
        1,
        142,
        233,
        15,
        246,
        195,
        115,
        224,
        238,
        78,
        63,
        10,
        210,
      ]);
    });
  });
}
