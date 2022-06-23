// ignore_for_file: prefer_const_constructors
import 'package:key_generator/key_generator.dart';
import 'package:test/test.dart';

void main() {
  const mnemonics =
      '''notice photo opera keen climb agent soft parrot best joke field devote''';

  const ssiSecretKey =
      '''{"kty":"OKP","crv":"Ed25519","d":"hqt8zD2FI57cBBAzzeYx4fLszgS1s33zu4kZ_AHjATI=","x":"W3ydcmeAyZurKf7FRmN8sAj5-fiuOkDNX-LaYFd5urQ="}''';

  const cryptoLength = 1;

  const cryptoSecretKey =
      '''{"kty":"OKP","crv":"Ed25519","d":"xmYPuZdc1LwVYshIUdto7I8psjb9zgPrUblAp5w7qws=","x":"uCURp8D_ilizA32RCZi1UFoYdq0HmI_KE8RBbG19ZrU="}''';

  const ssiWalletAddress = 'tz1Szsu5oe5rqjDh1XcY6XpGWM5MHQKR9gnJ';
  group('KeyGenerator', () {
    late KeyGenerator keyGenerator;

    setUpAll(() {
      keyGenerator = KeyGenerator();
    });

    test('can be instantiated', () {
      keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonics,
        accountType: AccountType.ssi,
      );
      expect(keyGenerator, isNotNull);
    });

    test('key from mnemonics for ssi', () async {
      final secretKey = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonics,
        accountType: AccountType.ssi,
      );
      expect(secretKey, ssiSecretKey);
    });

    test('key from mnemonics for crypto', () async {
      final secretKey = await keyGenerator.jwkFromMnemonic(
        mnemonic: mnemonics,
        accountType: AccountType.crypto,
        cryptoAccountLength: cryptoLength,
      );
      expect(secretKey, cryptoSecretKey);
    });

    test('tz1 wallet address from mnemonics for ssi', () async {
      final walletAddress = await keyGenerator.tz1AddressFromMnemonic(
        mnemonic: mnemonics,
        accountType: AccountType.ssi,
      );
      expect(walletAddress, ssiWalletAddress);
    });

    //test tz1 wallet address from secret key
  });
}
