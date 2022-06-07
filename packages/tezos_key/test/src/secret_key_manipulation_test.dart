// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:tezart/tezart.dart';

void main() {
  /// address 1: 0xe8993f83A072FE6CB0eD42F57246167aa08435A7
  /// private Key: 9d12bed45e605464e15338721bd43f587a70689d77b84fecda5f0e51e9a231fe
// temple_private_key = "edskRzfJzQnyKWr4qP4rUipDfTNCXJGxBW91m5HtgTYS92MmWo1tUge6nXkumkrNqDa767qPgqiJQaqNfmjebFJUc96JmuBLQn"
// For information : this the address read on Temple associated with the previous encoded secret key  -> tz1Q7zwo7fmRNyCL7jdz6hcPSsYukkWY66Q3
  ///
  group('Secret Key type', () {
    test('Provided Key is of type ethereum', () {
      // final
      // const author = Author('Taleb', 'logo');
      // expect(author.name, 'Taleb');
      // expect(author.logo, 'logo');
    });
  });
  group('private key to jwK', () {
    test('Provided Key is of type ethereum', () {
      // final
      // const author = Author('Taleb', 'logo');
      // expect(author.name, 'Taleb');
      // expect(author.logo, 'logo');
    });
  });
  group('Secret Key to address', () {
    test('Temple secret Key to address', () {
      const templePrivateKey =
          'edskRzfJzQnyKWr4qP4rUipDfTNCXJGxBW91m5HtgTYS92MmWo1tUge6nXkumkrNqDa767qPgqiJQaqNfmjebFJUc96JmuBLQn';

      /// Generate keystore from secret key
      final keystore = Keystore.fromSecretKey(templePrivateKey);

      // Sample output of keystore created from secretkey
      print(keystore.secretKey);
      // => edskRpwW3bAgx7GsbyTrbb5NUP7b1tz34AvfV2Vm4En5LgEzeUmg3Ys815UDYNNFG6JvrrGqA9CNU2h8hsLVVLfuEQPkZNtkap
      print(keystore.publicKey);
      // => edpkvGRiJj7mCSZtcTabQkfgKky8AEDGPTCmmWyT1Vg17Lqt3cD5TU
      print(keystore.address);
      expect(keystore.address, equals('tz1Q7zwo7fmRNyCL7jdz6hcPSsYukkWY66Q3'));
      // => tz1LmRFP1yFg4oTwfThfbrJx2BfZVAK2h7eW
      // final address = templePrivateToAddress(templePrivateKey);
      // final
      // const author = Author('Taleb', 'logo');
      // expect(author.name, 'Taleb');
      // expect(author.logo, 'logo');
    });
  });
}

// String templePrivateToAddress(String templePrivateKey) {
//   final BIP32 root = BIP32.fromBase58(templePrivateKey);
//   final privateKey = root.privateKey;
//   final publicKey = root.publicKey;

//   final dBytes = 

//   // final
//   // const author = Author('Taleb', 'logo');
//   // expect(author.name, 'Taleb');
//   // expect(author.logo, 'logo');
//   return 'toto';
// }
