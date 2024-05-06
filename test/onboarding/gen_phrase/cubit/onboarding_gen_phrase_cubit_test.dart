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
          '''{"kty":"OKP","crv":"Ed25519","d":"xgGv1OK9734J-_INYW3Ff7m0Cpkfhucx2Tg1w3LUOKI=","x":"tZT6dwnPD87v2MCzAlzPsrT6l06_YyyUsk-Y-mnR0sU="}''';
      expect(jwk, equals(expectedJwk));
    });

    test('address', () async {
      final address = await keyGenerator.walletAddressFromMnemonic(
        mnemonic: mnemonic,
        accountType: AccountType.tezos,
      );
      const expectedAddress = 'tz1guoPjyUSs5N6UWoMxESSyPyUTJwqDgS3d';
      expect(address, equals(expectedAddress));
    });

    test('secret key', () async {
      final secretKey = await keyGenerator.secretKeyFromMnemonic(
        mnemonic: mnemonic,
        accountType: AccountType.ethereum,
      );
      const expectedSecretKey =
          '''0xc9d610aaf2b4c20b805a1e877637433d63f03c5a0d68d744e9e524efdd7259fd''';
      expect(secretKey, equals(expectedSecretKey));
    });
  });
  group('from secretKey : Tezos', () {
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
        accountType: AccountType.tezos,
      );

      const expectedAddress = 'tz1NvqicaUW7v6sEbM4UYi3Wes7GHDft4kqY';
      expect(address, equals(expectedAddress));
    });
  });
}
