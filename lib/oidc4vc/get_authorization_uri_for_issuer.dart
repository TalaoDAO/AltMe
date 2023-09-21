import 'package:altme/app/app.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:did_kit/did_kit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

Future<void> getAuthorizationUriForIssuer({
  required String scannedResponse,
  required OIDC4VC oidc4vc,
  required OIDC4VCType oidc4vcType,
  required DIDKitProvider didKitProvider,
  required List<dynamic> selectedCredentials,
  required SecureStorageProvider secureStorageProvider,
  required String issuer,
  required dynamic credentialOfferJson,
}) async {
  final mnemonic =
      await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

  final privateKey = await oidc4vc.privateKeyFromMnemonic(
    mnemonic: mnemonic!,
    indexValue: oidc4vcType.indexValue,
  );

  final (did, _) = await getDidAndKid(
    oidc4vcType: oidc4vcType,
    privateKey: privateKey,
    didKitProvider: didKitProvider,
  );

  /// this is first phase flow for authorization_code

  final issuerState = credentialOfferJson['grants']['authorization_code']
      ['issuer_state'] as String;

  final String nonce = const Uuid().v4();
  final PkcePair pkcePair = PkcePair.generate();

  final jwt = JWT({
    'codeVerifier': pkcePair.codeVerifier,
    'credentials': selectedCredentials,
    'issuer': issuer,
    'type': oidc4vcType.name,
  });

  await dotenv.load();
  final String authorizationUriSecretKey =
      dotenv.get('AUTHORIZATION_URI_SECRET_KEY');

  final jwtToken = jwt.sign(SecretKey(authorizationUriSecretKey));

  final Uri ebsiAuthenticationUri = await oidc4vc.getAuthorizationUriForIssuer(
    selectedCredentials: selectedCredentials,
    clientId: did,
    redirectUri: Parameters.oidc4vcUniversalLink,
    issuer: issuer,
    issuerState: issuerState,
    nonce: nonce,
    pkcePair: PkcePair.generate(),
    state: jwtToken,
  );
  await LaunchUrl.launchUri(ebsiAuthenticationUri);
}
