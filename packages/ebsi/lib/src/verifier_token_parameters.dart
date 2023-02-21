import 'dart:convert';

import 'package:ebsi/src/token_parameters.dart';

/// Extends [TokenParameters] to handle additional parameters
/// for verifier interactions.
class VerifierTokenParameters extends TokenParameters {
  ///
  VerifierTokenParameters(super.privateKey, this.uri, this.credentials);

  /// [uri] provided by verifier and containing nonce
  final Uri uri;

  /// [credentials] is list of credentials to be presented
  final List<String> credentials;

  /// [nonce] is a number given by verifier to handle request authentication
  String get nonce => uri.queryParameters['nonce'] ?? '';

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

  /// [audience] is is client id of the request
  String get audience => uri.queryParameters['client_id'] ?? '';
}
