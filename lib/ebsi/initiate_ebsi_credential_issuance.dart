import 'package:altme/app/shared/constants/parameters.dart';
import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/launch_url/launch_url.dart';
import 'package:altme/ebsi/add_ebsi_credential.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';

Future<void> initiateEbsiCredentialIssuance(
  String scannedResponse,
  DioClient client,
  WalletCubit walletCubit,
) async {
  final Ebsi ebsi = Ebsi(Dio());
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);
  if (uriFromScannedResponse.queryParameters['pre-authorized_code'] != null) {
    final dynamic encodedCredentialFromEbsi =
        await ebsi.getCredentialWithPreAuthorizedCode(uriFromScannedResponse);
    await addEbsiCredential(
        encodedCredentialFromEbsi, uriFromScannedResponse, walletCubit);
  } else {
    final Uri ebsiAuthenticationUri = await ebsi.getAuthorizationUriForIssuer(
      scannedResponse,
      Parameters.ebsiUniversalLink,
    );
    final headers = {
      'Conformance': 'conformance',
      'Content-Type': 'application/json'
    };

    // final headers = {'Content-Type': 'application/json'};
    print(ebsiAuthenticationUri);
    final dynamic authorizationResponse = await client.get(
      '${ebsiAuthenticationUri.scheme}://${ebsiAuthenticationUri.authority}/${ebsiAuthenticationUri.path}',
      // headers: headers,
      queryParameters: ebsiAuthenticationUri.queryParameters,
    );
    await LaunchUrl.launchUri(ebsiAuthenticationUri);
  }
}
