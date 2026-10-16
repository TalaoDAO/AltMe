import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/oidc4vc/model/oidc4vci_state.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
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

class _FakeOidc4VCIState extends Fake implements Oidc4VCIState {}

/// Loads the policy files shipped with `package:oidc4vc` straight from disk.
final shippedPolicies = ProfilePolicyLoader(
  readFile: (id) =>
      File('../../packages/oidc4vc/assets/policies/$id.json').readAsString(),
);

String _encode(Map<String, dynamic> part) =>
    base64Url.encode(utf8.encode(jsonEncode(part))).replaceAll('=', '');

String _jwt(Map<String, dynamic> payload) =>
    '${_encode(const {'alg': 'ES256'})}.${_encode(payload)}.signature';

void main() {
  const requestUri = 'https://verifier.example/request';
  const haipRequest = {
    'client_id': 'x509_hash:abc',
    'response_mode': 'direct_post.jwt',
    'response_type': 'vp_token',
  };
  const plainRequest = {
    'client_id': 'redirect_uri:https://verifier.example',
    'response_mode': 'direct_post',
    'response_type': 'vp_token',
  };
  final byValue = Uri(scheme: 'openid4vp', queryParameters: plainRequest);
  final byReference = Uri(
    scheme: 'openid4vp',
    queryParameters: {'client_id': 'x509_hash:abc', 'request_uri': requestUri},
  );

  late _MockDioClient client;
  late _MockProfileCubit profileCubit;
  late _MockOIDC4VCIClient oidc4vc;
  late PolicyMode mode;
  late int resolutions;
  late QRCodeScanCubit cubit;

  setUpAll(() {
    registerFallbackValue(_FakeOidc4VCIState());
    registerFallbackValue(Dio());
  });

  setUp(() {
    forgetRequestObjects();
    client = _MockDioClient();
    profileCubit = _MockProfileCubit();
    oidc4vc = _MockOIDC4VCIClient();
    mode = PolicyMode.strict;
    resolutions = 0;

    final model = ProfileModel.empty();
    when(() => profileCubit.state).thenReturn(ProfileState(model: model));
    when(() => client.dio).thenReturn(Dio());

    cubit = QRCodeScanCubit(
      client: client,
      scanCubit: _MockScanCubit(),
      profileCubit: profileCubit,
      credentialsCubit: _MockCredentialsCubit(),
      queryByExampleCubit: _MockQueryByExampleCubit(),
      deepLinkCubit: _MockDeepLinkCubit(),
      jwtDecode: JWTDecode(),
      beacon: _MockBeacon(),
      walletConnectCubit: _MockWalletConnectCubit(),
      secureStorageProvider: _MockSecureStorage(),
      didKitProvider: _MockDIDKitProvider(),
      oidc4vc: oidc4vc,
      walletCubit: _MockWalletCubit(),
      enterpriseCubit: _MockEnterpriseCubit(),
      resolvePolicy: (model) async {
        resolutions++;
        return ProfilePolicyContext(
          policy: await shippedPolicies.load('haip'),
          mode: mode,
          profile: model
              .profileSetting
              .selfSovereignIdentityOptions
              .customOidc4vcProfile,
        );
      },
    );
  });

  tearDown(() => cubit.close());

  void fetchReturns(Future<String> Function() answer) => when(
    () => oidc4vc.fetchRequestObject(
      requestUri: requestUri,
      dio: any(named: 'dio'),
      requestUriMethod: any(named: 'requestUriMethod'),
      walletMetadata: any(named: 'walletMetadata'),
    ),
  ).thenAnswer((_) => answer());

  group('enforcePresentationPolicy', () {
    test('stops a request that misses the rules under strict', () {
      expect(
        () => cubit.enforcePresentationPolicy(byValue),
        throwsA(
          isA<ResponseMessage>().having(
            (message) => message.data?['error'],
            'error',
            'policy_violation',
          ),
        ),
      );
    });

    test('lets the same request through under lenient', () async {
      mode = PolicyMode.lenient;

      await expectLater(cubit.enforcePresentationPolicy(byValue), completes);
    });

    test('judges the Request Object fetched from request_uri', () async {
      fetchReturns(() async => _jwt(haipRequest));
      await expectLater(
        cubit.enforcePresentationPolicy(byReference),
        completes,
      );

      forgetRequestObjects();
      fetchReturns(() async => _jwt(plainRequest));
      await expectLater(
        cubit.enforcePresentationPolicy(byReference),
        throwsA(isA<ResponseMessage>()),
      );
    });

    test('leaves a request_uri that could not be fetched to the next step, '
        'without a policy verdict', () async {
      fetchReturns(() async => throw Exception('unreachable'));

      await expectLater(
        cubit.enforcePresentationPolicy(byReference),
        completes,
      );
      expect(resolutions, 0);
    });
  });

  group('processSelectedCredentials', () {
    test('stops on a No before any request to the issuer', () async {
      // CORE issuer tests 3/4: the authorization server does not require PAR.
      const authorizationServer = {
        'issuer': 'https://as.example',
        'pushed_authorization_request_endpoint': 'https://as.example/par',
        'require_pushed_authorization_requests': false,
      };
      final configuration = OpenIdConfiguration.fromJson(
        authorizationServer,
      ).copyWith(rawConfiguration: authorizationServer);

      await cubit.processSelectedCredentials(
        selectedCredentials: const ['pid'],
        userPin: null,
        txCode: null,
        oidc4vcParameters: Oidc4vcParameters(
          oidc4vciDraftType: OIDC4VCIDraftType.final1,
          useOAuthAuthorizationServerLink: false,
          initialUri: Uri(),
          userPinRequired: false,
          issuerState: null,
          issuerOpenIdConfiguration: OpenIdConfiguration.fromJson(const {}),
          authorizationServerOpenIdConfiguration: configuration,
        ),
      );

      expect(cubit.state.status, QrScanStatus.error);
      final error = cubit.state.message?.messageHandler as ResponseMessage?;
      expect(error?.data?['error'], 'policy_violation');
      expect(
        error?.data?['error_description'],
        contains('HAIP_PAR_REQUIRED_BY_AS'),
      );
      verifyZeroInteractions(client);
      verifyNever(() => profileCubit.addOidc4VCI(any()));
    });
  });
}
