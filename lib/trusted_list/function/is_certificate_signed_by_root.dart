import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart' as asn1lib;
import 'package:crypto_keys_plus/crypto_keys.dart' as ck;
import 'package:x509_plus/x509.dart' as x509;

/// Whether the X.509 certificate [certificateBase64] (base64 DER) is
/// cryptographically signed by the private key matching
/// [rootCertificateBase64] (also base64 DER).
///
/// This verifies the actual signature - it does not compare certificate
/// bytes - because in practice a JWT's `x5c` carries the signer's own
/// leaf certificate, which is a different certificate from (but signed
/// by) a trusted root; comparing bytes would never match.
///
/// Only covers a direct one-hop relationship (certificate signed
/// directly by root), which is what a trusted list's `rootCertificates`
/// represents; it does not walk multi-certificate chains.
bool isCertificateSignedByRoot({
  required String certificateBase64,
  required String rootCertificateBase64,
}) {
  try {
    final certificateSequence = asn1lib.ASN1Sequence.fromBytes(
      base64Decode(certificateBase64),
    );
    final certificate = x509.X509Certificate.fromAsn1(certificateSequence);

    final rootSequence = asn1lib.ASN1Sequence.fromBytes(
      base64Decode(rootCertificateBase64),
    );
    final root = x509.X509Certificate.fromAsn1(rootSequence);

    // The exact bytes that were signed: the TBSCertificate as originally
    // encoded. Re-encoding via tbsCertificate.toAsn1() could produce
    // different bytes, so the original parsed element is used instead.
    final tbsBytes = certificateSequence.elements[0].encodedBytes;
    final signatureBytes = Uint8List.fromList(certificate.signatureValue!);
    final algorithmName = certificate.signatureAlgorithm.algorithm.toString();

    final rootPublicKey = root.publicKey;

    if (rootPublicKey is ck.RsaPublicKey) {
      final algorithm = switch (algorithmName) {
        'sha256WithRSAEncryption' => ck.algorithms.signing.rsa.sha256,
        'sha384WithRSAEncryption' => ck.algorithms.signing.rsa.sha384,
        'sha512WithRSAEncryption' => ck.algorithms.signing.rsa.sha512,
        _ => null,
      };
      if (algorithm == null) return false;

      return rootPublicKey
          .createVerifier(algorithm)
          .verify(tbsBytes, ck.Signature(signatureBytes));
    }

    if (rootPublicKey is ck.EcPublicKey) {
      final algorithm = switch (algorithmName) {
        '1.2.840.10045.4.3.2' => ck.algorithms.signing.ecdsa.sha256,
        '1.2.840.10045.4.3.3' => ck.algorithms.signing.ecdsa.sha384,
        '1.2.840.10045.4.3.4' => ck.algorithms.signing.ecdsa.sha512,
        _ => null,
      };
      if (algorithm == null) return false;

      final curveByteLength = _ecCurveByteLength(rootPublicKey.curve);
      final rawSignature = _derEcdsaSignatureToRaw(
        signatureBytes,
        curveByteLength,
      );

      return rootPublicKey
          .createVerifier(algorithm)
          .verify(tbsBytes, ck.Signature(rawSignature));
    }

    return false;
  } catch (_) {
    return false;
  }
}

int _ecCurveByteLength(ck.Identifier curve) {
  if (curve == ck.curves.p256 || curve == ck.curves.p256k) return 32;
  if (curve == ck.curves.p384) return 48;
  if (curve == ck.curves.p521) return 66;
  throw UnsupportedError('Unsupported EC curve: $curve');
}

/// X.509 encodes an ECDSA signature as `SEQUENCE { INTEGER r, INTEGER s }`,
/// while [ck.Signature] expects the raw, fixed-length `r || s` bytes.
Uint8List _derEcdsaSignatureToRaw(
  Uint8List derSignature,
  int curveByteLength,
) {
  final sequence = asn1lib.ASN1Sequence.fromBytes(derSignature);
  final r = (sequence.elements[0] as asn1lib.ASN1Integer).valueAsBigInteger;
  final s = (sequence.elements[1] as asn1lib.ASN1Integer).valueAsBigInteger;

  final bytes = Uint8List(curveByteLength * 2)
    ..setRange(0, curveByteLength, _bigIntToBytesBigEndian(r, curveByteLength))
    ..setRange(
      curveByteLength,
      curveByteLength * 2,
      _bigIntToBytesBigEndian(s, curveByteLength),
    );
  return bytes;
}

Uint8List _bigIntToBytesBigEndian(BigInt value, int length) {
  final bytes = Uint8List(length);
  var remaining = value;
  for (var i = length - 1; i >= 0; i--) {
    bytes[i] = (remaining & BigInt.from(0xff)).toInt();
    remaining = remaining >> 8;
  }
  return bytes;
}
