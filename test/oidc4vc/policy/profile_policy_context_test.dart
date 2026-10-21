import 'dart:convert';
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
  String? preAuthorizedCode,
}) => Oidc4vcParameters(
  oidc4vciDraftType: OIDC4VCIDraftType.final1,
  useOAuthAuthorizationServerLink: false,
  initialUri: Uri(),
  userPinRequired: false,
  issuerState: null,
  preAuthorizedCode: preAuthorizedCode,
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

  List<String> codesOf(PolicyVerdict verdict) =>
      verdict.violations.map((violation) => violation.code).toList();

  Future<ProfilePolicyContext> resolve(ProfileModel model) =>
      ProfilePolicyContext.resolve(model, loader: shippedPolicies);

  /// A context under the policy [id], whatever this app's
  /// `Parameters.policyFor` maps [model]'s profile to, so the cases below hold
  /// in every app that shares this adapter.
  Future<ProfilePolicyContext> under(
    String id,
    ProfileModel model, {
    PolicyMode mode = PolicyMode.lenient,
    bool hasWalletAttestation = true,
  }) async => ProfilePolicyContext(
    policy: await shippedPolicies.load(id),
    mode: mode,
    profile:
        model.profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile,
    hasWalletAttestation: hasWalletAttestation,
  );

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
      for (final type in ProfileType.values) {
        final (:id, :mode, :hasWalletAttestation) = Parameters.policyFor(type);
        final context = await resolve(custom.copyWith(profileType: type));

        expect(context.policy.id, id, reason: type.name);
        expect(context.mode, mode, reason: type.name);
        expect(
          context.hasWalletAttestation,
          hasWalletAttestation,
          reason: type.name,
        );
      }
    });

    test("loads every mapped policy from this app's asset bundle", () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      for (final type in ProfileType.values) {
        final context = await ProfilePolicyContext.resolve(
          custom.copyWith(profileType: type),
        );

        expect(context.loadError, isNull, reason: type.name);
        expect(
          context.policy.id,
          Parameters.policyFor(type).id,
          reason: type.name,
        );
      }
    });

    test('keeps the profile flags when the policy file fails', () async {
      Future<ProfilePolicyContext> failing(ProfileModel model) =>
          ProfilePolicyContext.resolve(
            model,
            loader: ProfilePolicyLoader(readFile: (_) async => 'not json'),
          );
      final flagsOff = await failing(custom);
      final flagsOn = await failing(
        withOidc4vc(
          custom,
          (p) => p.copyWith(dpopSupport: true, pushAuthorizationRequest: true),
        ),
      );

      expect(flagsOff.loadError, isA<PolicyLoadException>());
      expect(
        flagsOff.decide(parameters(authorizationServer: advertisesDpop)).dpop,
        isFalse,
      );
      final decisions = flagsOn.decide(parameters());
      expect(decisions.dpop, isTrue);
      expect(decisions.par, isTrue);
    });
  });

  group('decide', () {
    group('DPoP (#3515)', () {
      test('is used when the authorization server advertises it', () async {
        final context = await under(
          'core',
          defaultOne,
          hasWalletAttestation: false,
        );

        expect(
          context.decide(parameters(authorizationServer: advertisesDpop)).dpop,
          isTrue,
        );
      });

      test('is not used when the server does not advertise it', () async {
        final context = await under(
          'core',
          defaultOne,
          hasWalletAttestation: false,
        );

        expect(context.decide(parameters()).dpop, isFalse);
      });

      test('is always used when the profile switches it on', () async {
        final context = await under(
          'core',
          withOidc4vc(custom, (p) => p.copyWith(dpopSupport: true)),
        );

        expect(context.decide(parameters()).dpop, isTrue);
      });
    });

    group('client authentication (#3538)', () {
      test('is WIA when the authorization server asks for it', () async {
        final context = await under('core', custom);
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
        final context = await under('core', custom);

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
        final context = await under(
          'core',
          defaultOne,
          hasWalletAttestation: false,
        );
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
        final context = await under('haip', eudiw);

        expect(
          context.clientAuthentication(context.decide(parameters())),
          ClientAuthentication.wia,
        );
      });
    });

    group('PAR', () {
      test('follows the profile flag', () async {
        expect((await under('core', custom)).decide(parameters()).par, isFalse);
        expect(
          (await under(
            'core',
            withOidc4vc(
              custom,
              (p) => p.copyWith(pushAuthorizationRequest: true),
            ),
          )).decide(parameters()).par,
          isTrue,
        );
      });

      test('is used when the authorization server requires it', () async {
        final context = await under('core', custom);

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
        final context = await under('haip', eudiw);

        expect(context.decide(parameters()).par, isTrue);
      });
    });
  });

  group('checkIssuance', () {
    test('accepts CORE 3/4 under core', () async {
      final context = await under(
        'core',
        defaultOne,
        hasWalletAttestation: false,
      );

      expect(
        context.checkIssuance(parameters(authorizationServer: parNotRequired)),
        const PolicyYes(),
      );
    });

    test('warns on CORE 3/4 under haip lenient', () async {
      final context = await under('haip', eudiw);
      final verdict = context.checkIssuance(
        parameters(authorizationServer: parNotRequired),
      );

      expect(verdict, isA<PolicyWarning>());
      expect(
        verdict.violations.map((violation) => violation.code),
        contains('HAIP_PAR_REQUIRED_BY_AS'),
      );
    });

    test('holds a pre-authorized offer to the rules of its grant', () async {
      final haip = await under('haip', eudiw, mode: PolicyMode.strict);
      final eudiWallet = await under(
        'eudi_wallet',
        eudiw,
        mode: PolicyMode.strict,
      );

      const signedIssuer = {'signed_metadata': 'a.b.c'};

      // No PAR, PKCE or iss: the authorization endpoint is not used.
      expect(
        haip.checkIssuance(
          parameters(preAuthorizedCode: 'code', issuer: signedIssuer),
        ),
        const PolicyYes(),
      );
      expect(
        codesOf(
          eudiWallet.checkIssuance(
            parameters(preAuthorizedCode: 'code', issuer: signedIssuer),
          ),
        ),
        ['EUDI_WALLET_WALLET_ATTESTATION_NOT_SUPPORTED_BY_AS'],
      );
      // An anonymous token request carries no client authentication.
      expect(
        eudiWallet.checkIssuance(
          parameters(
            preAuthorizedCode: 'code',
            issuer: signedIssuer,
            authorizationServer: const {
              'pre-authorized_grant_anonymous_access_supported': true,
            },
          ),
        ),
        const PolicyYes(),
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

    test('a policy file that failed to load stops a strict flow and warns a '
        'lenient one', () {
      ProfilePolicyContext unavailable(PolicyMode mode) => ProfilePolicyContext(
        policy: const ProfilePolicy(id: 'eudi_wallet'),
        mode: mode,
        profile: eudiw
            .profileSetting
            .selfSovereignIdentityOptions
            .customOidc4vcProfile,
        loadError: const PolicyLoadException('not json'),
      );
      final strict = unavailable(PolicyMode.strict);
      final lenient = unavailable(PolicyMode.lenient);

      expect(strict.checkIssuance(parameters()), isA<PolicyNo>());
      expect(
        () => strict.enforce(strict.checkIssuance(parameters())),
        throwsA(isA<ResponseMessage>()),
      );
      expect(lenient.checkIssuance(parameters()), isA<PolicyWarning>());
      expect(
        strict.checkPresentation(Uri.parse('openid4vp://?client_id=x')),
        isA<PolicyNo>(),
      );
    });
  });

  group('checkPresentation', () {
    String encode(Map<String, dynamic> part) =>
        base64Url.encode(utf8.encode(jsonEncode(part)));
    String jwt(Map<String, dynamic> header, Map<String, dynamic> payload) =>
        '${encode(header)}.${encode(payload)}.signature';

    const haipRequest = {
      'client_id': 'x509_hash:abc',
      'response_mode': 'direct_post.jwt',
      'response_type': 'vp_token',
    };
    final signedHaipRequest = jwt(const {'alg': 'ES256'}, haipRequest);
    final byReference = Uri.parse(
      'openid4vp://?client_id=x509_hash:abc&request_uri=https://verifier.example/r',
    );
    final byValue = Uri.parse(
      'openid4vp://?client_id=redirect_uri:https://verifier.example'
      '&response_mode=direct_post&response_type=vp_token',
    );

    List<String> codes(PolicyVerdict verdict) =>
        verdict.violations.map((violation) => violation.code).toList();

    test('accepts any request under core', () async {
      final context = await under(
        'core',
        defaultOne,
        hasWalletAttestation: false,
      );

      expect(context.checkPresentation(byValue), const PolicyYes());
    });

    test(
      'accepts a signed x509_hash direct_post.jwt request under haip',
      () async {
        final context = await under('haip', eudiw);

        expect(
          context.checkPresentation(
            byReference,
            requestObject: signedHaipRequest,
          ),
          const PolicyYes(),
        );
      },
    );

    test(
      'warns on a request that misses the haip rules under lenient',
      () async {
        final context = await under('haip', eudiw);
        final verdict = context.checkPresentation(byValue);

        expect(verdict, isA<PolicyWarning>());
        expect(codes(verdict), [
          'HAIP_CLIENT_ID_PREFIX_NOT_ALLOWED',
          'HAIP_SIGNED_REQUEST_OBJECT_MISSING',
          'HAIP_RESPONSE_ENCRYPTION_MISSING',
        ]);
      },
    );

    test('reads the Request Object rather than the query parameters', () async {
      final context = await under('haip', eudiw);
      final verdict = context.checkPresentation(
        byReference,
        requestObject: jwt(const {'alg': 'none'}, haipRequest),
      );

      expect(codes(verdict), ['HAIP_SIGNED_REQUEST_OBJECT_MISSING']);
    });

    test('falls back to the query parameters when the Request Object is not '
        'a JWT', () async {
      final context = await under('haip', eudiw);

      expect(
        codes(context.checkPresentation(byValue, requestObject: '')),
        codes(context.checkPresentation(byValue)),
      );
      expect(
        codes(context.checkPresentation(byValue, requestObject: 'a.b.c')),
        codes(context.checkPresentation(byValue)),
      );
    });

    test(
      'a strict policy stops a request that misses the haip rules',
      () async {
        final context = await under('haip', eudiw, mode: PolicyMode.strict);
        final verdict = context.checkPresentation(byValue);

        expect(verdict, isA<PolicyNo>());
        expect(() => context.enforce(verdict), throwsA(isA<ResponseMessage>()));
      },
    );

    test('requires verifier_info under eudi_wallet only', () async {
      final context = await under(
        'eudi_wallet',
        eudiw,
        mode: PolicyMode.strict,
      );

      expect(
        codes(
          context.checkPresentation(
            byReference,
            requestObject: signedHaipRequest,
          ),
        ),
        ['EUDI_WALLET_VERIFIER_INFO_MISSING'],
      );
    });

    test('reports a policy file that failed to load', () async {
      final context = await ProfilePolicyContext.resolve(
        custom,
        loader: ProfilePolicyLoader(readFile: (_) async => 'not json'),
      );

      expect(codes(context.checkPresentation(byValue)), ['POLICY_UNAVAILABLE']);
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
      (await under('core', custom)).enforce(const PolicyYes());

      expect(traced(), isNot(contains('Policy')));
    });

    test('traces a Warning and goes on', () async {
      (await under('haip', eudiw)).enforce(const PolicyWarning([violation]));

      expect(traced(), contains('Policy warning'));
      expect(traced(), contains('HAIP_PAR_REQUIRED_BY_AS'));
      expect(traced(), contains('#section-4'));
    });

    test('stops the flow on a No with a policy_violation error', () async {
      final context = await under('haip', eudiw);

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
      final context = await under('haip', eudiw, mode: PolicyMode.strict);

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
