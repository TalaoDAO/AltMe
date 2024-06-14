import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mnemonic =
      'notice photo opera keen climb agent soft parrot best joke field devote';

  const message = '{"name": "My name is Bibash."}';
  const cipherText = 'Ô\$æ²½-ôÜwÄª8aã~\n'
      'Yyz¶«Þ[f*ýç';
  const authenticationTag = '¸^\x01áAê?^Ü6u¿¡¡S';
  const encryptionModelJson = {
    'cipherText': cipherText,
    'authenticationTag': authenticationTag,
  };

  late CryptocurrencyKeys cryptocurrencyKeys;

  setUpAll(() {
    cryptocurrencyKeys = const CryptocurrencyKeys();
  });

  group('CryptocurrencyKeys', () {
    test('can be instantiated', () {
      expect(cryptocurrencyKeys, isNotNull);
    });

    test('Encryption model', () {
      const encryption = Encryption(
        cipherText: cipherText,
        authenticationTag: authenticationTag,
      );
      expect(encryption.toJson(), encryptionModelJson);

      final encryptionFromJson = Encryption.fromJson(encryptionModelJson);
      expect(encryptionFromJson.cipherText, cipherText);
      expect(encryptionFromJson.authenticationTag, authenticationTag);

      expect(encryption.props, encryptionFromJson.props);
    });

    test(
        'generateKeyPair() should always derive the same keypair when using the'
        ' same mnemonic', () async {
      final generatedKey = await cryptocurrencyKeys.generateKeyPair(mnemonic);
      expect(generatedKey.privateKey.hashCode, equals(264718007));
      expect(generatedKey.publicKey.hashCode, equals(264718007));
    });

    test('response is encrypted correctly', () async {
      final encryptedData = await cryptocurrencyKeys.encrypt(message, mnemonic);

      expect(encryptedData.cipherText, equals(cipherText));
      expect(encryptedData.authenticationTag, equals(authenticationTag));
    });

    test('encrypted data is decrypted correctly', () async {
      const encryption = Encryption(
        cipherText: cipherText,
        authenticationTag: authenticationTag,
      );
      final decryptedData = await cryptocurrencyKeys.decrypt(
        mnemonic,
        encryption,
      );
      expect(decryptedData, equals(message));
    });

    test('invalid cipherText throws Exception', () async {
      const inCipherText = '123';
      const encryption = Encryption(
        cipherText: inCipherText,
        authenticationTag: authenticationTag,
      );

      expect(
        () => cryptocurrencyKeys.decrypt(mnemonic, encryption),
        throwsException,
      );
    });

    test('invalid authenticationTag throws Exception', () async {
      const inValidAuthenticationTag = '123';
      const encryption = Encryption(
        cipherText: cipherText,
        authenticationTag: inValidAuthenticationTag,
      );
      expect(
        () => cryptocurrencyKeys.decrypt(mnemonic, encryption),
        throwsException,
      );
    });
  });
}
