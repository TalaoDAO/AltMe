import 'package:ebsi/src/token_parameters.dart';

/// Extends [TokenParameters] to handle additional parameters
/// for issuer interactions.
class IssuerTokenParameters extends TokenParameters {
  ///
  IssuerTokenParameters(super.private, this.issuer);

  /// [issuer] is id of credential we are aquiring.
  final String issuer;
}
