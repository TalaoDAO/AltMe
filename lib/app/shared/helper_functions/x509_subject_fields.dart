import 'dart:convert';

import 'package:asn1lib/asn1lib.dart' as asn1lib;
import 'package:x509_plus/x509.dart' as x509;

/// Extracts the leaf certificate (x5c[0]) from a decoded JWT header, if any.
String? leafCertFromX5c(Map<String, dynamic> jwtHeader) {
  final x5c = jwtHeader['x5c'];
  if (x5c is List && x5c.isNotEmpty) {
    return x5c.first.toString();
  }
  return null;
}

/// Reads a Subject Distinguished Name field (e.g. 'commonName',
/// 'organizationName') from a base64-encoded DER x509 certificate, as found
/// in the 'x5c' header of a signed JWT.
String? x509SubjectField(String certBase64, {required String oidName}) {
  try {
    final decoded = base64Decode(certBase64);
    final seq = asn1lib.ASN1Sequence.fromBytes(decoded);
    final cert = x509.X509Certificate.fromAsn1(seq);
    final subject = cert.tbsCertificate.subject;
    if (subject == null) return null;

    for (final entry in subject.names) {
      for (final key in entry.keys) {
        if (key?.name == oidName) {
          return entry[key]?.toString();
        }
      }
    }
    return null;
  } catch (_) {
    return null;
  }
}
