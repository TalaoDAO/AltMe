import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:mdoc/mdoc.dart';
import 'package:pointycastle/export.dart';

const mdlDocType = 'org.iso.18013.5.1.mDL';
const mdlNameSpace = 'org.iso.18013.5.1';

final Uint8List _x = Uint8List.fromList(List.filled(32, 1));
final Uint8List _y = Uint8List.fromList(List.filled(32, 2));

/// The SEC1 point of the device key [testIssuerSigned] is bound to.
final Uint8List testDevicePoint = Uint8List.fromList([0x04, ..._x, ..._y]);

/// A test issuer: a P-256 key and its self-signed certificate (CN=Test mdoc
/// issuer, valid until 2126), made with openssl for these tests only.
final BigInt _issuerKey = BigInt.parse(
  '21374183028147b696d3187325c836f36fbaa27274a6f6ba77b109fb255334e0',
  radix: 16,
);
final Uint8List _issuerCertificate = base64.decode(
  'MIIBMTCB2QIUaRp0FLxaEGRFCtE928t6nQl6PmowCgYIKoZIzj0EAwIwGzEZMBcGA1UEAwwQ'
  'VGVzdCBtZG9jIGlzc3VlcjAgFw0yNjEwMTIxMjM3NTlaGA8yMTI2MDkxODEyMzc1OVowGzEZ'
  'MBcGA1UEAwwQVGVzdCBtZG9jIGlzc3VlcjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABDr2'
  'JAN3O0EzPeQWFSVbxxybd77BtHCyvnsCx4tfpKbBoUd3WQspbkNkT8VO51CkbhuI+5gXwgMN'
  'DRqGG2antAswCgYIKoZIzj0EAwIDRwAwRAIgdXRYx0eZjYsQUxoiZOwmLsPum+nu5cjKcFdf'
  '0O1Q/hsCIANhiexopPgG8eXLBWfrs8/xB29jPyzjAscrnCp+OXjI',
);

/// A base64url mDL IssuerSigned with valid digests, signed by the test issuer
/// whose certificate it carries, as OID4VCI returns it.
///
/// [tamper] breaks the digests, [badSignature] the issuer signature.
String testIssuerSigned({
  Map<String, Object?> elements = const {
    'family_name': 'Doe',
    'age_over_18': true,
  },
  bool tamper = false,
  bool badSignature = false,
  String docType = mdlDocType,
  String validFrom = '2026-10-01T00:00:00Z',
  String validUntil = '2099-01-01T00:00:00Z',
}) {
  var digestId = 0;
  final items = <CborTag>[];
  final digests = <int, Uint8List>{};
  for (final element in elements.entries) {
    final item = CborTag.embedded({
      'digestID': digestId,
      'random': Uint8List(16),
      'elementIdentifier': element.key,
      'elementValue': element.value,
    });
    items.add(item);
    digests[digestId] = Uint8List.fromList(
      tamper ? List.filled(32, 0) : sha256.convert(cborEncode(item)).bytes,
    );
    digestId++;
  }
  final mso = {
    'version': '1.0',
    'digestAlgorithm': 'SHA-256',
    'valueDigests': {mdlNameSpace: digests},
    'deviceKeyInfo': {
      'deviceKey': {1: 2, -1: 1, -2: _x, -3: _y},
    },
    'docType': docType,
    'validityInfo': {
      'signed': CborTag(0, '2026-10-01T00:00:00Z'),
      'validFrom': CborTag(0, validFrom),
      'validUntil': CborTag(0, validUntil),
    },
  };
  final protectedHeader = cborEncode({1: -7});
  final payload = cborEncode(CborTag.embedded(mso));
  final signature = _sign(
    cborEncode(['Signature1', protectedHeader, Uint8List(0), payload]),
  );
  if (badSignature) signature[0] ^= 0xff;
  final encoded = cborEncode({
    'nameSpaces': {mdlNameSpace: items},
    'issuerAuth': [
      protectedHeader,
      {33: _issuerCertificate},
      payload,
      signature,
    ],
  });
  return base64Url.encode(encoded).replaceAll('=', '');
}

/// An ES256 signature, `r || s`, by the test issuer.
Uint8List _sign(Uint8List message) {
  final signer = ECDSASigner(SHA256Digest(), HMac(SHA256Digest(), 64))
    ..init(
      true,
      PrivateKeyParameter(ECPrivateKey(_issuerKey, ECCurve_secp256r1())),
    );
  final signature = signer.generateSignature(message) as ECSignature;
  return Uint8List.fromList([..._fixed(signature.r), ..._fixed(signature.s)]);
}

List<int> _fixed(BigInt value) {
  final bytes = List<int>.filled(32, 0);
  var rest = value;
  for (var i = 31; i >= 0; i--) {
    bytes[i] = (rest & BigInt.from(0xff)).toInt();
    rest = rest >> 8;
  }
  return bytes;
}
