import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/helper_function/get_authorization_uri_for_issuer.dart';
import 'package:altme/oidc4vc/model/oidc4vci_state.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class _MockProfileCubit extends Mock implements ProfileCubit {}

class _MockQRCodeScanCubit extends Mock implements QRCodeScanCubit {}

class _MockSecureStorage extends Mock implements SecureStorageProvider {}

class _FakeOidc4VCIState extends Fake implements Oidc4VCIState {}

const _issuer = 'https://issuer.example.com';
const _parEndpoint = '$_issuer/par';
const _authorizationEndpoint = '$_issuer/authorize';
const _configurationId = 'pid';

/// An authorization server that answers the Pushed Authorization Request and
/// records what it was sent.
class _FakeAuthorizationServer implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (options.uri.toString() != _parEndpoint) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'not served: ${options.uri}',
      );
    }
    return ResponseBody.fromString(
      jsonEncode({'request_uri': 'urn:request:abc', 'expires_in': 60}),
      201,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('getAuthorizationUriForIssuer', () {
    late _FakeAuthorizationServer server;
    late _MockProfileCubit profileCubit;
    late Oidc4vcParameters parameters;

    setUpAll(() => registerFallbackValue(_FakeOidc4VCIState()));

    setUp(() {
      server = _FakeAuthorizationServer();
      profileCubit = _MockProfileCubit();
      when(
        () => profileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));
      when(
        () => profileCubit.oidc4vc,
      ).thenReturn(Oidc4vciClientFactory.create(OIDC4VCIDraftType.final1));

      final metadata = <String, dynamic>{
        'credential_issuer': _issuer,
        'authorization_endpoint': _authorizationEndpoint,
        'pushed_authorization_request_endpoint': _parEndpoint,
        'credential_configurations_supported': {
          _configurationId: {'format': 'dc+sd-jwt', 'scope': _configurationId},
        },
      };
      final configuration = OpenIdConfiguration.fromJson(
        metadata,
      ).copyWith(rawConfiguration: metadata);
      parameters = Oidc4vcParameters(
        oidc4vciDraftType: OIDC4VCIDraftType.final1,
        useOAuthAuthorizationServerLink: false,
        initialUri: Uri(),
        userPinRequired: false,
        issuerState: null,
        issuer: _issuer,
        issuerOpenIdConfiguration: configuration,
        authorizationServerOpenIdConfiguration: configuration,
        authorizationEndpoint: _authorizationEndpoint,
      );
    });

    Future<Uri?> authorizationUri(IssuanceDecisions decisions) =>
        getAuthorizationUriForIssuer(
          oidc4vcParameters: parameters,
          didKitProvider: DIDKitProvider(),
          selectedCredentials: const [_configurationId],
          scope: false,
          clientId: 'the-client',
          clientSecret: null,
          clientAuthentication: ClientAuthentication.clientId,
          formatsSupported: const [VCFormatType.dcSdJWT],
          decisions: decisions,
          client: DioClient(
            secureStorageProvider: _MockSecureStorage(),
            dio: Dio()..httpClientAdapter = server,
          ),
          profileType: ProfileType.custom,
          walletIssuer: 'https://wallet.example',
          useOAuthAuthorizationServerLink: false,
          profileCubit: profileCubit,
          qrCodeScanCubit: _MockQRCodeScanCubit(),
          publicKeyForDPop: generateP256KeyForDPop(),
        );

    Oidc4VCIState savedState() =>
        verify(() => profileCubit.addOidc4VCI(captureAny())).captured.single
            as Oidc4VCIState;

    test('pushes the request with a DPoP proof when the policy decided on PAR '
        'and DPoP', () async {
      final uri = await authorizationUri(
        const IssuanceDecisions(
          par: true,
          walletAttestation: false,
          attestationChallenge: false,
          dpop: true,
          keyAttestation: false,
        ),
      );

      expect(server.requests.single.uri.toString(), _parEndpoint);
      expect(server.requests.single.headers['DPoP'], isA<String>());
      expect(uri?.queryParameters['request_uri'], 'urn:request:abc');
      final state = savedState();
      expect(state.dpop, isTrue);
      expect(state.clientAuthentication, ClientAuthentication.clientId);
    });

    test('sends the request in the front channel, without DPoP, when the '
        'policy decided against PAR', () async {
      final uri = await authorizationUri(
        const IssuanceDecisions(
          par: false,
          walletAttestation: false,
          attestationChallenge: false,
          dpop: false,
          keyAttestation: false,
        ),
      );

      expect(server.requests, isEmpty);
      expect(uri?.path, '/authorize');
      expect(uri?.queryParameters['request_uri'], isNull);
      expect(savedState().dpop, isFalse);
    });
  });

  group('Oidc4VCIState.clientAuthenticationFor', () {
    Oidc4VCIState state({ClientAuthentication? clientAuthentication}) =>
        Oidc4VCIState(
          codeVerifier: 'verifier',
          challenge: 'challenge',
          selectedCredentials: const [],
          issuer: _issuer,
          isEBSI: false,
          publicKeyForDPo: '{}',
          oidc4vciDraft: '1.0',
          tokenEndpoint: '$_issuer/token',
          clientAuthentication: clientAuthentication,
        );
    final profile = ProfileModel.empty()
        .profileSetting
        .selfSovereignIdentityOptions
        .customOidc4vcProfile
        .copyWith(clientAuthentication: ClientAuthentication.clientId);

    test('resumes with the client authentication decided at the start', () {
      expect(
        state(
          clientAuthentication: ClientAuthentication.wia,
        ).clientAuthenticationFor(profile),
        ClientAuthentication.wia,
      );
    });

    test(
      "falls back to the profile's for a state saved before the policies",
      () {
        expect(
          state().clientAuthenticationFor(profile),
          ClientAuthentication.clientId,
        );
      },
    );
  });
}
