import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:blake2b/blake2b_hash.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
// import 'package:blake_hash/blake_hash.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
import 'package:tezart/tezart.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  group('Keys from seed', () {
    test('Generate ', () {
      String computeKeyHash(
        Uint8List publicKey,
      ) {
        Uint8List blake2bHash = Blake2bHash.hashWithDigestSize(160, publicKey);
        String uintToString = String.fromCharCodes(blake2bHash);
        String stringToHexString = hex.encode(uintToString.codeUnits);
        String finalStringToDecode = "06a19f" + stringToHexString;
        List<int> listOfHexDecodedInt = hex.decode(finalStringToDecode);
        String publicKeyHash =
            bs58check.encode(listOfHexDecodedInt as Uint8List);
        return publicKeyHash;
      }

      final publicKey = 'zQ3shvfPfZmMgTTGoREXbLqUq5evxZ5cU6KCTPRHHtcefbYYA';
      final address = computeKeyHash(Uint8List.fromList(publicKey.codeUnits));
      print('address: $address');

      final temple_private_key =
          "edskRzfJzQnyKWr4qP4rUipDfTNCXJGxBW91m5HtgTYS92MmWo1tUge6nXkumkrNqDa767qPgqiJQaqNfmjebFJUc96JmuBLQn";
// For information : this the address read on Temple associated with the previous encoded secret key  -> tz1Q7zwo7fmRNyCL7jdz6hcPSsYukkWY66Q3
      final keystore = Keystore.fromSecretKey(temple_private_key);
      final newPublicKey = keystore.publicKey;
      // final newAddress =
      //     computeKeyHash(Uint8List.fromList(newPublicKey.codeUnits));
      print('newAddress: ${keystore.address}}');

// Sample output of keystore created from secretkey
      print(keystore.secretKey);
      // => edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
      // => edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
      print(keystore.address);
      expect(keystore.address, equals('tz1Q7zwo7fmRNyCL7jdz6hcPSsYukkWY66Q3'));
      // => tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW
      final mnemonic =
          'notice photo opera keen climb agent soft parrot best joke field devote';
      final seed = bip39.mnemonicToSeed(mnemonic);
      final finalKeystoreJoke = Keystore.fromMnemonic(mnemonic);
      print(finalKeystoreJoke.address);

      //[105, 104, 114, 235, 191, 74, 81, 25, 186, 14, 224, 98, 187, 127, 45, 150,
      // 115, 57, 174, 200, 238, 175, 36, 200, 142, 171, 91, 50, 40, 188, 126, 59,
      // 73, 165, 227, 3, 92, 110, 15, 220, 157, 233, 140, 87, 195, 12, 91, 90,
      // 165, 113, 52, 220, 139, 101, 206, 246, 2, 182, 24, 189, 73, 225, 195, 72]

      final rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'

      // final keystoreFromSecretKey =
      //     Keystore.fromSecretKey(rootKey.privateKey.toString());
      // print(keystoreFromSecretKey.address);
    });
  });
}
