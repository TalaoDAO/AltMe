import 'dart:convert';

import 'package:oidc4vc/src/token_parameters.dart';

/// Extends [TokenParameters] to handle additional parameters
/// for verifier interactions.
class VerifierTokenParameters extends TokenParameters {
  ///
  VerifierTokenParameters({
    required super.privateKey,
    required super.did,
    required super.proofHeaderType,
    required super.mediaType,
    required super.clientType,
    required super.clientId,
    required this.credentials,
    required this.audience,
    this.nonce,
    super.kid,
  });

  /// [audience] is is client id of the request
  final String audience;

  /// [credentials] is list of credentials to be presented
  final List<String> credentials;

  /// [nonce] is a number given by verifier to handle request authentication
  final String? nonce;

  /// [jsonIdOrJwtList] is list of jwt or jsonIds from the credentials
  ///  wich contains other credential's metadata
  List<dynamic> get jsonIdOrJwtList {
    final list = <dynamic>[];

    for (final credential in credentials) {
      final credentialJson = jsonDecode(credential) as Map<String, dynamic>;
      if (credentialJson['jwt'] != null) {
        list.add(credentialJson['jwt']);
      } else {
        list.add(credentialJson['data']);
      }
    }
    return list;
  }
}
