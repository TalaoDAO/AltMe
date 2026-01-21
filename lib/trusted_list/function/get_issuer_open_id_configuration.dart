import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:oidc4vc/oidc4vc.dart';

OpenIdConfiguration getIssuerOpenIdConfiguration({
  required OpenIdConfiguration issuerOpenIdConfiguration,
}) {
  late OpenIdConfiguration newIssuerOpenIdConfiguration;
  if (issuerOpenIdConfiguration.signedMetadata != null) {
    final signedMetadata = issuerOpenIdConfiguration.signedMetadata;
    // signedMetadata is a JWT containing the issuer's OpenID configuration in
    // the payload and an x509 certificate in the header.
    if (signedMetadata == null) {
      throw Exception('Signed metadata is null');
    }
    // check jwt signature

    try {
      final jwt = JWT.decode(signedMetadata);
      final payload = jwt.payload as Map<String, dynamic>;

      // Check for required claims
      if (!payload.containsKey('iat')) {
        throw Exception('Missing required claim in signed metadata: iat');
      }
      if (!payload.containsKey('iss')) {
        throw Exception('Missing required claim in signed metadata: iss');
      }
      if (!payload.containsKey('sub')) {
        throw Exception('Missing required claim in signed metadata: sub');
      }

      // Check that 'sub' matches the Credential Issuer identifier
      final credentialIssuer = issuerOpenIdConfiguration.credentialIssuer;
      if (payload['sub'] != credentialIssuer) {
        throw Exception(
          "The 'sub' claim does not match the Credential Issuer identifier",
        );
      }

      // convert the payload to OpenIdConfiguration
      newIssuerOpenIdConfiguration = OpenIdConfiguration.fromJson(payload);
    } catch (e) {
      rethrow;
    }

    // Decode the JWT and extract the payload
  } else {
    throw Exception(
      'Signed metadata is null, cannot update issuer OpenID configuration',
    );
  }

  return newIssuerOpenIdConfiguration;
}
