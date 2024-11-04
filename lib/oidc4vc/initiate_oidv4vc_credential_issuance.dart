import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:did_kit/did_kit.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

import 'package:secure_storage/secure_storage.dart';

Future<void> initiateOIDC4VCCredentialIssuance({
  required String scannedResponse,
  required OIDC4VC oidc4vc,
  required bool isEBSI,
  required QRCodeScanCubit qrCodeScanCubit,
  required DIDKitProvider didKitProvider,
  required CredentialsCubit credentialsCubit,
  required OIDC4VCIDraftType oidc4vciDraftType,
  required ProfileCubit profileCubit,
  required SecureStorageProvider secureStorageProvider,
  required DioClient dioClient,
  required String? userPin,
  required String? txCode,
  required dynamic credentialOfferJson,
  required bool cryptoHolderBinding,
  required OpenIdConfiguration? openIdConfiguration,
  required String issuer,
  required String? preAuthorizedCode,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  final keys = <String>[];
  uriFromScannedResponse.queryParameters.forEach((key, value) => keys.add(key));

  late dynamic credentials;

  if (keys.contains('credential_type')) {
    credentials = uriFromScannedResponse.queryParameters['credential_type'];
  } else {
    final validCredentialOffer = credentialOfferJson != null &&
        credentialOfferJson is Map<String, dynamic>;

    if (!validCredentialOffer) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_issuer_metadata',
          'error_description': 'The issuer configuration is invalid. '
              'The credential offer is missing.',
        },
      );
    }

    if (credentialOfferJson.containsKey('credentials')) {
      credentials = credentialOfferJson['credentials'];
    } else if (credentialOfferJson
        .containsKey('credential_configuration_ids')) {
      credentials = credentialOfferJson['credential_configuration_ids'];
    } else {
      throw ResponseMessage(
        data: {
          'error': 'invalid_issuer_metadata',
          'error_description': 'The issuer configuration is invalid. '
              'The credential offer is missing.',
        },
      );
    }
  }

  //cleared up to here

  if (credentials is List<dynamic>) {
    final codeForAuthorisedFlow =
        Uri.parse(scannedResponse).queryParameters['code'];
    final state = Uri.parse(scannedResponse).queryParameters['state'];

    if (openIdConfiguration == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_issuer_metadata',
          'error_description': 'The open id configuration is invalid.',
        },
      );
    }

    if (preAuthorizedCode != null) {
      /// full phase flow of preAuthorized
      qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
        credentials: credentials,
        userPin: userPin,
        txCode: txCode,
        issuer: issuer,
        preAuthorizedCode: preAuthorizedCode,
        isEBSI: isEBSI,
        credentialOfferJson: credentialOfferJson,
        openIdConfiguration: openIdConfiguration,
      );
    } else {
      if (codeForAuthorisedFlow == null || state == null) {
        /// first phase flow of authorised
        qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
          credentials: credentials,
          userPin: userPin,
          txCode: txCode,
          issuer: issuer,
          preAuthorizedCode: preAuthorizedCode,
          isEBSI: isEBSI,
          credentialOfferJson: credentialOfferJson,
          openIdConfiguration: openIdConfiguration,
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
        final String? clientId = jwt['client_id'] as String?;
        final String? clientSecret = jwt['client_secret'] as String?;
        final String? oAuthClientAttestation =
            jwt['oAuthClientAttestation'] as String?;
        final String? oAuthClientAttestationPop =
            jwt['oAuthClientAttestationPop'] as String?;

        final selectedCredentials = stateOfCredentialsSelected
            .map((index) => credentials[index])
            .toList();

        await qrCodeScanCubit.addCredentialsInLoop(
          selectedCredentials: selectedCredentials,
          userPin: userPin,
          txCode: txCode,
          issuer: issuer,
          preAuthorizedCode: null,
          isEBSI: isEBSI,
          codeForAuthorisedFlow: codeForAuthorisedFlow,
          codeVerifier: codeVerifier,
          authorization: authorization,
          clientId: clientId,
          clientSecret: clientSecret,
          oAuthClientAttestation: oAuthClientAttestation,
          oAuthClientAttestationPop: oAuthClientAttestationPop,
          qrCodeScanCubit: qrCodeScanCubit,
        );
      }
    }
  } else {
    // full phase flow of preAuthorized
    await qrCodeScanCubit.processSelectedCredentials(
      userPin: userPin,
      txCode: txCode,
      issuer: issuer,
      preAuthorizedCode: preAuthorizedCode,
      isEBSI: isEBSI,
      credentialOfferJson: credentialOfferJson,
      selectedCredentials: [credentials],
      qrCodeScanCubit: qrCodeScanCubit,
    );
  }
}
