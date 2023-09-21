import 'package:oidc4vc/src/token_parameters.dart';

/// Extends [TokenParameters] to handle additional parameters
/// for issuer interactions.
class IssuerTokenParameters extends TokenParameters {
  ///
  IssuerTokenParameters({
    required super.privateKey,
    required super.did,
    required super.kid,
    required this.issuer,
  });

  /// [issuer] is id of credential we are aquiring.
  final String issuer;
}
