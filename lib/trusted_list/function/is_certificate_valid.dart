import 'package:altme/trusted_list/function/is_certificate_signed_by_root.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Checks if any certificate in the JWT header's `x5c` was signed by one
/// of the trusted entity's rootCertificates.
///
/// This is a cryptographic check, not a byte comparison: `x5c` normally
/// carries the signer's own leaf certificate, which is a different
/// certificate from (but signed by) the trusted root.
bool isCertificateValid({
  required TrustedEntity trustedEntity,
  required String signedMetadata,
}) {
  // Decode the JWT header
  final jwt = JWT.decode(signedMetadata);
  if (jwt.header == null) {
    throw Exception('JWT header of signed_metadata is null');
  }
  final header = jwt.header!;

  // Extract the x509 certificate from the header (commonly in 'x5c')
  final x5c = header['x5c'];
  if (x5c == null || x5c is! List || x5c.isEmpty) {
    throw Exception('No x509 certificate found in JWT header');
  }
  // Check if any certificate in x5c was signed by one of the trusted
  // entity's rootCertificates
  final rootCertificates = trustedEntity.rootCertificates;
  if (rootCertificates == null || rootCertificates.isEmpty) {
    throw Exception('No root certificates found in trusted entity');
  }

  for (final cert in x5c) {
    for (final rootCertificate in rootCertificates) {
      if (isCertificateSignedByRoot(
        certificateBase64: cert.toString(),
        rootCertificateBase64: rootCertificate,
      )) {
        return true;
      }
    }
  }
  throw Exception(
    'No x509 certificate in JWT header matches trusted root certificates',
  );
}
