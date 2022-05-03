import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mnemonic =
      'notice photo opera keen climb agent soft parrot best joke field devote';

  const message = '{"name": "My name is Bibash."}';
  const cipherText = '¨`ýp<ÐW3AR1¯#.í©¥¿e,|VrtuXÅ';
  const authenticationTag = 'äU~ÇÍÞ¦BÌuDÅ';
  const encryptionModelJson = {
    'cipherText': cipherText,
    'authenticationTag': authenticationTag
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
      expect(generatedKey.privateKey.hashCode, equals(1100798733));
      expect(generatedKey.publicKey.hashCode, equals(1100798733));
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

    test('invalid cipherText throws Auth message', () async {
      const inCipherText = '123';
      const encryption = Encryption(
        cipherText: inCipherText,
        authenticationTag: authenticationTag,
      );
      try {
        await cryptocurrencyKeys.decrypt(mnemonic, encryption);
      } catch (e) {
        final error = e.toString().startsWith('Auth message');
        expect(error, true);
      }
    });

    test('invalid authenticationTag throws Auth message', () async {
      const inValidAuthenticationTag = '123';
      const encryption = Encryption(
        cipherText: cipherText,
        authenticationTag: inValidAuthenticationTag,
      );
      try {
        await cryptocurrencyKeys.decrypt(mnemonic, encryption);
      } catch (e) {
        final error = e.toString().startsWith('Auth message');
        expect(error, true);
      }
    });
  });
}
