import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:asn1lib/asn1lib.dart' as asn1lib;
import 'package:mdoc/mdoc.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';
import 'package:pointycastle/export.dart';
import 'package:uuid/uuid.dart';
import 'package:x509_plus/x509.dart' as x509;

/// The alias of a fresh platform key for one mso_mdoc credential.
///
/// The key is created in the Android Keystore / Secure Enclave under this
/// alias, signs the OID4VCI proof, and is recorded as the credential's
/// `keyId`: OID4VP DeviceAuth and proximity presentation sign with it too.
String newMdocKeyAlias() => 'mdoc_${const Uuid().v4()}';

/// The `CredentialModel` data of an mso_mdoc credential, from the base64url
/// `IssuerSigned` an OID4VCI credential response carries.
///
/// The data elements go under `credentialSubject`, keyed by name space, so
/// issuer metadata claim paths (`[namespace, element]`) resolve against them.
/// The raw `issuerSigned` is kept for presentation.
///
/// Rejects an mdoc whose issuer signature does not verify, whose docType is
/// not [expectedDocType] (the credential configuration's `doctype`) when
/// there is one, that is outside its validity period at [now], whose
/// elements do not match the MSO digests, or that is not bound to the
/// platform key [keyId] when there is one.
Future<Map<String, dynamic>> getMdocCredentialData({
  required String issuerSigned,
  required String credentialType,
  String? keyId,
  String? expectedDocType,
  DateTime? now,
  PlatformP256Keys platformKeys = const PlatformP256Keys(),
}) async {
  final IssuerSigned mdoc;
  try {
    mdoc = IssuerSigned.fromBase64Url(issuerSigned);
  } on FormatException catch (e) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description': 'The mso_mdoc credential cannot be decoded: $e',
      },
    );
  }

  if (!mdocIssuerSignatureIsValid(mdoc)) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description':
            'The mso_mdoc issuer signature does not verify with its '
            'certificate.',
      },
    );
  }

  if (expectedDocType != null && mdoc.docType != expectedDocType) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description':
            'The mso_mdoc is a ${mdoc.docType}, not the $expectedDocType '
            'the issuer offered.',
      },
    );
  }

  final at = (now ?? DateTime.now()).toUtc();
  // A few minutes' grace on validFrom, for a device clock slightly behind.
  if (at.add(const Duration(minutes: 5)).isBefore(mdoc.mso.validFrom) ||
      at.isAfter(mdoc.mso.validUntil)) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description':
            'The mso_mdoc is not valid now: it is valid from '
            '${mdoc.mso.validFrom.toIso8601String()} until '
            '${mdoc.mso.validUntil.toIso8601String()}.',
      },
    );
  }

  if (!mdoc.digestsMatch()) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description':
            'The mso_mdoc data elements do not match the MSO digests.',
      },
    );
  }

  if (keyId != null) {
    final key = await platformKeys.find(keyId);
    if (key != null && !mdoc.isBoundTo(key.publicKey)) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description':
              'The mso_mdoc is not bound to the key sent in the proof.',
        },
      );
    }
  }

  return {
    'id': 'urn:uuid:${const Uuid().v4()}',
    'type': [credentialType],
    'issuanceDate': mdoc.mso.signed.toIso8601String(),
    'expirationDate': mdoc.mso.validUntil.toIso8601String(),
    'credentialSubject': {'type': credentialType, ..._displayClaims(mdoc)},
    'docType': mdoc.docType,
    'issuerSigned': issuerSigned,
  };
}

/// Whether the issuer's ES256 signature over the MSO (`issuerAuth`) verifies
/// with the key of its leaf certificate (`x5chain`).
///
/// ES256 only, as HAIP requires of mdoc issuers. The certificate chain itself
/// is not judged here: whether the issuer is trusted is the trusted list's
/// decision, made on the issuer's identity for every credential format.
bool mdocIssuerSignatureIsValid(IssuerSigned mdoc) {
  if (mdoc.issuerAlgorithm != -7) return false;
  final chain = mdoc.issuerCertificateChain;
  final signature = mdoc.issuerSignature;
  if (chain.isEmpty || signature.length != 64) return false;
  try {
    final certificate = x509.X509Certificate.fromAsn1(
      asn1lib.ASN1Sequence.fromBytes(chain.first),
    );
    final key = certificate.publicKey;
    if (key is! x509.EcPublicKey) return false;
    final curve = ECCurve_secp256r1();
    final point = curve.curve.createPoint(
      BigInt.parse(key.xCoordinate.toString()),
      BigInt.parse(key.yCoordinate.toString()),
    );
    final verifier = ECDSASigner(SHA256Digest())
      ..init(false, PublicKeyParameter(ECPublicKey(point, curve)));
    return verifier.verifySignature(
      mdoc.issuerSignatureInput,
      ECSignature(
        _unsigned(signature.sublist(0, 32)),
        _unsigned(signature.sublist(32)),
      ),
    );
  } on Object {
    return false;
  }
}

BigInt _unsigned(List<int> bytes) =>
    bytes.fold(BigInt.zero, (value, byte) => (value << 8) | BigInt.from(byte));

/// The data elements as JSON values, with JPEG and PNG images (e.g. the
/// `portrait`) as `data:` URIs, which the credential display renders as
/// pictures — the way SD-JWT credentials carry them.
Map<String, Map<String, Object?>> _displayClaims(IssuerSigned mdoc) => {
  for (final entry in mdoc.nameSpaces.entries)
    entry.key: {
      for (final item in entry.value)
        item.elementIdentifier: _displayValue(item.elementValue),
    },
};

Object? _displayValue(Object? value) {
  if (value is Uint8List) {
    final mimeType = _imageMimeType(value);
    if (mimeType != null) {
      return 'data:$mimeType;base64,${base64.encode(value)}';
    }
  }
  return cborToJson(value);
}

String? _imageMimeType(Uint8List bytes) {
  if (bytes.length > 3 &&
      bytes[0] == 0xff &&
      bytes[1] == 0xd8 &&
      bytes[2] == 0xff) {
    return 'image/jpeg';
  }
  if (bytes.length > 4 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4e &&
      bytes[3] == 0x47) {
    return 'image/png';
  }
  return null;
}
