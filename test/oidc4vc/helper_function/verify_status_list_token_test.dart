import 'package:altme/oidc4vc/helper_function/verify_encoded_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jose_plus/jose.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

const _issuer = 'https://status.example.com/statuslist';
const _statusListKid = 'status-list-key';

Map<String, dynamic> _publicJwk(JsonWebKey key) =>
    Map<String, dynamic>.from(key.toJson())..remove('d');

String _statusListToken(JsonWebKey key) {
  final builder = JsonWebSignatureBuilder()
    ..jsonContent = {
      'iss': _issuer,
      'sub': '$_issuer/1',
      'iat': 1792169054,
      'status_list': {'bits': 1, 'lst': 'eNrbuRgAAhcBXQ'},
    }
    ..setProtectedHeader('typ', 'statuslist+jwt')
    ..setProtectedHeader('kid', _statusListKid)
    ..addRecipient(key, algorithm: 'ES256');
  return builder.build().toCompactSerialization();
}

void main() {
  // Key discovery clears a cache entry in secure storage first.
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (_) async => null,
      );
  setUpAll(() => initSecureStorage);

  late JsonWebKey statusListKey;
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    statusListKey = JsonWebKey.generate('ES256');
    dio = Dio();
    // Any request it has no route for fails: discovery must not run unless
    // a test sets it up.
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
  });

  Future<VerificationType> verify({Map<String, dynamic>? referencedTokenKey}) =>
      verifyStatusListToken(
        statusListToken: _statusListToken(statusListKey),
        issuer: _issuer,
        jwtDecode: JWTDecode(),
        referencedTokenKey: referencedTokenKey,
        useOAuthAuthorizationServerLink: false,
        dio: dio,
      );

  void publishStatusListKey() {
    dioAdapter
      ..onGet(
        'https://status.example.com/.well-known/oauth-authorization-server/statuslist',
        (server) =>
            server.reply(200, {'issuer': _issuer, 'jwks_uri': '$_issuer/jwks'}),
      )
      ..onGet(
        '$_issuer/jwks',
        (server) => server.reply(200, {
          'keys': [
            {..._publicJwk(statusListKey), 'kid': _statusListKid},
          ],
        }),
      );
  }

  group('verifyStatusListToken', () {
    test('verifies with the Referenced Token key, whatever kid the '
        'Status List Token names, without looking the key up', () async {
      final referencedTokenKey = {
        ..._publicJwk(statusListKey),
        'kid': 'did:web:wallet-provider.com#key-1',
      };

      expect(
        await verify(referencedTokenKey: referencedTokenKey),
        VerificationType.verified,
      );
      // The caller's key is left as it was.
      expect(referencedTokenKey['kid'], 'did:web:wallet-provider.com#key-1');
    });

    test('looks the key up from the issuer when the Referenced Token key '
        'did not sign it', () async {
      publishStatusListKey();

      expect(
        await verify(
          referencedTokenKey: _publicJwk(JsonWebKey.generate('ES256')),
        ),
        VerificationType.verified,
      );
    });

    test('looks the key up from the issuer without a Referenced Token '
        'key', () async {
      publishStatusListKey();

      expect(await verify(), VerificationType.verified);
    });

    test('fails when neither key signed it', () async {
      dioAdapter
        ..onGet(
          'https://status.example.com/.well-known/oauth-authorization-server/statuslist',
          (server) => server.reply(200, {
            'issuer': _issuer,
            'jwks_uri': '$_issuer/jwks',
          }),
        )
        ..onGet(
          '$_issuer/jwks',
          (server) => server.reply(200, {
            'keys': [
              {
                ..._publicJwk(JsonWebKey.generate('ES256')),
                'kid': _statusListKid,
              },
            ],
          }),
        );

      expect(
        await verify(
          referencedTokenKey: _publicJwk(JsonWebKey.generate('ES256')),
        ),
        VerificationType.notVerified,
      );
    });
  });

  group('x5cLeafKey', () {
    test('is null for a token without x5c', () {
      expect(
        x5cLeafKey(
          jwt: _statusListToken(statusListKey),
          jwtDecode: JWTDecode(),
        ),
        isNull,
      );
    });
  });
}
