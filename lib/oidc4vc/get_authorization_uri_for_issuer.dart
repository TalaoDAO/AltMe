import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:did_kit/did_kit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:uuid/uuid.dart';

Future<void> getAuthorizationUriForIssuer({
  required String scannedResponse,
  required OIDC4VC oidc4vc,
  required bool isEBSIV3,
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
  required String? clientAssertion,
  required bool secureAuthorizedFlow,
  required DioClient client,
}) async {
  /// this is first phase flow for authorization_code

  String? issuerState;

  final grants = credentialOfferJson['grants'];

  if (grants != null && grants is Map) {
    final dynamic authorizedCode = grants['authorization_code'];
    if (authorizedCode != null &&
        authorizedCode is Map &&
        authorizedCode.containsKey('issuer_statee')) {
      issuerState = authorizedCode['issuer_state'] as String;
    }
  }

  final String nonce = const Uuid().v4();
  final PkcePair pkcePair = PkcePair.generate();

  final data = {
    'codeVerifier': pkcePair.codeVerifier,
    'credentials': selectedCredentials,
    'issuer': issuer,
    'isEBSIV3': isEBSIV3,
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
      data['client_assertion'] = clientAssertion!;
  }

  final jwt = JWT(data);

  await dotenv.load();
  final String authorizationUriSecretKey =
      dotenv.get('AUTHORIZATION_URI_SECRET_KEY');

  final jwtToken = jwt.sign(SecretKey(authorizationUriSecretKey));

  late Uri authorizationUri;

  final (authorizationEndpoint, authorizationRequestParemeters) =
      await oidc4vc.getAuthorizationData(
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
    clientAssertion: clientAssertion,
    secureAuthorizedFlow: secureAuthorizedFlow,
  );

  if (secureAuthorizedFlow) {
    final headers = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await client.post(
      '$authorizationEndpoint/par',
      headers: headers,
      data: authorizationRequestParemeters,
    );

    final requestUri = response['request_uri'];

    if (requestUri == null) throw Exception();

    final parameters = {'client_id': clientId, 'request_uri': requestUri};

    final url = Uri.parse(authorizationEndpoint);
    authorizationUri = Uri.https(url.authority, url.path, parameters);
  } else {
    final url = Uri.parse(authorizationEndpoint);
    authorizationUri =
        Uri.https(url.authority, url.path, authorizationRequestParemeters);
  }

  await LaunchUrl.launchUri(authorizationUri);
}
