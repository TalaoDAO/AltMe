import 'dart:convert';

import 'package:ebsi/src/token_parameters.dart';
import 'package:jose/jose.dart';

/// Extends [TokenParameters] to handle additional parameters
/// for verifier interactions.
class VerifierTokenParameters extends TokenParameters {
  ///
  VerifierTokenParameters(super.privateKey, this.uri, this.jwtList);

  /// [uri] provided by verifier and containing nonce
  final Uri uri;

  /// [jwtList] is list of credentials to be presented
  final List<String> jwtList;

  /// [nonce] is a number given by verifier to handle request authentication
  String get nonce => uri.queryParameters['nonce'] ?? '';

  /// [jwtsOfCredentials] is list of jwt from the jwtList wich contains
  /// other credential's metadata
  List<String> get jwtsOfCredentials => jwtList
      .map(
        (credential) =>
            (jsonDecode(credential) as Map<String, dynamic>)['jwt'] as String,
      )
      .toList();

  /// [audience] is is from first jwt claims
  String get audience {
    final jwt = JsonWebToken.unverified(jwtsOfCredentials[0]);
    final claims = jwt.claims;
    return claims['iss'] as String;
  }

  // @visibleForTesting
  // @override
  // Map<String, dynamic> get publicJWK {
  //   const privateKey = {
  //     'crv': 'P-256',
  //     'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
  //     'kty': 'EC',
  //     'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  //     'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
  //   };
  //   return privateKey;
  // }

  // @visibleForTesting
  // @override
  // String get didKey {
  //   const didKey = 'did:ebsi:zo4FR1YfAKFP3Q6dvqhxcXxnfeDiJDP97kmnqhyAUSACj';
  //   return didKey;
  // }

  // @visibleForTesting
  // @override
  // String get kid {
  //   const kid =
  //       '''did:ebsi:zo9FR1YfAKFP3Q6dvrhxcXxnfeDiJDP97kmnqhyAUSACj#Cgcg1y9xj9uWFw56PMc29XBd9EReixzvnftBz8JwQFiB''';

  //   return kid;
  // }

  // @visibleForTesting
  // @override
  // String get alg {
  //   return 'ES256K';
  // }

  // @visibleForTesting
  // @override
  // List<int> get thumbprint {
  //   return [1, 2, 3];
  // }
}
