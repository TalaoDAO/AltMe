import 'package:key_generator/key_generator.dart';
import 'package:test/test.dart';

void main() {
  const mnemonics =
      '''notice photo opera keen climb agent soft parrot best joke field devote''';

  const ssiKey =
      '''{"kty":"OKP","crv":"Ed25519","d":"hqt8zD2FI57cBBAzzeYx4fLszgS1s33zu4kZ_AHjATI=","x":"W3ydcmeAyZurKf7FRmN8sAj5-fiuOkDNX-LaYFd5urQ="}''';

  const derivePathIndex = 1;
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
    });

    group('crypto', () {
      test('key from mnemonics for crypto', () async {
        final key = await keyGenerator.jwkFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.crypto,
          derivePathIndex: derivePathIndex,
        );
        expect(key, cryptoKey);
      });

      test('secretKey from mnemonics for crypto', () async {
        final secretKey = await keyGenerator.secretKeyFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.crypto,
          derivePathIndex: derivePathIndex,
        );
        expect(secretKey, cryptoSecretKey);
      });

      test('tz1 wallet address from mnemonics for crypto', () async {
        final walletAddress = await keyGenerator.tz1AddressFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.crypto,
          derivePathIndex: derivePathIndex,
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
