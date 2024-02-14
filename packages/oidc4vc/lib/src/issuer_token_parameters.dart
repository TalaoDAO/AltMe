import 'package:oidc4vc/src/token_parameters.dart';

/// Extends [TokenParameters] to handle additional parameters
/// for issuer interactions.
class IssuerTokenParameters extends TokenParameters {
  ///
  IssuerTokenParameters({
    required super.privateKey,
    required super.did,
    required super.mediaType,
    required super.proofHeaderType,
    required super.clientType,
    required super.clientId,
    required this.issuer,
    super.kid,
  });

  /// [issuer] is id of credential we are aquiring.
  final String issuer;
}
