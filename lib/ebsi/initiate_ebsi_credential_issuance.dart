import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/ebsi/add_ebsi_credential.dart';
import 'package:dio/dio.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

Future<void> initiateEbsiCredentialIssuance(
  String scannedResponse,
  DioClient client,
  CredentialsCubit credentialsCubit,
  SecureStorageProvider secureStorage,
) async {
  final OIDC4VC oidc4vc = OIDC4VC(Dio());
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);
  if (uriFromScannedResponse.queryParameters['pre-authorized_code'] != null) {
    final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
    final privateKey =
        await oidc4vc.privateKeyFromMnemonic(mnemonic: mnemonic!);

    final dynamic encodedCredentialFromEbsi = await oidc4vc.getCredential(
      uriFromScannedResponse,
      null,
      privateKey,
    );

    await addEbsiCredential(
      encodedCredentialFromEbsi,
      uriFromScannedResponse,
      credentialsCubit,
    );
  } else {
    final Uri ebsiAuthenticationUri =
        await oidc4vc.getAuthorizationUriForIssuer(
      scannedResponse,
      Parameters.ebsiUniversalLink,
    );
    await LaunchUrl.launchUri(ebsiAuthenticationUri);
  }
}
