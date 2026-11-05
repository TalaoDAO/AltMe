import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/qr_code/qr_code.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

import '../../test_objects.dart';

class _MockDioClient extends Mock implements DioClient {}

class _MockCredentialsCubit extends Mock implements CredentialsCubit {}

class _MockProfileCubit extends Mock implements ProfileCubit {}

class _MockQRCodeScanCubit extends Mock implements QRCodeScanCubit {}

class _MockActivityLogManager extends Mock implements ActivityLogManager {}

class _MockDIDKitProvider extends Mock implements DIDKitProvider {}

class _MockSecureStorageProvider extends Mock
    implements SecureStorageProvider {}

class _MockWalletCubit extends Mock implements WalletCubit {}

class _MockOidc4vci extends Mock implements OIDC4VCIClient {}

class _MockJWTDecode extends Mock implements JWTDecode {}

class _FakeLogData extends Fake implements LogData {}

/// Answers every request with [status] and [headers], as a verifier does.
class _VerifierAdapter implements HttpClientAdapter {
  _VerifierAdapter(this.status, {this.headers = const {}});

  final int status;
  final Map<String, List<String>> headers;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString('{}', status, headers: headers);

  @override
  void close({bool force = false}) {}
}

String _b64(String hex) => base64Url
    .encode([
      for (var i = 0; i < hex.length; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16),
    ])
    .replaceAll('=', '');

/// A DCQL request answered with an encrypted response to a verifier key.
final _uri = Uri.parse('openid4vp://authorize').replace(
  queryParameters: {
    'response_type': 'vp_token',
    'response_mode': 'direct_post.jwt',
    'response_uri': 'https://verifier.example/response',
    'client_id': 'x509_hash:abc',
    'client_metadata': jsonEncode({
      'jwks': {
        'keys': [
          {
            'kty': 'EC',
            'crv': 'P-256',
            'kid': 'enc-1',
            'x': _b64(
              '3af62403773b41333de41615255bc71c9b77bec1b470b2be7b02c78b5fa4a6c1',
            ),
            'y': _b64(
              'a14777590b296e43644fc54ee750a46e1b88fb9817c2030d0d1a861b66a7b40b',
            ),
          },
        ],
      },
    }),
  },
);

void main() {
  late _MockDioClient client;
  late _MockCredentialsCubit credentialsCubit;
  late ScanCubit scanCubit;
  late Dio dio;

  setUpAll(() => registerFallbackValue(_FakeLogData()));

  setUp(() {
    client = _MockDioClient();
    dio = Dio();
    when(() => client.dio).thenReturn(dio);
    credentialsCubit = _MockCredentialsCubit();
    when(
      () => credentialsCubit.deleteConsumedCopies(any()),
    ).thenAnswer((_) async {});
    final profileCubit = _MockProfileCubit();
    when(
      () => profileCubit.state,
    ).thenReturn(ProfileState(model: ProfileModel.empty()));
    scanCubit = ScanCubit(
      client: client,
      credentialsCubit: credentialsCubit,
      didKitProvider: _MockDIDKitProvider(),
      secureStorageProvider: _MockSecureStorageProvider(),
      profileCubit: profileCubit,
      walletCubit: _MockWalletCubit(),
      oidc4vc: _MockOidc4vci(),
      jwtDecode: _MockJWTDecode(),
      activityLogManager: _MockActivityLogManager(),
    );
  });

  tearDown(() => scanCubit.close());

  Future<void> present(List<CredentialModel> presented) =>
      scanCubit.presentOidc4vpFinal(
        uri: _uri,
        credentialModel: TEST_CREDENTIAL,
        keyId: 'key',
        vpToken: const {
          'pid': ['token'],
        },
        issuer: Issuer.emptyIssuer('verifier.example'),
        qrCodeScanCubit: _MockQRCodeScanCubit(),
        presentedCredentials: presented,
      );

  final copies = [
    TEST_CREDENTIAL.copyWith(id: 'copy-1', batchId: 'batch'),
    TEST_CREDENTIAL.copyWith(id: 'alone'),
  ];

  group('presentOidc4vpFinal single use', () {
    test(
      'destroys the presented copies once the verifier answers 200',
      () async {
        dio.httpClientAdapter = _VerifierAdapter(200);

        await present(copies);

        expect(scanCubit.state.status, ScanStatus.success);
        verify(
          () => credentialsCubit.deleteConsumedCopies(
            any(that: containsAll(['copy-1', 'alone'])),
          ),
        ).called(1);
      },
    );

    test(
      'destroys the presented copies once the verifier answers 302',
      () async {
        dio.httpClientAdapter = _VerifierAdapter(
          302,
          headers: {
            'location': ['https://verifier.example/done'],
          },
        );

        await present(copies);

        verify(() => credentialsCubit.deleteConsumedCopies(any())).called(1);
      },
    );

    test('keeps every copy when the verifier refuses', () async {
      dio.httpClientAdapter = _VerifierAdapter(400);

      await present(copies);

      expect(scanCubit.state.status, ScanStatus.error);
      verifyNever(() => credentialsCubit.deleteConsumedCopies(any()));
    });

    test('an accepted presentation stays a success when a copy cannot be '
        'deleted', () async {
      dio.httpClientAdapter = _VerifierAdapter(200);
      when(
        () => credentialsCubit.deleteConsumedCopies(any()),
      ).thenThrow(Exception('storage unavailable'));

      await present(copies);

      expect(scanCubit.state.status, ScanStatus.success);
    });
  });
}
