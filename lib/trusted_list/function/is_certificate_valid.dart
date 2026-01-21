import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Checks if the certificate in the JWT header is present in the trusted
/// entity's rootCertificate list.
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
  // Check if any certificate in x5c is in the trusted entity's
  // rootCertificates list
  final rootCertificates = trustedEntity.rootCertificates;
  if (rootCertificates == null || rootCertificates.isEmpty) {
    throw Exception('No root certificates found in trusted entity');
  }

  for (final cert in x5c) {
    if (rootCertificates.contains(cert)) {
      return true;
    }
  }
  throw Exception(
    'No x509 certificate in JWT header matches trusted root certificates',
  );
}
