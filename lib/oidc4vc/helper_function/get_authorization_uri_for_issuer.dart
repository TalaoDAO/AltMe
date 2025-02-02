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

  final data = {
    'credentials': selectedCredentials,
    'issuer': oidc4vcParameters.issuer,
    'isEBSI': oidc4vcParameters.oidc4vcType == OIDC4VCType.EBSI,
    'publicKeyForDPop': publicKeyForDPop,
    'oidc4vciDraft': oidc4vcParameters.oidc4vciDraftType.numbering,
    'tokenEndpoint': oidc4vcParameters.tokenEndpoint,
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

  final authorizationRequestParemeters =
      OIDC4VC().getAuthorizationRequestParemeters(
    selectedCredentials: selectedCredentials,
    clientId: clientId,
    clientSecret: clientSecret,
    redirectUri: Parameters.oidc4vcUniversalLink,
    nonce: nonce,
    pkcePair: pkcePair,
    state: jwtToken,
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

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    // TODO(hawkbee): return an error message if
    // openIdConfiguration.pushedAuthorizationRequestEndpoint is null
    final parUrl = oidc4vcParameters
            .issuerOpenIdConfiguration.pushedAuthorizationRequestEndpoint ??
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

    final uri = Uri.parse(oidc4vcParameters.authorizationEndpoint);
    authorizationUri = Uri.https(uri.authority, uri.path, parameters);
  } else {
    final uri = Uri.parse(oidc4vcParameters.authorizationEndpoint);
    authorizationUri =
        Uri.https(uri.authority, uri.path, authorizationRequestParemeters);
  }

  return authorizationUri;
}
