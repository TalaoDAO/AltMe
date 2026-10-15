import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/model/oidc4vci_state.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:protocol_trace/protocol_trace.dart';

/// Loads the policy files shipped with `package:oidc4vc` straight from disk.
final shippedPolicies = ProfilePolicyLoader(
  readFile: (id) =>
      File('../../packages/oidc4vc/assets/policies/$id.json').readAsString(),
);

OpenIdConfiguration metadata(Map<String, dynamic> json) =>
    OpenIdConfiguration.fromJson(json).copyWith(rawConfiguration: json);

Oidc4vcParameters parameters({
  Map<String, dynamic> authorizationServer = const {},
  Map<String, dynamic> issuer = const {},
}) => Oidc4vcParameters(
  oidc4vciDraftType: OIDC4VCIDraftType.final1,
  useOAuthAuthorizationServerLink: false,
  initialUri: Uri(),
  userPinRequired: false,
  issuerState: null,
  issuerOpenIdConfiguration: metadata(issuer),
  authorizationServerOpenIdConfiguration: metadata(authorizationServer),
);

ProfileModel withOidc4vc(
  ProfileModel model,
  CustomOidc4VcProfile Function(CustomOidc4VcProfile profile) change,
) {
  final options = model.profileSetting.selfSovereignIdentityOptions;
  return model.copyWith(
    profileSetting: model.profileSetting.copyWith(
      selfSovereignIdentityOptions: options.copyWith(
        customOidc4vcProfile: change(options.customOidc4vcProfile),
      ),
    ),
  );
}

