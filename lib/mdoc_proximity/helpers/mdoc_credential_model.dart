import 'package:altme/app/shared/helper_functions/get_display.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// mso_mdoc views of a stored credential (see `getMdocCredentialData`).
extension MdocCredentialModel on CredentialModel {
  /// Whether this credential is an ISO/IEC 18013-5 mdoc.
  bool get isMdoc => format == VCFormatType.mdoc.vcValue;

  /// The base64url `IssuerSigned` as issued.
  String? get mdocIssuerSigned => data['issuerSigned'] as String?;

  /// The mdoc document type.
  String? get mdocDocType => data['docType'] as String?;

  /// Whether this mdoc can be shown to a reader: it is bound to a platform
  /// key the proximity session can sign with.
  bool get canPresentInProximity =>
      isMdoc && mdocIssuerSigned != null && keyId != null;

  /// The value of [element] in [nameSpace], or `null`.
  Object? mdocValue(String nameSpace, String element) {
    final subject = data['credentialSubject'];
    if (subject is! Map) return null;
    final elements = subject[nameSpace];
    return elements is Map ? elements[element] : null;
  }

  /// The display name the issuer gives [element] of [nameSpace] in
  /// [languageCode], or the element identifier.
  String mdocLabel(String nameSpace, String element, String languageCode) {
    final claims =
        credentialSupported?['credential_metadata']?['claims'] ??
        credentialSupported?['claims'];
    if (claims is List) {
      for (final claim in claims) {
        if (claim is! Map<String, dynamic>) continue;
        final path = claim['path'];
        if (path is List &&
            path.length == 2 &&
            path[0] == nameSpace &&
            path[1] == element) {
          final display = getDisplay(claim, languageCode);
          if (display is Map && display['name'] != null) {
            return display['name'].toString();
          }
        }
      }
    }
    return element;
  }
}
