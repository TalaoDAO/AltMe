import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/oidc4vc/helper_function/mdoc_credential_data.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc/mdoc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

const _ns = 'org.iso.18013.5.1';
final _x = Uint8List.fromList(List.filled(32, 1));
final _y = Uint8List.fromList(List.filled(32, 2));
final _devicePoint = Uint8List.fromList([0x04, ..._x, ..._y]);

/// An IssuerSigned with valid digests (the issuer signature is not checked
/// at this layer), base64url encoded as OID4VCI returns it.
String _issuerSigned({bool tamper = false}) {
  final item = CborTag.embedded({
    'digestID': 0,
    'random': Uint8List(16),
    'elementIdentifier': 'family_name',
    'elementValue': 'Doe',
  });
  final digest = sha256.convert(cborEncode(item)).bytes;
  final mso = {
    'version': '1.0',
    'digestAlgorithm': 'SHA-256',
    'valueDigests': {
      _ns: {0: Uint8List.fromList(tamper ? List.filled(32, 0) : digest)},
    },
    'deviceKeyInfo': {
      'deviceKey': {1: 2, -1: 1, -2: _x, -3: _y},
    },
    'docType': 'org.iso.18013.5.1.mDL',
    'validityInfo': {
      'signed': CborTag(0, '2026-10-01T00:00:00Z'),
      'validFrom': CborTag(0, '2026-10-01T00:00:00Z'),
      'validUntil': CborTag(0, '2027-10-01T00:00:00Z'),
    },
  };
  final encoded = cborEncode({
    'nameSpaces': {
      _ns: [item],
    },
    'issuerAuth': [
      cborEncode({1: -7}),
      <Object?, Object?>{},
      cborEncode(CborTag.embedded(mso)),
      Uint8List(64),
    ],
  });
  return base64Url.encode(encoded).replaceAll('=', '');
}

void main() {
  group('getMdocCredentialData', () {
    late _MockPlatformP256Keys keys;

    setUp(() => keys = _MockPlatformP256Keys());

    test('maps the mdoc into credential data', () async {
      final issuerSigned = _issuerSigned();

      final data = await getMdocCredentialData(
        issuerSigned: issuerSigned,
        credentialType: 'mDL',
        platformKeys: keys,
      );

      expect(data['type'], ['mDL']);
      expect(data['docType'], 'org.iso.18013.5.1.mDL');
      expect(data['issuerSigned'], issuerSigned);
      expect(data['expirationDate'], '2027-10-01T00:00:00.000Z');
      expect(data['credentialSubject'], {
        'type': 'mDL',
        _ns: {'family_name': 'Doe'},
      });
    });

    test('accepts an mdoc bound to the platform key', () async {
      when(() => keys.find('mdoc_1')).thenAnswer(
        (_) async => PlatformP256Key(
          alias: 'mdoc_1',
          publicKey: _devicePoint,
          hardwareBacked: true,
        ),
      );

      final data = await getMdocCredentialData(
        issuerSigned: _issuerSigned(),
        credentialType: 'mDL',
        keyId: 'mdoc_1',
        platformKeys: keys,
      );

      expect(data['docType'], 'org.iso.18013.5.1.mDL');
    });

    test('rejects an mdoc bound to another key', () {
      when(() => keys.find('mdoc_1')).thenAnswer(
        (_) async => PlatformP256Key(
          alias: 'mdoc_1',
          publicKey: Uint8List.fromList([0x04, ...List.filled(64, 9)]),
          hardwareBacked: true,
        ),
      );

      expect(
        () => getMdocCredentialData(
          issuerSigned: _issuerSigned(),
          credentialType: 'mDL',
          keyId: 'mdoc_1',
          platformKeys: keys,
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });

    test('rejects elements that do not match the MSO digests', () {
      expect(
        () => getMdocCredentialData(
          issuerSigned: _issuerSigned(tamper: true),
          credentialType: 'mDL',
          platformKeys: keys,
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });

    test('rejects something that is not an mdoc', () {
      expect(
        () => getMdocCredentialData(
          issuerSigned: 'bm90LWNib3I',
          credentialType: 'mDL',
          platformKeys: keys,
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });
  });
}
