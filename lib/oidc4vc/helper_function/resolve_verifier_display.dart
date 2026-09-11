import 'package:altme/app/app.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';

class VerifierDisplayInfo {
  const VerifierDisplayInfo({required this.name});

  final String name;
}

/// Resolves how the verifier should be identified to the user on the
/// verifier-connect and share-information screens.
///
/// - When the authorization request JWT is signed with an x509-bound key
///   (`x5c` header present), the name comes from the organizationName (O)
///   field of the leaf certificate's subject.
/// - Otherwise, falls back to the trusted-list entity name, if any, and
///   finally to the request's host.
VerifierDisplayInfo resolveVerifierDisplay({
  required Map<String, dynamic>? jwtHeader,
  required TrustedEntity? trustedEntity,
  required String fallbackHost,
}) {
  final leafCert = jwtHeader != null ? leafCertFromX5c(jwtHeader) : null;
  final organizationName = leafCert != null
      ? x509SubjectField(leafCert, oidName: 'organizationName')
      : null;

  return VerifierDisplayInfo(
    name: organizationName ?? trustedEntity?.name ?? fallbackHost,
  );
}
