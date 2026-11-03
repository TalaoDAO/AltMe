import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class _MockDioClient extends Mock implements DioClient {}

class _MockScanCubit extends Mock implements ScanCubit {}

class _MockProfileCubit extends Mock implements ProfileCubit {}

class _MockCredentialsCubit extends Mock implements CredentialsCubit {}

class _MockQueryByExampleCubit extends Mock implements QueryByExampleCubit {}

class _MockDeepLinkCubit extends Mock implements DeepLinkCubit {}

class _MockBeacon extends Mock implements Beacon {}

class _MockWalletConnectCubit extends Mock implements WalletConnectCubit {}

class _MockSecureStorage extends Mock implements SecureStorageProvider {}

class _MockDIDKitProvider extends Mock implements DIDKitProvider {}

class _MockOIDC4VCIClient extends Mock implements OIDC4VCIClient {}

class _MockWalletCubit extends Mock implements WalletCubit {}

class _MockEnterpriseCubit extends Mock implements EnterpriseCubit {}

String _encode(Map<String, dynamic> part) =>
    base64Url.encode(utf8.encode(jsonEncode(part))).replaceAll('=', '');

void main() {
  final uri = Uri.parse('openid4vp://?client_id=x509_hash%3Aabc');
  const dcqlQuery = {
    'credentials': [
      {'id': 'qes_attestation', 'format': 'dc+sd-jwt'},
    ],
  };
  final qesApproval = _encode({
    'type': qesApprovalTransactionType,
    'credential_ids': ['qes_attestation'],
    'documentInfos': [
      {'label': 'Contract', 'hash': 'aGFzaA=='},
    ],
  });

  late _MockScanCubit scanCubit;
  late QRCodeScanCubit cubit;

  setUp(() {
    scanCubit = _MockScanCubit();
    when(
      () => scanCubit.sendErrorToServer(
        uri: any(named: 'uri'),
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async {});

    cubit = QRCodeScanCubit(
      client: _MockDioClient(),
      scanCubit: scanCubit,
      profileCubit: _MockProfileCubit(),
      credentialsCubit: _MockCredentialsCubit(),
      queryByExampleCubit: _MockQueryByExampleCubit(),
      deepLinkCubit: _MockDeepLinkCubit(),
      jwtDecode: JWTDecode(),
      beacon: _MockBeacon(),
      walletConnectCubit: _MockWalletConnectCubit(),
      secureStorageProvider: _MockSecureStorage(),
      didKitProvider: _MockDIDKitProvider(),
      oidc4vc: _MockOIDC4VCIClient(),
      walletCubit: _MockWalletCubit(),
      enterpriseCubit: _MockEnterpriseCubit(),
      resolvePolicy: (_) => throw UnimplementedError(),
    );
  });

  setUpAll(() => registerFallbackValue(Uri()));

  tearDown(() => cubit.close());

  group('checkTransactionData', () {
    test('accepts a request without transaction_data', () {
      cubit.checkTransactionData(
        uri: uri,
        requestObject: const {'dcql_query': dcqlQuery},
      );

      verifyNever(
        () => scanCubit.sendErrorToServer(
          uri: any(named: 'uri'),
          data: any(named: 'data'),
        ),
      );
    });

    test('accepts a QES approval bound to a requested credential', () {
      cubit.checkTransactionData(
        uri: uri,
        requestObject: {
          'dcql_query': dcqlQuery,
          'transaction_data': [qesApproval],
        },
      );

      verifyNever(
        () => scanCubit.sendErrorToServer(
          uri: any(named: 'uri'),
          data: any(named: 'data'),
        ),
      );
    });

    test('tells the verifier invalid_transaction_data and stops', () {
      final unsupported = _encode({
        'type': 'evm.erc20_transfer',
        'credential_ids': ['qes_attestation'],
      });

      expect(
        () => cubit.checkTransactionData(
          uri: uri,
          requestObject: {
            'dcql_query': dcqlQuery,
            'transaction_data': [unsupported],
          },
        ),
        throwsA(
          isA<ResponseMessage>().having(
            (e) => (e.data as Map)['error'],
            'error',
            'invalid_transaction_data',
          ),
        ),
      );
      final sent =
          verify(
                () => scanCubit.sendErrorToServer(
                  uri: uri,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(sent['error'], 'invalid_transaction_data');
    });

    test('refuses a transaction bound to a credential not requested', () {
      expect(
        () => cubit.checkTransactionData(
          uri: uri,
          requestObject: {
            'dcql_query': const {'credentials': <dynamic>[]},
            'transaction_data': [qesApproval],
          },
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });
  });
}
