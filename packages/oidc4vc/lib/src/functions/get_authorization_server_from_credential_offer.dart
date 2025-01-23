import 'package:json_path/json_path.dart';

String? getAuthorizationServerFromCredentialOffer(
  dynamic credentialOfferJson,
) {
  try {
    /// Extract the authorization endpoint from from
    /// authorization_server in credentialOfferJson
    final jsonPathAuthorizationServer = JsonPath(
      r'$..authorization_server',
    );
    final data = jsonPathAuthorizationServer
        .read(credentialOfferJson)
        .first
        .value! as String;
    return data;
  } catch (e) {
    return null;
  }
}