void main() {
  final defaultOne = ProfileModel.defaultOne(
    walletType: WalletType.personal,
    walletProtectionType: WalletProtectionType.pinCode,
    isDeveloperMode: false,
    clientId: null,
    clientSecret: null,
  );
  final custom = ProfileModel.empty();
  final eudiw = ProfileModel.empty().copyWith(
    profileType: ProfileType.EUDIW,
    profileSetting: ProfileSetting.provider(),
  );

  Future<ProfilePolicyContext> resolve(ProfileModel model) =>
      ProfilePolicyContext.resolve(model, loader: shippedPolicies);

  const advertisesDpop = {
    'dpop_signing_alg_values_supported': ['ES256'],
  };
  const asksForAttestation = {
    'token_endpoint_auth_methods_supported': [
      'private_key_jwt',
      'attest_jwt_client_auth',
    ],
  };
  // CORE issuer tests 3/4.
  const parNotRequired = {
    'pushed_authorization_request_endpoint': 'https://as.example/par',
    'require_pushed_authorization_requests': false,
  };

  group('resolve', () {
    test('loads the policy Parameters maps the profile to', () async {
      expect((await resolve(defaultOne)).policy.id, 'core');
      expect((await resolve(custom)).policy.id, 'core');
      expect((await resolve(eudiw)).policy.id, 'haip');
      expect((await resolve(eudiw)).mode, PolicyMode.lenient);
    });

    test('keeps the profile flags when the policy file fails', () async {
      final context = await ProfilePolicyContext.resolve(
        custom,
        loader: ProfilePolicyLoader(readFile: (_) async => 'not json'),
      );

      expect(context.loadError, isA<PolicyLoadException>());
      expect(
        context.decide(parameters(authorizationServer: advertisesDpop)).dpop,
        isFalse,
      );
    });
  });

  group('decide', () {
    group('DPoP (#3515)', () {
      test('is used when the authorization server advertises it', () async {
        final context = await resolve(defaultOne);

        expect(
          context.decide(parameters(authorizationServer: advertisesDpop)).dpop,
          isTrue,
        );
      });

      test('is not used when the server does not advertise it', () async {
        final context = await resolve(defaultOne);

        expect(context.decide(parameters()).dpop, isFalse);
      });

      test('is always used when the profile switches it on', () async {
        final context = await resolve(
          withOidc4vc(custom, (p) => p.copyWith(dpopSupport: true)),
        );

        expect(context.decide(parameters()).dpop, isTrue);
      });
    });

    group('client authentication (#3538)', () {
      test('is WIA when the authorization server asks for it', () async {
        final context = await resolve(custom);
        final decisions = context.decide(
          parameters(authorizationServer: asksForAttestation),
        );

        expect(decisions.walletAttestation, isTrue);
        expect(
          context.clientAuthentication(decisions),
          ClientAuthentication.wia,
        );
      });

      test("is the profile's own otherwise", () async {
        final context = await resolve(custom);

        expect(
          context.clientAuthentication(context.decide(parameters())),
          custom
              .profileSetting
              .selfSovereignIdentityOptions
              .customOidc4vcProfile
              .clientAuthentication,
        );
      });

      test('is never WIA on the default profile', () async {
        final context = await resolve(defaultOne);
        final decisions = context.decide(
          parameters(authorizationServer: asksForAttestation),
        );

        expect(decisions.walletAttestation, isFalse);
        expect(
          context.clientAuthentication(decisions),
          ClientAuthentication.clientId,
        );
      });

      test('is WIA when the profile configures it', () async {
        final context = await resolve(eudiw);

        expect(
          context.clientAuthentication(context.decide(parameters())),
          ClientAuthentication.wia,
        );
      });
    });

    group('PAR', () {
      test('follows the profile flag', () async {
        expect((await resolve(custom)).decide(parameters()).par, isFalse);
        expect(
          (await resolve(
            withOidc4vc(
              custom,
              (p) => p.copyWith(pushAuthorizationRequest: true),
            ),
          )).decide(parameters()).par,
          isTrue,
        );
      });

      test('is used when the authorization server requires it', () async {
        final context = await resolve(custom);

        expect(
          context
              .decide(
                parameters(
                  authorizationServer: const {
                    'require_pushed_authorization_requests': true,
                  },
                ),
              )
              .par,
          isTrue,
        );
      });

      test('is always used under haip', () async {
        final context = await resolve(eudiw);

        expect(context.decide(parameters()).par, isTrue);
      });
    });
  });

  group('checkIssuance', () {
    test('accepts CORE 3/4 under core', () async {
      final context = await resolve(defaultOne);

      expect(
        context.checkIssuance(parameters(authorizationServer: parNotRequired)),
        const PolicyYes(),
      );
    });

    test('warns on CORE 3/4 under haip lenient', () async {
      final context = await resolve(eudiw);
      final verdict = context.checkIssuance(
        parameters(authorizationServer: parNotRequired),
      );

      expect(verdict, isA<PolicyWarning>());
      expect(
        verdict.violations.map((violation) => violation.code),
        contains('HAIP_PAR_REQUIRED_BY_AS'),
      );
    });

    test('reports a policy file that failed to load', () async {
      final context = await ProfilePolicyContext.resolve(
        custom,
        loader: ProfilePolicyLoader(readFile: (_) async => 'not json'),
      );

      expect(
        context.checkIssuance(parameters()).violations.single.code,
        'POLICY_UNAVAILABLE',
      );
    });
  });

  group('enforce', () {
    late Directory directory;

    setUp(() {
      directory = Directory.systemTemp.createTempSync('policy_trace_test');
      ProtocolTrace.current = ProtocolTrace(
        directory: directory,
        appName: 'test.app',
      );
    });

    tearDown(() {
      ProtocolTrace.current = null;
      directory.deleteSync(recursive: true);
    });

    String traced() => ProtocolTrace.current!.file.readAsStringSync();

    const violation = PolicyViolation(
      code: 'HAIP_PAR_REQUIRED_BY_AS',
      rule: 'par',
      sources: ['HAIP-4'],
    );

    test('lets a Yes through silently', () async {
      (await resolve(custom)).enforce(const PolicyYes());

      expect(traced(), isNot(contains('Policy')));
    });

    test('traces a Warning and goes on', () async {
      (await resolve(eudiw)).enforce(const PolicyWarning([violation]));

      expect(traced(), contains('Policy warning'));
      expect(traced(), contains('HAIP_PAR_REQUIRED_BY_AS'));
      expect(traced(), contains('#section-4'));
    });

    test('stops the flow on a No with a policy_violation error', () async {
      final context = await resolve(eudiw);

      expect(
        () => context.enforce(const PolicyNo([violation])),
        throwsA(
          isA<ResponseMessage>().having((message) => message.data, 'data', {
            'error': 'policy_violation',
            'error_description': 'HAIP_PAR_REQUIRED_BY_AS',
          }),
        ),
      );
      expect(traced(), contains('Policy violation'));
    });

    test('a strict policy stops CORE 3/4', () async {
      final context = ProfilePolicyContext(
        policy: await shippedPolicies.load('haip'),
        mode: PolicyMode.strict,
        profile: eudiw
            .profileSetting
            .selfSovereignIdentityOptions
            .customOidc4vcProfile,
      );

      expect(
        () => context.enforce(
          context.checkIssuance(
            parameters(authorizationServer: parNotRequired),
          ),
        ),
        throwsA(isA<ResponseMessage>()),
      );
    });
  });

  test('policy_violation maps to its message', () {
    expect(
      getErrorResponseString('policy_violation'),
      ResponseString.RESPONSE_STRING_policyViolation,
    );
  });

  group('Oidc4VCIState', () {
    test('carries the decisions across the browser round trip', () {
      final state = Oidc4VCIState(
        codeVerifier: 'verifier',
        challenge: 'challenge',
        selectedCredentials: const [],
        issuer: 'https://issuer.example',
        isEBSI: false,
        publicKeyForDPo: '{}',
        oidc4vciDraft: '1.0',
        tokenEndpoint: 'https://as.example/token',
        dpop: true,
        clientAuthentication: ClientAuthentication.wia,
      );

      final restored = Oidc4VCIState.fromJson(state.toJson());

      expect(restored.dpop, isTrue);
      expect(restored.clientAuthentication, ClientAuthentication.wia);
    });

    test('reads a state saved before the policies', () {
      final restored = Oidc4VCIState.fromJson(const {
        'codeVerifier': 'verifier',
        'challenge': 'challenge',
        'selectedCredentials': <dynamic>[],
        'issuer': 'https://issuer.example',
        'isEBSI': false,
        'publicKeyForDPo': '{}',
        'oidc4vciDraft': '1.0',
        'tokenEndpoint': 'https://as.example/token',
      });

      expect(restored.dpop, isFalse);
      expect(restored.clientAuthentication, isNull);
    });
  });
}
