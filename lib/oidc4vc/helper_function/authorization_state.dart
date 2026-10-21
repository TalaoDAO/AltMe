import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

/// The OAuth `state` of an authorization request, and back.
///
/// It carries the PKCE code challenge that keys the saved `Oidc4VCIState`,
/// encrypted with AES-256-GCM under a key derived from a secret: opaque to the
/// authorization server, tamper-evident, and short enough for servers that
/// limit `state` to 128 bytes (a signed JWT was not).
abstract final class AuthorizationState {
  static const _nonceLength = 12;
  static const _tagBits = 128;

  /// [challenge], encrypted as a base64url `state`.
  static String encrypt(String challenge, {required String secret}) {
    final random = Random.secure();
    final nonce = Uint8List.fromList([
      for (var i = 0; i < _nonceLength; i++) random.nextInt(256),
    ]);
    final cipherText = _cipher(
      forEncryption: true,
      secret: secret,
      nonce: nonce,
    ).process(Uint8List.fromList(utf8.encode(challenge)));
    return base64Url.encode([...nonce, ...cipherText]).replaceAll('=', '');
  }

  /// The challenge [state] carries.
  ///
  /// Throws an [ArgumentError] when [state] is not one this wallet made with
  /// [secret], or was altered.
  static String decrypt(String state, {required String secret}) {
    final Uint8List bytes;
    try {
      bytes = base64Url.decode(base64Url.normalize(state));
    } on FormatException {
      throw ArgumentError.value(state, 'state', 'not a wallet state');
    }
    if (bytes.length <= _nonceLength + _tagBits ~/ 8) {
      throw ArgumentError.value(state, 'state', 'not a wallet state');
    }
    try {
      final plainText = _cipher(
        forEncryption: false,
        secret: secret,
        nonce: bytes.sublist(0, _nonceLength),
      ).process(bytes.sublist(_nonceLength));
      return utf8.decode(plainText);
    } on InvalidCipherTextException {
      throw ArgumentError.value(state, 'state', 'not a wallet state');
    }
  }

  static GCMBlockCipher _cipher({
    required bool forEncryption,
    required String secret,
    required Uint8List nonce,
  }) {
    final key = Uint8List.fromList(sha256.convert(utf8.encode(secret)).bytes);
    return GCMBlockCipher(AESEngine())..init(
      forEncryption,
      AEADParameters(KeyParameter(key), _tagBits, nonce, Uint8List(0)),
    );
  }
}
