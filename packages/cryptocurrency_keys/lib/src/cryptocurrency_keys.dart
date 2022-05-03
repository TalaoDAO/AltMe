import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto_keys/crypto_keys.dart';
import 'package:cryptocurrency_keys/src/model/encryption.dart';

export 'model/encryption.dart';

/// {@template cryptocurrency_keys}
/// Cryptocurrency keys package
/// {@endtemplate}
class CryptocurrencyKeys {
  /// {@macro cryptocurrency_keys}
  const CryptocurrencyKeys();

  ///ivVector
  static const String ivVector = 'altme';

  ///additionalAuthenticatedData
  static const String additionalAuthenticatedData = 'Credible';

  ///generateKeyPair
  Future<KeyPair> generateKeyPair(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);

    final rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'

    // derive path for ethereum '60' see bip 44, first address
    final child = rootKey.derivePath("m/44'/60'/0'/0/0"); //Instance of 'BIP32'

    final privateKey = child.privateKey!;
    //[44, 254, 73, 198, 41, 37, 89, 193, 190, 104, 116, 244, 188, 50, 31, 128,
    // 25, 101, 57, 132, 49, 132, 105, 153, 166, 32, 39, 237, 145, 88, 63, 154]

    final key = SymmetricKey(keyValue: privateKey);

    final keyPair = KeyPair.symmetric(key);
    return keyPair;
  }

  ///encrypt
  Future<Encryption> encrypt(String message, String mnemonic) async {
    final keyPair = await generateKeyPair(mnemonic);
    final encryptor =
        keyPair.publicKey!.createEncrypter(algorithms.encryption.aes.gcm);
    final encryptedBytes = encryptor.encrypt(
      Uint8List.fromList(message.codeUnits),
      additionalAuthenticatedData:
          Uint8List.fromList(additionalAuthenticatedData.codeUnits),
      initializationVector: Uint8List.fromList(ivVector.codeUnits),
    );
    return Encryption(
      cipherText: String.fromCharCodes(encryptedBytes.data),
      authenticationTag:
          String.fromCharCodes(encryptedBytes.authenticationTag!),
    );
  }

  ///decrypt
  Future<String> decrypt(String mnemonic, Encryption encryption) async {
    final keyPair = await generateKeyPair(mnemonic);
    final decryptor =
        keyPair.privateKey!.createEncrypter(algorithms.encryption.aes.gcm);

    final decryptedBytes = decryptor.decrypt(
      EncryptionResult(
        Uint8List.fromList(encryption.cipherText!.runes.toList()),
        authenticationTag:
            Uint8List.fromList(encryption.authenticationTag!.runes.toList()),
        additionalAuthenticatedData:
            Uint8List.fromList(additionalAuthenticatedData.codeUnits),
        initializationVector: Uint8List.fromList(ivVector.codeUnits),
      ),
    );

    final decryptedString = String.fromCharCodes(decryptedBytes);
    return decryptedString;
  }
}
