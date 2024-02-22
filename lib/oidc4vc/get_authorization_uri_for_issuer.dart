import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:did_kit/did_kit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:uuid/uuid.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

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
  }

  final jwt = JWT(data);

  await dotenv.load();
  final String authorizationUriSecretKey =
      dotenv.get('AUTHORIZATION_URI_SECRET_KEY');

  final jwtToken = jwt.sign(SecretKey(authorizationUriSecretKey));

  final Uri oidc4vcAuthenticationUri =
      await oidc4vc.getAuthorizationUriForIssuer(
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
  );

  await LaunchUrl.launchUri(oidc4vcAuthenticationUri);
}
