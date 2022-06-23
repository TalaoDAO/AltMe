// ignore_for_file: prefer_const_constructors
import 'package:key_generator/key_generator.dart';
import 'package:test/test.dart';

void main() {
  const mnemonics =
      '''notice photo opera keen climb agent soft parrot best joke field devote''';

  const ssiKey =
      '''{"kty":"OKP","crv":"Ed25519","d":"hqt8zD2FI57cBBAzzeYx4fLszgS1s33zu4kZ_AHjATI=","x":"W3ydcmeAyZurKf7FRmN8sAj5-fiuOkDNX-LaYFd5urQ="}''';
  const ssiSecretKey =
      '''edskRudfATJv3uyShVpc5NJrBhkXQwinQA5MYhThXkaD8pRRtCCbexknVkz3hDQYTRk82E433oSQK4ts1tGsqtEYdPAMW3B6cB''';
  const ssiWalletAddress = 'tz1Szsu5oe5rqjDh1XcY6XpGWM5MHQKR9gnJ';

  const cryptoLength = 1;
  const cryptoKey =
      '''{"kty":"OKP","crv":"Ed25519","d":"xmYPuZdc1LwVYshIUdto7I8psjb9zgPrUblAp5w7qws=","x":"uCURp8D_ilizA32RCZi1UFoYdq0HmI_KE8RBbG19ZrU="}''';
  const cryptoSecretKey =
      '''edskS3yEexyuy3fMeW8W2dpLTRvGDN5iah7d3yuy3wyuBPKj3ss7WoZ8o5M1Q9Ztn23Cz7GUPFTpAzxCpyaSoSo4kUSgBZiQ4s''';
  const cryptoWalletAddress = 'tz1iWqPuEAEEcbhWVAL8RpSdrFHxesotnDU2';

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

    group('ssi', () {
      test('key from mnemonics for ssi', () async {
        final key = await keyGenerator.jwkFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.ssi,
        );
        expect(key, ssiKey);
      });

      test('secretKey from mnemonics for ssi', () async {
        final secretKey = await keyGenerator.secretKeyFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.ssi,
        );
        expect(secretKey, ssiSecretKey);
      });

      test('tz1 wallet address from mnemonics for ssi', () async {
        final walletAddress = await keyGenerator.tz1AddressFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.ssi,
        );
        expect(walletAddress, ssiWalletAddress);
      });

      test('tz1 wallet address from mnemonics for ssi', () async {
        final walletAddress = await keyGenerator.tz1AddressFromSecretKey(
          secretKey: ssiSecretKey,
        );
        expect(walletAddress, ssiWalletAddress);
      });
    });

    group('crypto', () {
      test('key from mnemonics for crypto', () async {
        final key = await keyGenerator.jwkFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.crypto,
          cryptoAccountLength: cryptoLength,
        );
        expect(key, cryptoKey);
      });

      test('secretKey from mnemonics for crypto', () async {
        final secretKey = await keyGenerator.secretKeyFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.crypto,
          cryptoAccountLength: cryptoLength,
        );
        expect(secretKey, cryptoSecretKey);
      });

      test('tz1 wallet address from mnemonics for crypto', () async {
        final walletAddress = await keyGenerator.tz1AddressFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.crypto,
          cryptoAccountLength: cryptoLength,
        );
        expect(walletAddress, cryptoWalletAddress);
      });

      test('tz1 wallet address from mnemonics for crypto', () async {
        final walletAddress = await keyGenerator.tz1AddressFromSecretKey(
          secretKey: cryptoSecretKey,
        );
        expect(walletAddress, cryptoWalletAddress);
      });
    });
  });
}
