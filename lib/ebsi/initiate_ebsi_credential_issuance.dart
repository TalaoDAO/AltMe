import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/ebsi/add_ebsi_credential.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:secure_storage/secure_storage.dart';

Future<void> initiateEbsiCredentialIssuance(
  String scannedResponse,
  DioClient client,
  CredentialsCubit credentialsCubit,
  SecureStorageProvider secureStorage,
) async {
  final Ebsi ebsi = Ebsi(Dio());
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);
  if (uriFromScannedResponse.queryParameters['pre-authorized_code'] != null) {
    final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
    final privateKey = await ebsi.privateKeyFromMnemonic(mnemonic: mnemonic!);

    final dynamic encodedCredentialFromEbsi = await ebsi.getCredential(
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
    final Uri ebsiAuthenticationUri = await ebsi.getAuthorizationUriForIssuer(
      scannedResponse,
      Parameters.ebsiUniversalLink,
    );
    await LaunchUrl.launchUri(ebsiAuthenticationUri);
  }
}
