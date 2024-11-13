import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:did_kit/did_kit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:uuid/uuid.dart';

Future<Uri?> getAuthorizationUriForIssuer({
  required String scannedResponse,
  required OIDC4VC oidc4vc,
  required bool isEBSI,
  required DIDKitProvider didKitProvider,
  required List<dynamic> selectedCredentials,
  required String issuer,
  required dynamic credentialOfferJson,
  required bool scope,
  required String? clientId,
  required String? clientSecret,
  required ClientAuthentication clientAuthentication,
  required OIDC4VCIDraftType oidc4vciDraftType,
  required VCFormatType vcFormatType,
  required bool secureAuthorizedFlow,
  required DioClient client,
  required ProfileType profileType,
  required String walletIssuer,
  required bool useOAuthAuthorizationServerLink,
  required ProfileCubit profileCubit,
  required QRCodeScanCubit qrCodeScanCubit,
  String? oAuthClientAttestation,
  String? oAuthClientAttestationPop,
}) async {
  /// this is first phase flow for authorization_code

  String? issuerState;

  final grants = credentialOfferJson['grants'];

  if (grants != null && grants is Map) {
    final dynamic authorizedCode = grants['authorization_code'];
    if (authorizedCode != null &&
        authorizedCode is Map &&
        authorizedCode.containsKey('issuer_state')) {
      issuerState = authorizedCode['issuer_state'] as String;
    }
  }

  final String nonce = const Uuid().v4();
  final PkcePair pkcePair = PkcePair.generate();

  final data = {
    'codeVerifier': pkcePair.codeVerifier,
    'credentials': selectedCredentials,
    'issuer': issuer,
    'isEBSI': isEBSI,
  };

  switch (clientAuthentication) {
    case ClientAuthentication.none:
      break;
    case ClientAuthentication.clientSecretBasic:
      data['authorization'] =
          base64UrlEncode(utf8.encode('$clientId:$clientSecret'));
    case ClientAuthentication.clientSecretPost:
      data['client_id'] = clientId!;
      data['client_secret'] = clientSecret!;
    case ClientAuthentication.clientId:
      data['client_id'] = clientId!;
    case ClientAuthentication.clientSecretJwt:
      data['client_id'] = clientId!;
      data['oAuthClientAttestation'] = oAuthClientAttestation!;
      data['oAuthClientAttestationPop'] = oAuthClientAttestationPop!;
  }

  final jwt = JWT(data);

  await dotenv.load();
  final String authorizationUriSecretKey =
      dotenv.get('AUTHORIZATION_URI_SECRET_KEY');

  final jwtToken = jwt.sign(SecretKey(authorizationUriSecretKey));

  late Uri authorizationUri;

  final (
    authorizationEndpoint,
    authorizationRequestParemeters,
    openIdConfigurationData
  ) = await oidc4vc.getAuthorizationData(
    selectedCredentials: selectedCredentials,
    clientId: clientId,
    clientSecret: clientSecret,
    redirectUri: Parameters.oidc4vcUniversalLink,
    issuer: issuer,
    issuerState: issuerState,
    nonce: nonce,
    pkcePair: pkcePair,
    state: jwtToken,
    authorizationEndPoint: Parameters.authorizeEndPoint,
    scope: scope,
    clientAuthentication: clientAuthentication,
    oidc4vciDraftType: oidc4vciDraftType,
    vcFormatType: vcFormatType,
    oAuthClientAttestation: oAuthClientAttestation,
    oAuthClientAttestationPop: oAuthClientAttestationPop,
    secureAuthorizedFlow: secureAuthorizedFlow,
    credentialOfferJson: credentialOfferJson,
    dio: client.dio,
    isEBSIProfile:
        profileType == ProfileType.ebsiV3 || profileType == ProfileType.ebsiV4,
    walletIssuer: walletIssuer,
    useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
  );

  final openIdConfiguration =
      OpenIdConfiguration.fromJson(openIdConfigurationData);

  final requirePushedAuthorizationRequests =
      openIdConfiguration.requirePushedAuthorizationRequests;

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
    final headers = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'OAuth-Client-Attestation': oAuthClientAttestation,
      'OAuth-Client-Attestation-PoP': oAuthClientAttestationPop,
    };

    final parUrl = openIdConfiguration.pushedAuthorizationRequestEndpoint ??
        '$authorizationEndpoint/par';

    /// error we shuld get it from
    final response = await client.post(
      parUrl,
      headers: headers,
      data: authorizationRequestParemeters,
    );

    if (profileCubit.state.model.isDeveloperMode) {
      final formattedData = '''
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

    final url = Uri.parse(authorizationEndpoint);
    authorizationUri = Uri.https(url.authority, url.path, parameters);
  } else {
    final url = Uri.parse(authorizationEndpoint);
    authorizationUri =
        Uri.https(url.authority, url.path, authorizationRequestParemeters);
  }

  return authorizationUri;
}
