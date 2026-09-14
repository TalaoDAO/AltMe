import 'package:altme/app/app.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:oidc4vc/oidc4vc.dart';

class IssuerDisplayInfo {
  const IssuerDisplayInfo({
    required this.name,
    this.logoUri,
  });

  final String name;
  final String? logoUri;
}

/// Resolves how the issuer should be identified to the user on the
/// issuer-connect and credential-acceptance screens.
///
/// - When the issuer metadata is signed (`signed_metadata`, used by e.g. the
///   EUDIW/HAIP profile), the name comes from the commonName of the x509
///   leaf certificate that signed it - no logo is available in that case.
/// - Otherwise the name/logo come from the issuer's `display` metadata
///   array, matched against the current locale, as used by the Default
///   profile.
IssuerDisplayInfo resolveIssuerDisplay({
  required OpenIdConfiguration issuerOpenIdConfiguration,
  required String locale,
  required String fallbackHost,
}) {
  final signedMetadata = issuerOpenIdConfiguration.signedMetadata;

  if (signedMetadata != null) {
    final header = JWT.decode(signedMetadata).header;
    final leafCert = header != null ? leafCertFromX5c(header) : null;
    final commonName = leafCert != null
        ? x509SubjectField(leafCert, oidName: 'commonName')
        : null;

    return IssuerDisplayInfo(name: commonName ?? fallbackHost);
  }

  final displays = issuerOpenIdConfiguration.display;
  final display = (displays == null || displays.isEmpty)
      ? null
      : extractDisplay(displays, locale);

  return IssuerDisplayInfo(
    name: display?.name ?? fallbackHost,
    logoUri: display?.logo?.uri,
  );
}

/// Resolves the display name(s) of the credential type(s) offered, for the
/// "Credential" field shown on the issuer-connect confirmation screen.
String resolveOfferedCredentialDisplayName({
  required Oidc4vcParameters oidc4vcParameters,
  required String languageCode,
}) {
  final ids = oidc4vcParameters.credentialOffer['credential_configuration_ids'];
  if (ids is! List || ids.isEmpty) return '';

  final names = ids.map((id) {
    final (display, _) = fetchDisplay(
      openIdConfiguration: oidc4vcParameters.issuerOpenIdConfiguration,
      credentialType: id.toString(),
      languageCode: languageCode,
    );
    return display?.name ?? id.toString();
  });

  return names.join(', ');
}
