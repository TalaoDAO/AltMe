import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/oidc4vc/helper_function/credential_key_alias.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

import '../support/issuer_signed_fixture.dart';

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

/// The SEC1 point of a test key whose coordinates are all [byte].
Uint8List _point(int byte) => Uint8List.fromList([
  0x04,
  ...List.filled(32, byte),
  ...List.filled(32, byte + 1),
]);

String _b64(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');

/// An SD-JWT whose issuer JWT binds it to the key of [point], or to no key.
String _sdJwt({Uint8List? point}) {
  final payload = {
    'vct': 'urn:eudi:pid:1',
    if (point != null)
      'cnf': {
        'jwk': {
          'kty': 'EC',
          'crv': 'P-256',
          'x': _b64(point.sublist(1, 33)),
          'y': _b64(point.sublist(33, 65)),
        },
      },
  };
  return '${_b64(utf8.encode('{"alg":"ES256"}'))}'
      '.${_b64(utf8.encode(jsonEncode(payload)))}.c2ln~';
}

void main() {
  group('isPlatformKeyAlias', () {
    test('names mdoc and SD-JWT batch keys', () {
      expect(isPlatformKeyAlias('mdoc_1'), isTrue);
      expect(isPlatformKeyAlias(newSdJwtKeyAlias()), isTrue);
    });

    test('does not name a Wallet Key Attestation key', () {
      expect(isPlatformKeyAlias('wka-key-1'), isFalse);
    });
  });

  group('boundKeyAlias', () {
    late _MockPlatformP256Keys keys;

    setUp(() {
      keys = _MockPlatformP256Keys();
      for (final (alias, byte) in [('key_a', 3), ('key_b', 5)]) {
        when(() => keys.find(alias)).thenAnswer(
          (_) async => PlatformP256Key(
            alias: alias,
            publicKey: _point(byte),
            hardwareBacked: true,
          ),
        );
      }
      when(() => keys.find('missing')).thenAnswer((_) async => null);
    });

    test('finds the key an SD-JWT names in cnf.jwk, whatever the order of '
        'the keys', () async {
      expect(
        await boundKeyAlias(
          credential: _sdJwt(point: _point(5)),
          format: 'dc+sd-jwt',
          aliases: ['key_a', 'key_b'],
          platformKeys: keys,
        ),
        'key_b',
      );
      expect(
        await boundKeyAlias(
          credential: _sdJwt(point: _point(3)),
          format: 'dc+sd-jwt',
          aliases: ['key_b', 'missing', 'key_a'],
          platformKeys: keys,
        ),
        'key_a',
      );
    });

    test('finds none for an SD-JWT bound to another key or to none', () async {
      expect(
        await boundKeyAlias(
          credential: _sdJwt(point: _point(9)),
          format: 'dc+sd-jwt',
          aliases: ['key_a', 'key_b'],
          platformKeys: keys,
        ),
        isNull,
      );
      expect(
        await boundKeyAlias(
          credential: _sdJwt(),
          format: 'dc+sd-jwt',
          aliases: ['key_a', 'key_b'],
          platformKeys: keys,
        ),
        isNull,
      );
    });

    test('finds the device key of an mso_mdoc', () async {
      expect(
        await boundKeyAlias(
          credential: testIssuerSigned(devicePoint: _point(5)),
          format: 'mso_mdoc',
          aliases: ['key_a', 'key_b'],
          platformKeys: keys,
        ),
        'key_b',
      );
    });

    test('finds none for an mso_mdoc bound to another key', () async {
      expect(
        await boundKeyAlias(
          credential: testIssuerSigned(devicePoint: _point(9)),
          format: 'mso_mdoc',
          aliases: ['key_a', 'key_b'],
          platformKeys: keys,
        ),
        isNull,
      );
    });
  });
}
