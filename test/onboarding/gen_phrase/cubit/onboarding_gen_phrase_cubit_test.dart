import 'package:flutter_test/flutter_test.dart';
import 'package:key_generator/key_generator.dart';

Future<void> main() async {
  final keyGenerator = KeyGenerator();
  group('from mnemonic for ssi', () {
    const String mnemonic =
        '''brief hello carry loop squeeze unknown click abstract lounge figure logic oblige child ripple about vacant scheme magnet open enroll stuff valve hobby what''';

    test('jwk', () async {
      final jwk = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonic,
        accountType: AccountType.ssi,
      );
      const expectedJwk =
          '''{"kty":"OKP","crv":"Ed25519","d":"cMGD8eAmjDn6MqvJoscsaPoyAMrjG41xbLDfE-uQkYw=","x":"-PeGBkVyMz2-yketwH2lbQqiflneee3jmaTafMCsURE="}''';
      expect(jwk, equals(expectedJwk));
    });

    test('address', () async {
      final address = await keyGenerator.walletAddressFromMnemonic(
        mnemonic: mnemonic,
        accountType: AccountType.ssi,
      );
      const expectedAddress = 'tz1NvqicaUW7v6sEbM4UYi3Wes7GHDft4kqY';
      expect(address, equals(expectedAddress));
    });

    test('secret key', () async {
      final secretKey = await keyGenerator.secretKeyFromMnemonic(
        mnemonic: mnemonic,
        accountType: AccountType.ssi,
      );
      const expectedSecretKey =
          '''edskRrmNgPfAAvbZyzTptfvTju9X7ooLR5VVN9u8sXA42hXdMBd8CgrhykP7sZQf8hWLCYuqfEoWUFzL6Us3aKtMD9NsELGkuP''';
      expect(secretKey, equals(expectedSecretKey));
    });
  });
  group('from secretKey', () {
    const String secretKey =
        '''edskRrmNgPfAAvbZyzTptfvTju9X7ooLR5VVN9u8sXA42hXdMBd8CgrhykP7sZQf8hWLCYuqfEoWUFzL6Us3aKtMD9NsELGkuP''';

    test('jwk', () async {
      final jwk = await keyGenerator.jwkFromSecretKey(
        secretKey: secretKey,
        accountType: AccountType.tezos,
      );
      const expectedJwk =
          '''{"kty":"OKP","crv":"Ed25519","d":"cMGD8eAmjDn6MqvJoscsaPoyAMrjG41xbLDfE-uQkYw=","x":"-PeGBkVyMz2-yketwH2lbQqiflneee3jmaTafMCsURE="}''';
      expect(jwk, equals(expectedJwk));
    });

    test('address', () async {
      final address = await keyGenerator.walletAddressFromSecretKey(
        secretKey: secretKey,
        accountType: AccountType.ssi,
      );
      const expectedAddress = 'tz1NvqicaUW7v6sEbM4UYi3Wes7GHDft4kqY';
      expect(address, equals(expectedAddress));
    });
  });
}
