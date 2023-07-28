import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/ebsi/add_ebsi_credential.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

Future<void> initiateEbsiCredentialIssuance(
  String scannedResponse,
  CredentialsCubit credentialsCubit,
  ProfileCubit profileCubit,
  SecureStorageProvider secureStorage,
) async {
  final OIDC4VC oidc4vc = profileCubit.state.model.oidc4vcType.getOIDC4VC;

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
