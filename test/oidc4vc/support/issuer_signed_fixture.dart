import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:mdoc/mdoc.dart';

const mdlDocType = 'org.iso.18013.5.1.mDL';
const mdlNameSpace = 'org.iso.18013.5.1';

final Uint8List _x = Uint8List.fromList(List.filled(32, 1));
final Uint8List _y = Uint8List.fromList(List.filled(32, 2));

/// The SEC1 point of the device key [testIssuerSigned] is bound to.
final Uint8List testDevicePoint = Uint8List.fromList([0x04, ..._x, ..._y]);

/// A base64url mDL IssuerSigned with valid digests, as OID4VCI returns it.
/// The issuer signature is a placeholder: no layer under test checks it.
String testIssuerSigned({
  Map<String, Object?> elements = const {
    'family_name': 'Doe',
    'age_over_18': true,
  },
  bool tamper = false,
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
    'docType': mdlDocType,
    'validityInfo': {
      'signed': CborTag(0, '2026-10-01T00:00:00Z'),
      'validFrom': CborTag(0, '2026-10-01T00:00:00Z'),
      'validUntil': CborTag(0, '2027-10-01T00:00:00Z'),
    },
  };
  final encoded = cborEncode({
    'nameSpaces': {mdlNameSpace: items},
    'issuerAuth': [
      cborEncode({1: -7}),
      <Object?, Object?>{},
      cborEncode(CborTag.embedded(mso)),
      Uint8List(64),
    ],
  });
  return base64Url.encode(encoded).replaceAll('=', '');
}
