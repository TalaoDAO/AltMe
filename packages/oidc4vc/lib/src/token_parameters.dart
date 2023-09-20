import 'dart:core';

/// Most of the parameters used to get or present EBSI credentials
/// are computed from private key of the user wallet.
/// [TokenParameters] regroup those computed parameters`
class TokenParameters {
  ///
  TokenParameters({
    required this.privateKey,
    required this.did,
    required this.kid,
    required this.isEBSIV2,
  });

  /// [privateKey] is JWK (Json Web Key) of user private key
  final Map<String, dynamic> privateKey;

  /// [did] did
  String did;

  /// [kid] kid
  String kid;

  /// [publicJWK] is JWK (Json Web Key) of user public key
  /// computed from [privateKey]
  Map<String, dynamic> get publicJWK {
    return Map.of(privateKey)..removeWhere((key, value) => key == 'd');
  }

  /// [isEBSIV2] whether the value is EBSIV2 or not
  bool isEBSIV2;

  /// [alg] is computed from crv of [privateKey]'s fingerprint
  String get alg {
    if (privateKey['alg'] != null) {
      return privateKey['alg'] as String;
    }
    return privateKey['crv'] == 'P-256' ? 'ES256' : 'ES256K';
  }
}
