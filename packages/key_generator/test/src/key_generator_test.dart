import 'package:key_generator/key_generator.dart';
import 'package:test/test.dart';

void main() {
  const mnemonics =
      '''notice photo opera keen climb agent soft parrot best joke field devote''';

  const ssiKey =
      '''{"kty":"OKP","crv":"Ed25519","d":"FQ6QvXKVC8L5UY4OmCtfdbLjmhtAabqPoUm2deK4bdc=","x":"ZA15LrvBd_70rG3zxB5KPdlpycaRwugu09HwHnk2bhc="}''';

  const derivePathIndex = 1;

  const tezosKey =
      '''{"kty":"OKP","crv":"Ed25519","d":"R3EkC6pstGOD4ack_kd-FKfNb3nQGU6_WFfQx19FTz4=","x":"SrGkTJUiF4Jjd7m-fyQCOSNjjMKB9toKQaLg2oXofsU="}''';

  const tezosSecretKey =
      '''edskRmMt7hoSTXrtPMm1YSXFH8YNzeYCwxQaYy7oKn6bRiGnHXAJiuytciwz1asgUHwLJgCo4qhXpKxSsdGd6tW8ukYHAP4sxu''';
  const ethereumSecretKey =
      '''0xa454990a45b01b0c5cb158b8d9520f093c57834b8c8925dd4b3097e3335b92b7''';

  const tezosWalletAddress = 'tz1eefuZwhS9yRL3A7fiZS2SdsPC3mKLek8z';
  const ethereumWalletAddress = '0x83a8b974ce789a34d2d2518475f4c8460016dc6c';

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

      test('throw Exception for wallet address from mnemonics', () async {
        expect(
          () => keyGenerator.walletAddressFromMnemonic(
            mnemonic: mnemonics,
            accountType: AccountType.ssi,
            derivePathIndex: derivePathIndex,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('throw Exception for secretKey from mnemonics', () async {
        expect(
          () => keyGenerator.walletAddressFromSecretKey(
            secretKey: ethereumSecretKey,
            accountType: AccountType.ssi,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('throw Exception for secretKey from mnemonics', () async {
        expect(
          () => keyGenerator.secretKeyFromMnemonic(
            mnemonic: mnemonics,
            accountType: AccountType.ssi,
            derivePathIndex: derivePathIndex,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('tezos', () {
      test('key from mnemonics for tezos', () async {
        final key = await keyGenerator.jwkFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.tezos,
          derivePathIndex: derivePathIndex,
        );
        expect(key, tezosKey);
      });

      test('secretKey from mnemonics for tezos ', () async {
        final secretKey = await keyGenerator.secretKeyFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.tezos,
          derivePathIndex: derivePathIndex,
        );
        expect(secretKey, tezosSecretKey);
      });

      test('tz1 wallet address from mnemonics for tezos', () async {
        final walletAddress = await keyGenerator.walletAddressFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.tezos,
          derivePathIndex: derivePathIndex,
        );
        expect(walletAddress, tezosWalletAddress);
      });

      test('tz1 wallet address from secret key for tezos', () async {
        final walletAddress = await keyGenerator.walletAddressFromSecretKey(
          secretKey: tezosSecretKey,
          accountType: AccountType.tezos,
        );
        expect(walletAddress, tezosWalletAddress);
      });
    });

    group('ethereum', () {
      test('throw Exception for secretKey from ethereum', () async {
        expect(
          () => keyGenerator.jwkFromMnemonic(
            mnemonic: mnemonics,
            accountType: AccountType.ethereum,
            derivePathIndex: derivePathIndex,
          ),
          throwsA(isA<Exception>()),
        );
      });
      test('0x wallet address from mnemonics for ethereum', () async {
        final walletAddress = await keyGenerator.walletAddressFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.ethereum,
          derivePathIndex: derivePathIndex,
        );
        expect(walletAddress, ethereumWalletAddress);
      });

      test('secretKey from mnemonics for ethereum ', () async {
        final secretKey = await keyGenerator.secretKeyFromMnemonic(
          mnemonic: mnemonics,
          accountType: AccountType.ethereum,
          derivePathIndex: derivePathIndex,
        );
        expect(secretKey, ethereumSecretKey);
      });

      test('0x wallet address from secret key for ethereum', () async {
        final walletAddress = await keyGenerator.walletAddressFromSecretKey(
          secretKey: ethereumSecretKey,
          accountType: AccountType.ethereum,
        );
        expect(walletAddress, ethereumWalletAddress);
      });
    });
  });
}
