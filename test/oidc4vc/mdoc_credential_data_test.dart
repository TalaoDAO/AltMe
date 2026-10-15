import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/oidc4vc/helper_function/mdoc_credential_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

import 'support/issuer_signed_fixture.dart';

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

void main() {
  group('getMdocCredentialData', () {
    late _MockPlatformP256Keys keys;

    setUp(() => keys = _MockPlatformP256Keys());

    test('maps the mdoc into credential data', () async {
      final issuerSigned = testIssuerSigned();

      final data = await getMdocCredentialData(
        issuerSigned: issuerSigned,
        credentialType: 'mDL',
        platformKeys: keys,
      );

      expect(data['type'], ['mDL']);
      expect(data['docType'], mdlDocType);
      expect(data['issuerSigned'], issuerSigned);
      expect(data['expirationDate'], '2099-01-01T00:00:00.000Z');
      expect(data['credentialSubject'], {
        'type': 'mDL',
        mdlNameSpace: {'family_name': 'Doe', 'age_over_18': true},
      });
    });

    test('stores JPEG images as data URIs, other bytes as base64url', () async {
      final jpeg = Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 1, 2]);

      final data = await getMdocCredentialData(
        issuerSigned: testIssuerSigned(
          elements: {
            'portrait': jpeg,
            'signature_usual_mark': Uint8List.fromList([1, 2, 3]),
          },
        ),
        credentialType: 'mDL',
        platformKeys: keys,
      );

      final elements =
          (data['credentialSubject'] as Map<String, dynamic>)[mdlNameSpace]
              as Map<String, Object?>;
      expect(elements['portrait'], 'data:image/jpeg;base64,/9j/4AEC');
      expect(elements['signature_usual_mark'], 'AQID');
    });

    test('accepts an mdoc bound to the platform key', () async {
      when(() => keys.find('mdoc_1')).thenAnswer(
        (_) async => PlatformP256Key(
          alias: 'mdoc_1',
          publicKey: testDevicePoint,
          hardwareBacked: true,
        ),
      );

      final data = await getMdocCredentialData(
        issuerSigned: testIssuerSigned(),
        credentialType: 'mDL',
        keyId: 'mdoc_1',
        platformKeys: keys,
      );

      expect(data['docType'], mdlDocType);
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
          issuerSigned: testIssuerSigned(),
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
          issuerSigned: testIssuerSigned(tamper: true),
          credentialType: 'mDL',
          platformKeys: keys,
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });

    test('rejects an issuer signature that does not verify', () {
      expect(
        () => getMdocCredentialData(
          issuerSigned: testIssuerSigned(badSignature: true),
          credentialType: 'mDL',
          platformKeys: keys,
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });

    test('accepts the docType the issuer offered', () async {
      final data = await getMdocCredentialData(
        issuerSigned: testIssuerSigned(),
        credentialType: 'mDL',
        expectedDocType: mdlDocType,
        platformKeys: keys,
      );

      expect(data['docType'], mdlDocType);
    });

    test('rejects a docType other than the one offered', () {
      expect(
        () => getMdocCredentialData(
          issuerSigned: testIssuerSigned(docType: 'eu.europa.ec.eudi.pid.1'),
          credentialType: 'mDL',
          expectedDocType: mdlDocType,
          platformKeys: keys,
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });

    test('rejects an mdoc outside its validity period', () {
      Future<void> at(DateTime now) => getMdocCredentialData(
        issuerSigned: testIssuerSigned(validUntil: '2027-10-01T00:00:00Z'),
        credentialType: 'mDL',
        now: now,
        platformKeys: keys,
      );

      expect(
        () => at(DateTime.utc(2027, 10, 2)),
        throwsA(isA<ResponseMessage>()),
      );
      expect(
        () => at(DateTime.utc(2026, 9, 30)),
        throwsA(isA<ResponseMessage>()),
      );
      expect(at(DateTime.utc(2027)), completes);
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
