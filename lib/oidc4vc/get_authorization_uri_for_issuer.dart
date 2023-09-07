import 'package:altme/app/app.dart';

import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

Future<void> getAuthorizationUriForIssuer({
  required String scannedResponse,
  required OIDC4VC oidc4vc,
  required OIDC4VCType oidc4vcType,
  required DIDKitProvider didKitProvider,
  required List<dynamic> selectedCredentials,
  required List<int> selectedCredentialsIndex,
  required SecureStorageProvider secureStorageProvider,
  required DioClient dioClient,
  required String issuer,
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
  final dynamic credentialOfferJson = await getCredentialOfferJson(
    scannedResponse: scannedResponse,
    dioClient: dioClient,
  );

  final issuerState = credentialOfferJson['grants']['authorization_code']
      ['issuer_state'] as String;

  final String nonce = const Uuid().v4();

  final Uri ebsiAuthenticationUri = await oidc4vc.getAuthorizationUriForIssuer(
    selectedCredentials: selectedCredentials,
    clientId: did,
    redirectUrl: '${Parameters.oidc4vcUniversalLink}$scannedResponse',
    issuer: issuer,
    issuerState: issuerState,
    nonce: nonce,
    state: selectedCredentialsIndex.toString(),
  );
  await LaunchUrl.launchUri(ebsiAuthenticationUri);
}
