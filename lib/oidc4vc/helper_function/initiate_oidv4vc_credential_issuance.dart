import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:did_kit/did_kit.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

import 'package:secure_storage/secure_storage.dart';

Future<void> initiateOIDC4VCCredentialIssuance({
  required Oidc4vcParameters oidc4vcParameters,
  required QRCodeScanCubit qrCodeScanCubit,
  required DIDKitProvider didKitProvider,
  required CredentialsCubit credentialsCubit,
  required ProfileCubit profileCubit,
  required SecureStorageProvider secureStorageProvider,
  required DioClient dioClient,
  required String? userPin,
  required String? txCode,
  required bool cryptoHolderBinding,
}) async {
  final keys = <String>[];
  oidc4vcParameters.initialUri.queryParameters
      .forEach((key, value) => keys.add(key));
  final uriFromScannedResponse = oidc4vcParameters.initialUri;
  late dynamic credentials;

  if (keys.contains('credential_type')) {
    credentials = uriFromScannedResponse.queryParameters['credential_type'];
  }
  if (oidc4vcParameters.classCredentialOffer.containsKey('credentials')) {
    credentials = oidc4vcParameters.classCredentialOffer['credentials'];
  } else if (oidc4vcParameters.classCredentialOffer
      .containsKey('credential_configuration_ids')) {
    credentials =
        oidc4vcParameters.classCredentialOffer['credential_configuration_ids'];
  } else {
    throw ResponseMessage(
      data: {
        'error': 'invalid_issuer_metadata',
        'error_description': 'The issuer configuration is invalid. '
            'The credential offer is missing.',
      },
    );
  }

  //cleared up to here

  if (credentials is List<dynamic>) {
    final codeForAuthorisedFlow =
        oidc4vcParameters.initialUri.queryParameters['code'];
    final state = oidc4vcParameters.initialUri.queryParameters['state'];

    if (oidc4vcParameters.preAuthorizedCode != null) {
      /// full phase flow of preAuthorized
      qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
        credentials: credentials,
        userPin: userPin,
        txCode: txCode,
        oidc4vcParameters: oidc4vcParameters,
      );
    } else {
      if (codeForAuthorisedFlow == null || state == null) {
        /// first phase flow of authorised
        qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
          credentials: credentials,
          userPin: userPin,
          txCode: txCode,
          oidc4vcParameters: oidc4vcParameters,
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
        final String publicKeyForDPop = jwt['publicKeyForDPop'].toString();
        final String oidc4vciDraft = jwt['oidc4vciDraft'].toString();

        final OIDC4VCIDraftType? oidc4vciDraftType = OIDC4VCIDraftType.values
            .firstWhereOrNull((ele) => ele.numbering == oidc4vciDraft);

        if (oidc4vciDraftType == null) {
          throw Exception();
        }

        final selectedCredentials = stateOfCredentialsSelected
            .map((index) => credentials[index])
            .toList();

        await qrCodeScanCubit.addCredentialsInLoop(
          selectedCredentials: selectedCredentials,
          userPin: userPin,
          txCode: txCode,
          codeForAuthorisedFlow: codeForAuthorisedFlow,
          codeVerifier: codeVerifier,
          authorization: authorization,
          clientId: clientId,
          clientSecret: clientSecret,
          oAuthClientAttestation: oAuthClientAttestation,
          oAuthClientAttestationPop: oAuthClientAttestationPop,
          publicKeyForDPop: publicKeyForDPop,
          oidc4vcParameters: oidc4vcParameters,
        );
      }
    }
  } else {
    // full phase flow of preAuthorized
    await qrCodeScanCubit.processSelectedCredentials(
      userPin: userPin,
      txCode: txCode,
      selectedCredentials: [credentials],
      oidc4vcParameters: oidc4vcParameters,
    );
  }
}
