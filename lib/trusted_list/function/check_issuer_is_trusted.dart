import 'package:altme/trusted_list/function/is_certificate_signed_by_root.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:altme/trusted_list/model/trusted_list.dart';
import 'package:oidc4vc/oidc4vc.dart';

TrustedEntity? getIssuerFromTrustedList({
  required OpenIdConfiguration issuerOpenIdConfiguration,
  required TrustedList trustedList,
}) {
  // Check if issuer is in the trusted list
  final issuerFromOpenIdConfiguration =
      issuerOpenIdConfiguration.credentialIssuer;
  return getEntityFromTrustedList(
    trustedList,
    issuerFromOpenIdConfiguration,
    TrustedEntityType.issuer,
  );
}

TrustedEntity? getEntityFromTrustedList(
  TrustedList trustedList,
  String? issuerFromOpenIdConfiguration,
  TrustedEntityType type,
) {
  final domainFromConfiguration = issuerFromOpenIdConfiguration != null
      ? Uri.tryParse(issuerFromOpenIdConfiguration)?.host
      : null;

  final entities = List<TrustedEntity>.from(trustedList.entities);
  entities.removeWhere(
    (entity) =>
        Uri.tryParse(entity.id)?.host != domainFromConfiguration ||
        entity.type != type,
  );
  if (entities.isNotEmpty) {
    return entities.first;
  }
  return null;
}

/// OIDC4VC final-1.0 (issuance) and OIDC4VP final-1.0 (presentation):
/// there's no domain or `signed_metadata` to match the entity by, so
/// instead we look for the trusted entity whose rootCertificates was
/// used to sign one of the certificates from the [x5c] chain in the
/// header of the relevant JWT (issuer metadata JWT, or presentation
/// request JWT).
///
/// This is a cryptographic check, not a byte comparison: `x5c` normally
/// carries the entity's own leaf certificate, which is a different
/// certificate from (but signed by) the trusted root.
TrustedEntity? getEntityFromTrustedListByX5c({
  required List<String> x5c,
  required TrustedList trustedList,
  required TrustedEntityType type,
}) {
  final entities = List<TrustedEntity>.from(trustedList.entities);
  entities.removeWhere(
    (entity) =>
        entity.type != type ||
        entity.rootCertificates == null ||
        !entity.rootCertificates!.any(
          (rootCertificate) => x5c.any(
            (certificate) => isCertificateSignedByRoot(
              certificateBase64: certificate,
              rootCertificateBase64: rootCertificate,
            ),
          ),
        ),
  );
  if (entities.isNotEmpty) {
    return entities.first;
  }
  return null;
}

/// See [getEntityFromTrustedListByX5c].
TrustedEntity? getIssuerFromTrustedListByX5c({
  required List<String> x5c,
  required TrustedList trustedList,
}) {
  return getEntityFromTrustedListByX5c(
    x5c: x5c,
    trustedList: trustedList,
    type: TrustedEntityType.issuer,
  );
}
