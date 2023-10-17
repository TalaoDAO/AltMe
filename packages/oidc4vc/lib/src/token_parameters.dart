import 'dart:convert';
import 'dart:core';

import 'package:crypto/crypto.dart';

/// Most of the parameters used to get or present EBSI credentials
/// are computed from private key of the user wallet.
/// [TokenParameters] regroup those computed parameters`
class TokenParameters {
  ///
  TokenParameters({
    required this.privateKey,
    required this.did,
    required this.kid,
    required this.isProofOfOwnership,
    required this.useJWKThumbPrint,
  });

  /// [privateKey] is JWK (Json Web Key) of user private key
  final Map<String, dynamic> privateKey;

  /// [did] did
  String did;

  /// [kid] kid
  String kid;

  /// [isProofOfOwnership] isIdToken
  bool isProofOfOwnership;

  /// [publicJWK] is JWK (Json Web Key) of user public key
  /// computed from [privateKey]
  Map<String, dynamic> get publicJWK {
    return Map.of(privateKey)..removeWhere((key, value) => key == 'd');
  }

  /// [alg] is computed from crv of [privateKey]'s fingerprint
  String get alg {
    if (privateKey['alg'] != null) {
      return privateKey['alg'] as String;
    }
    return privateKey['crv'] == 'P-256' ? 'ES256' : 'ES256K';
  }

  /// whether to use did or thumbprint
  bool useJWKThumbPrint;

  /// [thumbprint] of JWK as defined in https://www.rfc-editor.org/rfc/rfc7638
  String get thumbprint {
    /// we use crv P-256K in the rest of the package to ensure compatibility
    /// with jose dart package. In fact our crv is secp256k1 wich change the
    /// fingerprint

    final sortedJwk = Map.fromEntries(
      publicJWK.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    )
      ..removeWhere((key, value) => key == 'use')
      ..removeWhere((key, value) => key == 'alg');

    /// this test is to be crv agnostic and respect https://www.rfc-editor.org/rfc/rfc7638
    if (sortedJwk['crv'] == 'P-256K') {
      sortedJwk['crv'] = 'secp256k1';
    }

    final jsonString = jsonEncode(sortedJwk).replaceAll(' ', '');
    final bytesToHash = utf8.encode(jsonString);
    final sha256Digest = sha256.convert(bytesToHash);

    return base64Encode(sha256Digest.bytes);
  }
}
