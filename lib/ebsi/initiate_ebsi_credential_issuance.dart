import 'dart:convert';

import 'package:altme/app/shared/constants/parameters.dart';
import 'package:altme/app/shared/constants/secure_storage_keys.dart';
import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/helper_functions/helper_functions.dart';
import 'package:altme/app/shared/launch_url/launch_url.dart';
import 'package:altme/ebsi/add_ebsi_credential.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
// ignore: implementation_imports
import 'package:secure_storage/src/secure_storage.dart';

Future<void> initiateEbsiCredentialIssuance(
  String scannedResponse,
  DioClient client,
  WalletCubit walletCubit,
  SecureStorageProvider secureStorage,
) async {
  final Ebsi ebsi = Ebsi(Dio());
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);
  if (uriFromScannedResponse.queryParameters['pre-authorized_code'] != null) {
    final String p256PrivateKey = await getRandomP256PrivateKey(secureStorage);

    // final mnemonic = await secureStorage.get(
    //   SecureStorageKeys.ssiMnemonic,
    // );

    final dynamic encodedCredentialFromEbsi = await ebsi.getCredential(
      uriFromScannedResponse,
      null,
      p256PrivateKey,
    );

    await addEbsiCredential(
      encodedCredentialFromEbsi,
      uriFromScannedResponse,
      walletCubit,
    );
  } else {
    final Uri ebsiAuthenticationUri = await ebsi.getAuthorizationUriForIssuer(
      scannedResponse,
      Parameters.ebsiUniversalLink,
    );
    await LaunchUrl.launchUri(ebsiAuthenticationUri);
  }
}
