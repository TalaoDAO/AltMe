import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:protocol_trace/protocol_trace.dart';

/// The profile policy that governs a flow, together with the choices the
/// profile configuration makes within it.
///
/// It is resolved once, when a flow starts, so switching profile in the middle
/// of a flow cannot change the rules of that flow. The policy id and mode come
/// from [Parameters.policyFor]; the choices come from the profile's
/// [CustomOidc4VcProfile].
class ProfilePolicyContext {
  ProfilePolicyContext({
    required this.policy,
    required this.mode,
    required this.profile,
    this.hasWalletAttestation = true,
    this.loadError,
  });

  /// The policy of [model]'s profile type, loaded by [loader].
  ///
  /// A policy file that fails to load gives a context with no rule, so the
  /// decisions follow the profile flags alone, and the checks report the
  /// failure.
  static Future<ProfilePolicyContext> resolve(
    ProfileModel model, {
    ProfilePolicyLoader? loader,
  }) async {
    final (:id, :mode, :hasWalletAttestation) = Parameters.policyFor(
      model.profileType,
    );
    final profile =
        model.profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile;
    try {
      return ProfilePolicyContext(
        policy: await (loader ?? ProfilePolicyLoader()).load(id),
        mode: mode,
        profile: profile,
        hasWalletAttestation: hasWalletAttestation,
      );
    } on PolicyLoadException catch (e) {
      return ProfilePolicyContext(
        policy: ProfilePolicy(id: id),
        mode: mode,
        profile: profile,
        hasWalletAttestation: hasWalletAttestation,
        loadError: e,
      );
    }
  }

  final ProfilePolicy policy;
  final PolicyMode mode;
  final CustomOidc4VcProfile profile;

  /// False for a profile that has no Wallet Instance Attestation to present.
  final bool hasWalletAttestation;

  /// Why the policy file could not be loaded, null when it was.
  final PolicyLoadException? loadError;

  IssuancePolicy get _issuance => IssuancePolicy(policy, mode: mode);

  /// A profile flag that is on switches the feature on. A PAR flag that is
  /// off switches PAR off, unless the server requires it, as before the
  /// policies. A DPoP or client authentication setting that is off leaves the
  /// decision to the server (AltMe #3515, #3538).
  IssuanceChoices get _choices => IssuanceChoices(
    par: profile.pushAuthorizationRequest,
    dpop: profile.dpopSupport ? true : null,
    walletAttestation: switch ((
      hasWalletAttestation,
      profile.clientAuthentication,
    )) {
      (false, _) => false,
      (_, ClientAuthentication.wia) => true,
      _ => null,
    },
  );

  /// What the wallet does in the issuance flow of [parameters].
  IssuanceDecisions decide(Oidc4vcParameters parameters) => _issuance.decide(
    authorizationServer: parameters.authorizationServerOpenIdConfiguration,
    issuer: parameters.issuerOpenIdConfiguration,
    choices: _choices,
  );

  /// The client authentication that goes with [decisions]: Wallet Instance
  /// Attestation when they use it, the profile's own otherwise.
  ClientAuthentication clientAuthentication(IssuanceDecisions decisions) =>
      decisions.walletAttestation
      ? ClientAuthentication.wia
      : profile.clientAuthentication;

  /// Checks the authorization server and credential issuer metadata of
  /// [parameters] against the policy, with the authorization server rules
  /// that govern the grant of [parameters].
  PolicyVerdict checkIssuance(Oidc4vcParameters parameters) =>
      PolicyVerdict.of([
        if (loadError != null) _unavailable,
        ..._issuance
            .checkAuthorizationServer(
              parameters.authorizationServerOpenIdConfiguration,
              grant: _grantOf(parameters),
            )
            .violations,
        ..._issuance
            .checkIssuerMetadata(parameters.issuerOpenIdConfiguration)
            .violations,
      ], mode: mode);

  static IssuanceGrant _grantOf(Oidc4vcParameters parameters) =>
      parameters.preAuthorizedCode == null
      ? IssuanceGrant.authorizationCode
      : parameters
            .authorizationServerOpenIdConfiguration
            .preAuthorizedGrantAnonymousAccessSupported
      ? IssuanceGrant.anonymousPreAuthorizedCode
      : IssuanceGrant.preAuthorizedCode;

  /// Checks the presentation request of [uri] against the policy.
  ///
  /// [requestObject] is the request's Request Object, passed by value or
  /// fetched by reference. When there is none, or it is not a JWT, the query
  /// parameters of [uri] are the request.
  PolicyVerdict checkPresentation(Uri uri, {Object? requestObject}) {
    final (request, header) =
        _decodeRequestObject(requestObject) ?? (uri.queryParameters, null);
    return PolicyVerdict.of([
      if (loadError != null) _unavailable,
      ...PresentationPolicy(
        policy,
        mode: mode,
      ).checkRequest(request, requestObjectHeader: header).violations,
    ], mode: mode);
  }

  static (Map<String, dynamic>, Map<String, dynamic>)? _decodeRequestObject(
    Object? requestObject,
  ) {
    if (requestObject is! String || requestObject.split('.').length != 3) {
      return null;
    }
    try {
      final jwtDecode = JWTDecode();
      return (
        jwtDecode.parseJwt(requestObject),
        jwtDecode.parseJwtHeader(requestObject),
      );
    } on Exception {
      return null;
    }
  }

  static const _unavailable = PolicyViolation(
    code: 'POLICY_UNAVAILABLE',
    rule: 'policy',
    sources: [],
  );

  /// Acts on [verdict]: a [PolicyNo] stops the flow with a
  /// `policy_violation` error; a [PolicyWarning] goes to the protocol trace
  /// and the log, and the flow goes on.
  void enforce(PolicyVerdict verdict) {
    switch (verdict) {
      case PolicyYes():
        return;
      case PolicyWarning(:final violations):
        ProtocolTrace.current?.step('Policy warning', _describe(violations));
        getLogger(
          'ProfilePolicyContext',
        ).w('Policy warning: ${_codes(violations)}');
      case PolicyNo(:final violations):
        ProtocolTrace.current?.step('Policy violation', _describe(violations));
        throw ResponseMessage(
          data: {
            'error': 'policy_violation',
            'error_description': _codes(violations),
          },
        );
    }
  }

  static String _codes(List<PolicyViolation> violations) =>
      violations.map((violation) => violation.code).join(', ');

  Map<String, dynamic> _describe(List<PolicyViolation> violations) => {
    'policy': policy.id,
    'mode': mode.name,
    'violations': [
      for (final violation in violations)
        {
          'code': violation.code,
          'rule': violation.rule,
          'sources': [
            for (final source in violation.sources)
              policy.sources[source] ?? source,
          ],
        },
    ],
  };
}
