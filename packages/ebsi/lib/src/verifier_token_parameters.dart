import 'dart:convert';

import 'package:ebsi/src/token_parameters.dart';
import 'package:jose/jose.dart';

/// Extends [TokenParameters] to handle additional parameters
/// for verifier interactions.
class VerifierTokenParameters extends TokenParameters {
  ///
  VerifierTokenParameters(super.private, this.uri, this.jwtList);

  /// [uri] provided by verifier and containing nonce
  final Uri uri;

  /// [jwtList] is list of credentials to be presented
  final List<String> jwtList;

  /// [nonce] is a number given by verifier to handle request authentication
  String get nonce => uri.queryParameters['nonce'] ?? '';

  /// [credentials] is list of jwt from the jwtList wich contains
  /// other credential's metadata
  List<String> get credentials => jwtList
      .map(
        (credential) =>
            (jsonDecode(credential) as Map<String, dynamic>)['jwt'] as String,
      )
      .toList();

  /// [audience] is iss from first jwt claims
  String get audience {
    final jwt = JsonWebToken.unverified(credentials[0]);
    final claims = jwt.claims;
    return claims['iss'] as String;
  }
}
