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
  required OIDC4VC oidc4vc,
  required bool isEBSIV3,
  required QRCodeScanCubit qrCodeScanCubit,
  required DIDKitProvider didKitProvider,
  required CredentialsCubit credentialsCubit,
  required OIDC4VCIDraftType draftType,
  required ProfileCubit profileCubit,
  required SecureStorageProvider secureStorageProvider,
  required DioClient dioClient,
  required String? userPin,
  required dynamic credentialOfferJson,
  required bool cryptoHolderBinding,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  final keys = <String>[];
  uriFromScannedResponse.queryParameters.forEach((key, value) => keys.add(key));

  late dynamic credentials;

  if (keys.contains('credential_type')) {
    credentials = uriFromScannedResponse.queryParameters['credential_type'];
  } else {
    if (credentialOfferJson == null) throw Exception();

    credentials = credentialOfferJson['credentials'];
  }

  final (preAuthorizedCode, issuer) = await getIssuerAndPreAuthorizedCode(
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
        issuer: issuer!,
        preAuthorizedCode: preAuthorizedCode,
        isEBSIV3: isEBSIV3,
        credentialOfferJson: credentialOfferJson,
      );
    } else {
      if (codeForAuthorisedFlow == null || state == null) {
        /// first phase flow of authorised
        qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
          credentials: credentials,
          userPin: userPin,
          issuer: issuer!,
          preAuthorizedCode: preAuthorizedCode,
          isEBSIV3: isEBSIV3,
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
        final String? authorization = jwt['authorization'] as String?;

        final selectedCredentials = stateOfCredentialsSelected
            .map((index) => credentials[index])
            .toList();

        await qrCodeScanCubit.addCredentialsInLoop(
          selectedCredentials: selectedCredentials,
          userPin: userPin,
          issuer: issuer!,
          preAuthorizedCode: null,
          isEBSIV3: isEBSIV3,
          codeForAuthorisedFlow: codeForAuthorisedFlow,
          codeVerifier: codeVerifier,
          authorization: authorization,
        );
      }
    }
  } else {
    final didKeyType = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid;
    await getAndAddCredential(
      scannedResponse: scannedResponse,
      isEBSIV3: isEBSIV3,
      oidc4vc: oidc4vc,
      didKitProvider: didKitProvider,
      credentialsCubit: credentialsCubit,
      credential: credentials,
      secureStorageProvider: secureStorageProvider,
      isLastCall: true,
      dioClient: dioClient,
      userPin: userPin,
      issuer: issuer!,
      preAuthorizedCode: preAuthorizedCode,
      codeForAuthorisedFlow: null,
      codeVerifier: null,
      authorization: null,
      cryptoHolderBinding: cryptoHolderBinding,
      draftType: draftType,
      didKeyType: didKeyType,
    );
    oidc4vc.resetNonceAndAccessTokenAndAuthorizationDetails();
    qrCodeScanCubit.goBack();
  }
}
