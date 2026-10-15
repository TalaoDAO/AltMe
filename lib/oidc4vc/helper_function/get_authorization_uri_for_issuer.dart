import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/helper_function/authorization_state.dart';
import 'package:altme/oidc4vc/model/oidc4vci_state.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:uuid/uuid.dart';

Future<Uri?> getAuthorizationUriForIssuer({
  required Oidc4vcParameters oidc4vcParameters,
  required DIDKitProvider didKitProvider,
  required List<dynamic> selectedCredentials,
  required bool scope,
  required String? clientId,
  required String? clientSecret,
  required ClientAuthentication clientAuthentication,
  required List<VCFormatType> formatsSupported,
  required bool secureAuthorizedFlow,
  required DioClient client,
  required ProfileType profileType,
  required String walletIssuer,
  required bool useOAuthAuthorizationServerLink,
  required ProfileCubit profileCubit,
  required QRCodeScanCubit qrCodeScanCubit,
  required String publicKeyForDPop,
  String? oAuthClientAttestation,
  String? oAuthClientAttestationPop,
}) async {
  /// this is first phase flow for authorization_code

  final String nonce = const Uuid().v4();
  final PkcePair pkcePair = PkcePair.generate();

  final initialOidc4VCIState = Oidc4VCIState(
    codeVerifier: pkcePair.codeVerifier,
    challenge: pkcePair.codeChallenge,
    selectedCredentials: selectedCredentials,
    issuer: oidc4vcParameters.issuer,
    isEBSI: oidc4vcParameters.oidc4vcType == OIDC4VCType.EBSI,
    publicKeyForDPo: publicKeyForDPop,
    oidc4vciDraft: oidc4vcParameters.oidc4vciDraftType.numbering,
    tokenEndpoint: oidc4vcParameters.tokenEndpoint,
    authorizationServer:
        oidc4vcParameters.authorizationServerOpenIdConfiguration.issuer,
  );
  late Oidc4VCIState oidc4VCIState;
  switch (clientAuthentication) {
    case ClientAuthentication.none:
      oidc4VCIState = initialOidc4VCIState;
    case ClientAuthentication.clientSecretBasic:
      oidc4VCIState = initialOidc4VCIState.copyWith(
        authorization: base64UrlEncode(utf8.encode('$clientId:$clientSecret')),
      );
    case ClientAuthentication.clientSecretPost:
      oidc4VCIState = initialOidc4VCIState.copyWith(
        clientId: clientId,
        clientSecret: clientSecret,
      );
    case ClientAuthentication.clientId:
      oidc4VCIState = initialOidc4VCIState.copyWith(clientId: clientId);
    case ClientAuthentication.clientSecretJwt:
      oidc4VCIState = initialOidc4VCIState.copyWith(
        clientId: clientId,
        oAuthClientAttestationPop: oAuthClientAttestationPop,
        oAuthClientAttestation: oAuthClientAttestation,
      );

    /// Wallet Provider Protocol §8: the same three values as
    /// `clientSecretJwt` — the `client_id` is the Wallet Instance
    /// Attestation's `sub` (§3) and the attestation travels in the
    /// `OAuth-Client-Attestation` header of the Pushed Authorization Request.
    case ClientAuthentication.wia:
      oidc4VCIState = initialOidc4VCIState.copyWith(
        clientId: clientId,
        oAuthClientAttestationPop: oAuthClientAttestationPop,
        oAuthClientAttestation: oAuthClientAttestation,
      );
  }

  // save the state and give its id, encrypted, as the OAuth state
  profileCubit.addOidc4VCI(oidc4VCIState);

  await dotenv.load();
  final String authorizationUriSecretKey = dotenv.get(
    'AUTHORIZATION_URI_SECRET_KEY',
  );

  final authorizationState = AuthorizationState.encrypt(
    pkcePair.codeChallenge,
    secret: authorizationUriSecretKey,
  );

  late Uri authorizationUri;

  final authorizationRequestParemeters = profileCubit.oidc4vc
      .getAuthorizationRequestParemeters(
        selectedCredentials: selectedCredentials,
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUri: Parameters.redirectUri,
        nonce: nonce,
        pkcePair: pkcePair,
        state: authorizationState,
        scope: scope,
        clientAuthentication: clientAuthentication,
        formatsSuported: formatsSupported,
        secureAuthorizedFlow: secureAuthorizedFlow,
        isEBSIProfile: oidc4vcParameters.oidc4vcType == OIDC4VCType.EBSI,
        walletIssuer: walletIssuer,
        oidc4vcParameters: oidc4vcParameters,
      );

  final requirePushedAuthorizationRequests = oidc4vcParameters
      .authorizationServerOpenIdConfiguration
      .requirePushedAuthorizationRequests;

  final isSecure = requirePushedAuthorizationRequests || secureAuthorizedFlow;

  if (profileCubit.state.model.isDeveloperMode) {
    final value = await qrCodeScanCubit.showDataBeforeSending(
      title: isSecure ? 'PUSH AUTHORIZATION REQUEST' : 'AUTHORIZATION REQUEST',
      data: authorizationRequestParemeters,
    );

    if (value) {
      qrCodeScanCubit.completer = null;
    } else {
      qrCodeScanCubit.completer = null;
      qrCodeScanCubit.resetNonceAndAccessTokenAndAuthorizationDetails();
      qrCodeScanCubit.goBack();
      return null;
    }
  }

  if (isSecure) {
    String? dPop;

    final customOidc4vcProfile = profileCubit
        .state
        .model
        .profileSetting
        .selfSovereignIdentityOptions
        .customOidc4vcProfile;

    // RFC 9126 §5: `pushed_authorization_request_endpoint` is authorization
    // server metadata, so it is read there first. The credential issuer's own
    // metadata only has it when the issuer is its own authorization server.
    // TODO(hawkbee): return an error message rather than guessing when
    // neither publishes it.
    final parUrl =
        oidc4vcParameters
            .authorizationServerOpenIdConfiguration
            .pushedAuthorizationRequestEndpoint ??
        oidc4vcParameters
            .issuerOpenIdConfiguration
            .pushedAuthorizationRequestEndpoint ??
        '${oidc4vcParameters.authorizationEndpoint}/par';

    if (customOidc4vcProfile.dpopSupport) {
      dPop = await getDPopJwt(
        url: parUrl,
        // accessToken: savedAccessToken,
        // nonce: savedNonce,
        publicKey: publicKeyForDPop,
      );
    }

    final headers = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'OAuth-Client-Attestation': oAuthClientAttestation,
      'OAuth-Client-Attestation-PoP': oAuthClientAttestationPop,
    };

    if (dPop != null) {
      headers['DPoP'] = dPop;
    }

    /// error we shuld get it from
    // Retried with fresh proofs when the authorization server asks for a DPoP
    // nonce (RFC 9449 §8) or for a fresh attestation challenge
    // (`use_attestation_challenge`), see `answerAuthorizationServerChallenges`.
    final dynamic response = await answerAuthorizationServerChallenges<dynamic>(
      answersDpopNonce: dPop != null,
      answersAttestationChallenge:
          clientAuthentication == ClientAuthentication.wia,
      errorResponseOf: (error) => error is NetworkException
          ? (data: error.data, headers: error.headers)
          : null,
      send: (answers) async {
        if (answers != null) {
          if (clientAuthentication == ClientAuthentication.wia) {
            final (
              _,
              _,
              _,
              freshAttestation,
              freshAttestationPop,
            ) = await getClientDetails(
              profileCubit: profileCubit,
              isEBSI: oidc4vcParameters.oidc4vcType == OIDC4VCType.EBSI,
              issuer: oidc4vcParameters.issuer,
              authorizationServer: oidc4vcParameters
                  .authorizationServerOpenIdConfiguration
                  .issuer,
              attestationChallengeEndpoint:
                  oidc4vcParameters
                          .authorizationServerOpenIdConfiguration
                          .rawConfiguration?['challenge_endpoint']
                      as String?,
              attestationChallenge: answers.attestationChallenge,
              client: client,
              issuerMetadata:
                  oidc4vcParameters.issuerOpenIdConfiguration.rawConfiguration,
              clientAuthentication: clientAuthentication,
            );
            if (freshAttestation != null && freshAttestationPop != null) {
              headers['OAuth-Client-Attestation'] = freshAttestation;
              headers['OAuth-Client-Attestation-PoP'] = freshAttestationPop;
            }
          }
          if (dPop != null) {
            headers['DPoP'] = await getDPopJwt(
              url: parUrl,
              publicKey: publicKeyForDPop,
              dpopNonce: answers.dpopNonce,
            );
          }
        }
        return client.post(
          parUrl,
          headers: headers,
          data: authorizationRequestParemeters,
        );
      },
    );

    if (profileCubit.state.model.isDeveloperMode) {
      final formattedData =
          '''
<b>REQUEST RESPONSE :</b>
${const JsonEncoder.withIndent('  ').convert(response)}\n
''';
      final value = await qrCodeScanCubit.showDataAfterReceiving(formattedData);

      if (value) {
        qrCodeScanCubit.completer = null;
      } else {
        qrCodeScanCubit.completer = null;
        qrCodeScanCubit.resetNonceAndAccessTokenAndAuthorizationDetails();
        qrCodeScanCubit.goBack();
        return null;
      }
    }

    final requestUri = response['request_uri'];

    if (requestUri == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'The request_uri should be provided.',
        },
      );
    }

    final parameters = {'client_id': clientId, 'request_uri': requestUri};

    final uri = Uri.parse(oidc4vcParameters.authorizationEndpoint);
    authorizationUri = Uri.https(uri.authority, uri.path, parameters);
  } else {
    final uri = Uri.parse(oidc4vcParameters.authorizationEndpoint);
    authorizationUri = Uri.https(
      uri.authority,
      uri.path,
      authorizationRequestParemeters,
    );
  }

  return authorizationUri;
}
