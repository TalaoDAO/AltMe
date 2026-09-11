import 'package:altme/trusted_list/function/check_issuer_is_trusted.dart';
import 'package:altme/trusted_list/function/is_certificate_valid.dart';
import 'package:altme/trusted_list/model/trusted_list.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// Lightweight, non-throwing re-check of whether an issuer is trusted,
/// for display purposes (e.g. the credential-acceptance confirmation
/// screen). The authoritative, abort-on-mismatch check (including the
/// credential type / vcTypes match) happens once, earlier, when first
/// connecting to the issuer.
bool isIssuerTrusted({
  required OpenIdConfiguration issuerOpenIdConfiguration,
  required TrustedList? trustedList,
  required bool trustedListEnabled,
}) {
  if (!trustedListEnabled || trustedList == null) return false;

  try {
    final trustedEntity = getIssuerFromTrustedList(
      issuerOpenIdConfiguration: issuerOpenIdConfiguration,
      trustedList: trustedList,
    );
    if (trustedEntity == null) return false;

    final signedMetadata = issuerOpenIdConfiguration.signedMetadata;
    if (signedMetadata == null) return false;

    return isCertificateValid(
      trustedEntity: trustedEntity,
      signedMetadata: signedMetadata,
    );
  } catch (_) {
    return false;
  }
}
