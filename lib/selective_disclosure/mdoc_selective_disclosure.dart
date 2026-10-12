import 'package:altme/selective_disclosure/dc_selective_disclosure.dart';

/// Display support for ISO/IEC 18013-5 mdoc credentials.
///
/// An mdoc has no JWT and no disclosures: its data elements are stored under
/// `credentialSubject`, keyed by name space (see `getMdocCredentialData`).
/// The claims come from the issuer metadata exactly as for `dc+sd-jwt`,
/// with `[namespace, element]` paths, and their values are found in the
/// credential data — so the SD-JWT display shows mdocs the same way.
class MdocSelectiveDisclosure extends DcSelectiveDisclosure {
  MdocSelectiveDisclosure(super.credentialModel);

  /// Name space → element → claim metadata, in the issuer's order.
  ///
  /// Every mdoc claim path is `[namespace, element]`, so the level-by-level
  /// walk of `DcSelectiveDisclosure.claims`, which stops at the first level
  /// with no claim, finds nothing at level 1 and returns nothing.
  @override
  Map<String, dynamic> get claims {
    final credentialSupported = credentialModel.credentialSupported;
    final claimsList =
        credentialSupported?['credential_metadata']?['claims'] ??
        credentialSupported?['claims'];
    final tree = <String, dynamic>{};
    if (claimsList is! List) return tree;

    for (final claim in claimsList) {
      if (claim is! Map<String, dynamic>) continue;
      final path = claim['path'];
      if (path is! List || path.length != 2) continue;
      final nameSpace = tree.putIfAbsent(
        path[0].toString(),
        () => <String, dynamic>{},
      );
      if (nameSpace is Map<String, dynamic>) {
        nameSpace.putIfAbsent(path[1].toString(), () => claim);
      }
    }
    return tree;
  }

  /// No JWT payload: every value comes from the credential data.
  @override
  Map<String, dynamic> get payload => <String, dynamic>{};

  @override
  List<String> get disclosureFromJWT => const [];
}
