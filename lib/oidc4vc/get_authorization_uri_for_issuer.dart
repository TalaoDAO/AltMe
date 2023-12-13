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
  required String clientId,
  required String? clientSecret,
  required bool useBasicClientAuthentication,
}) async {
  /// this is first phase flow for authorization_code

  final issuerState = credentialOfferJson['grants']['authorization_code']
      ['issuer_state'] as String;

  final String nonce = const Uuid().v4();
  final PkcePair pkcePair = PkcePair.generate();

  final data = {
    'codeVerifier': pkcePair.codeVerifier,
    'credentials': selectedCredentials,
    'issuer': issuer,
    'isEBSIV3': isEBSIV3,
  };

  if (clientSecret != null && clientSecret != '') {
    data['authorization'] =
        base64UrlEncode(utf8.encode('$clientId:$clientSecret'));
  }

  final jwt = JWT(data);

  await dotenv.load();
  final String authorizationUriSecretKey =
      dotenv.get('AUTHORIZATION_URI_SECRET_KEY');

  final jwtToken = jwt.sign(SecretKey(authorizationUriSecretKey));
  final tokenEndpointAuthMethod =
      useBasicClientAuthentication ? 'client_secret_basic' : 'none';
  final Uri oidc4vcAuthenticationUri =
      await oidc4vc.getAuthorizationUriForIssuer(
    selectedCredentials: selectedCredentials,
    clientId: clientId,
    redirectUri: Parameters.oidc4vcUniversalLink,
    issuer: issuer,
    issuerState: issuerState,
    nonce: nonce,
    pkcePair: pkcePair,
    state: jwtToken,
    authorizationEndPoint: Parameters.authorizeEndPoint,
    scope: scope,
    tokenEndpointAuthMethod: tokenEndpointAuthMethod,
  );

  await LaunchUrl.launchUri(oidc4vcAuthenticationUri);
}
