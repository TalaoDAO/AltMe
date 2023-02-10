import 'dart:convert';
import 'dart:core';

import 'package:crypto/crypto.dart';
import 'package:fast_base58/fast_base58.dart';

/// Most of the parameters used to get or present EBSI credentials
/// are computed from private key of the user wallet.
/// [TokenParameters] regroup those computed parameters
class TokenParameters {
  ///
  TokenParameters(this.privateKey);

  /// [privateKey] is JWK (Json Web Key) of user private key
  final Map<String, dynamic> privateKey;

  /// [publicJWK] is JWK (Json Web Key) of user public key
  /// computed from [privateKey]
  Map<String, dynamic> get publicJWK {
    return Map.of(privateKey)..removeWhere((key, value) => key == 'd');
  }

  /// [didKey] is computed from [privateKey]'s fingerprint
  String get didKey {
    final encodedAddress = Base58Encode([2, ...thumbprint]);
    return 'did:ebsi:z$encodedAddress';
  }

  /// [kid] is computed from [privateKey]'s fingerprint
  String get kid {
    final firstPart = didKey;

    final lastPart = Base58Encode(thumbprint);

    return '$firstPart#$lastPart';
  }

  /// [alg] is computed from crv of [privateKey]'s fingerprint
  String get alg {
    if (privateKey['alg'] != null) {
      return privateKey['alg'] as String;
    }
    return privateKey['crv'] == 'P-256' ? 'ES256' : 'ES256K';
  }

  /// [thumbprint] of JWK as defined in https://www.rfc-editor.org/rfc/rfc7638
  List<int> get thumbprint {
    /// we use crv P-256K in the rest of the package to ensure compatibility
    /// with jose dart package. In fact our crv is secp256k1 wich change the
    /// fingerprint
    // ignore: inference_failure_on_instance_creation
    final tmpPublic = Map.from(publicJWK);

    /// this test is to be crv agnostic and respect https://www.rfc-editor.org/rfc/rfc7638
    if (tmpPublic['crv'] == 'P-256K') {
      tmpPublic['crv'] = 'secp256k1';
    }

    tmpPublic
      ..removeWhere((key, value) => key == 'use')
      ..removeWhere((key, value) => key == 'alg');

    final jsonString = jsonEncode(tmpPublic);
    final bytesToHash = utf8.encode(jsonString);
    final sha256Digest = sha256.convert(bytesToHash);

    return sha256Digest.bytes;
  }
}
