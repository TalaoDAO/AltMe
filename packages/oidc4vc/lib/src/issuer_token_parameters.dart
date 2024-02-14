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
    required super.useJWKThumbPrint,
    required this.issuer,
    required this.clientId,
    super.kid,
  });

  /// [issuer] is id of credential we are aquiring.
  final String issuer;

  /// [clientId] is clientId.
  final String clientId;
}
