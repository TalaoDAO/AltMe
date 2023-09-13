import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';

import 'package:did_kit/did_kit.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

Future<void> initiateOIDC4VCCredentialIssuance({
  required String scannedResponse,
  required OIDC4VCType oidc4vcType,
  required QRCodeScanCubit qrCodeScanCubit,
  required DIDKitProvider didKitProvider,
  required CredentialsCubit credentialsCubit,
  required SecureStorageProvider secureStorageProvider,
  required DioClient dioClient,
  required String? userPin,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  late dynamic credentials;

  switch (oidc4vcType) {
    case OIDC4VCType.DEFAULT:
    case OIDC4VCType.GREENCYPHER:
    case OIDC4VCType.EBSIV3:
      final dynamic credentialOfferJson = await getCredentialOfferJson(
        scannedResponse: scannedResponse,
        dioClient: dioClient,
      );
      if (credentialOfferJson == null) throw Exception();

      credentials = credentialOfferJson['credentials'];

    case OIDC4VCType.GAIAX:
    case OIDC4VCType.EBSIV2:
      credentials = uriFromScannedResponse.queryParameters['credential_type'];

    case OIDC4VCType.JWTVC:
      break;
  }

  final (preAuthorizedCode, issuer) = await getIssuerAndPreAuthorizedCode(
    oidc4vcType: oidc4vcType,
    scannedResponse: scannedResponse,
    dioClient: dioClient,
  );

  if (credentials is List<dynamic>) {
    final codeForAuthorisedFlow =
        Uri.parse(scannedResponse).queryParameters['code'];
    final stateOfCredentialsSelected =
        Uri.parse(scannedResponse).queryParameters['options'];

    if (preAuthorizedCode != null) {
      /// full phase flow of preAuthorized
      qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
        credentials: credentials,
        userPin: userPin,
        issuer: issuer,
        preAuthorizedCode: preAuthorizedCode,
        oidc4vcType: oidc4vcType,
      );
    } else {
      if (codeForAuthorisedFlow == null || stateOfCredentialsSelected == null) {
        /// first phase flow of authorised
        qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
          credentials: credentials,
          userPin: userPin,
          issuer: issuer,
          preAuthorizedCode: preAuthorizedCode,
          oidc4vcType: oidc4vcType,
        );
      } else {
        /// second phase flow of authorised

        /// remove empty fields
        stateOfCredentialsSelected.replaceAll(' ', '');

        /// Remove the brackets and split the string into a list of substrings
        final List<String> stringList = stateOfCredentialsSelected
            .substring(1, stateOfCredentialsSelected.length - 1)
            .split(',');

        // Convert the list of strings to a list of integers
        final List<int> intList = stringList.map(int.parse).toList();

        final selectedCredentials =
            intList.map((index) => credentials[index]).toList();
        await qrCodeScanCubit.addCredentialsInLoop(
          selectedCredentials: selectedCredentials,
          userPin: userPin,
          issuer: issuer,
          preAuthorizedCode: preAuthorizedCode,
          oidc4vcType: oidc4vcType,
        );
      }
    }
  } else {
    final OIDC4VC oidc4vc = oidc4vcType.getOIDC4VC;
    await getAndAddCredential(
      scannedResponse: scannedResponse,
      oidc4vcType: oidc4vcType,
      oidc4vc: oidc4vc,
      didKitProvider: didKitProvider,
      credentialsCubit: credentialsCubit,
      credential: credentials,
      secureStorageProvider: secureStorageProvider,
      isLastCall: true,
      dioClient: dioClient,
      userPin: userPin,
      issuer: issuer,
      preAuthorizedCode: preAuthorizedCode,
    );
    oidc4vc.resetNonceAndAccessTokenAndAuthorizationDetails();
    qrCodeScanCubit.goBack();
  }
}
