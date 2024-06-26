import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

class WalletAddressValidatorImpl with WalletAddressValidator {}

void main() {
  group('WalletAddressValidator', () {
    late WalletAddressValidatorImpl validator;

    setUp(() {
      validator = WalletAddressValidatorImpl();
    });

    test('returns false for null address', () {
      expect(validator.validateWalletAddress(null), isFalse);
    });

    test('returns false for empty address', () {
      expect(validator.validateWalletAddress(''), isFalse);
    });

    test('returns true for valid Ethereum address', () {
      expect(
        validator.validateWalletAddress(
          '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
        ),
        isTrue,
      );
    });

    test('returns false for invalid Ethereum address', () {
      expect(validator.validateWalletAddress('0x123'), isFalse);
    });

    test('returns true for valid Tezos address', () {
      expect(
        validator.validateWalletAddress('tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb'),
        isTrue,
      );
    });

    test('returns false for invalid Tezos address', () {
      expect(validator.validateWalletAddress('tz1short'), isFalse);
    });

    test('returns false for unsupported blockchain address', () {
      expect(validator.validateWalletAddress('abc123'), isFalse);
    });
  });
}
