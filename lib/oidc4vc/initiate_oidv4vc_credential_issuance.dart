import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';

import 'package:did_kit/did_kit.dart';
import 'package:jwt_decode/jwt_decode.dart';
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
  required dynamic credentialOfferJson,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  late dynamic credentials;

  switch (oidc4vcType) {
    case OIDC4VCType.DEFAULT:
    case OIDC4VCType.GREENCYPHER:
    case OIDC4VCType.EBSIV3:
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
    final state = Uri.parse(scannedResponse).queryParameters['state'];

    if (preAuthorizedCode != null) {
      /// full phase flow of preAuthorized
      qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
        credentials: credentials,
        userPin: userPin,
        issuer: issuer,
        preAuthorizedCode: preAuthorizedCode,
        oidc4vcType: oidc4vcType,
        credentialOfferJson: credentialOfferJson,
      );
    } else {
      if (codeForAuthorisedFlow == null || state == null) {
        /// first phase flow of authorised
        qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
          credentials: credentials,
          userPin: userPin,
          issuer: issuer,
          preAuthorizedCode: preAuthorizedCode,
          oidc4vcType: oidc4vcType,
          credentialOfferJson: credentialOfferJson,
        );
      } else {
        /// second phase flow of authorised

        final jwt = decodePayload(
          jwtDecode: JWTDecode(),
          token: state,
        );

        final stateOfCredentialsSelected = jwt['options'] as List<dynamic>;
        final String codeVerifier = jwt['codeVerifier'].toString();

        final selectedCredentials = stateOfCredentialsSelected
            .map((index) => credentials[index])
            .toList();

        await qrCodeScanCubit.addCredentialsInLoop(
          selectedCredentials: selectedCredentials,
          userPin: userPin,
          issuer: issuer,
          preAuthorizedCode: null,
          oidc4vcType: oidc4vcType,
          codeForAuthorisedFlow: codeForAuthorisedFlow,
          codeVerifier: codeVerifier,
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
      codeForAuthorisedFlow: null,
      codeVerifier: null,
    );
    oidc4vc.resetNonceAndAccessTokenAndAuthorizationDetails();
    qrCodeScanCubit.goBack();
  }
}
