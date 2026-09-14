import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<void> getAndAddDefferedCredential({
  required CredentialModel credentialModel,
  required CredentialsCubit credentialsCubit,
  required OIDC4VCIClient oidc4vc,
  required JWTDecode jwtDecode,
  required BlockchainType? blockchainType,
  required String? issuer,
  required QRCodeScanCubit qrCodeScanCubit,
  required ProfileCubit profileCubit,
}) async {
  final pendingInfo = credentialModel.pendingInfo!;

  final deferredRequest = oidc4vc.buildDeferredCredentialRequest(
    acceptanceToken:
        pendingInfo.encodedCredentialFromOIDC4VC['acceptance_token']
            ?.toString(),
    pendingAccessToken: pendingInfo.accessToken,
    transactionId: pendingInfo.encodedCredentialFromOIDC4VC['transaction_id']
        ?.toString(),
  );

  final credentialHeaders = deferredRequest.headers;
  final body = deferredRequest.body;

  if (profileCubit.state.model.isDeveloperMode) {
    final value = await qrCodeScanCubit.showDataBeforeSending(
      title: 'DEFERRED CREDENTIAL REQUEST',
      data: body,
    );

    if (value) {
      qrCodeScanCubit.completer = null;
    } else {
      qrCodeScanCubit.completer = null;
      qrCodeScanCubit.resetNonceAndAccessTokenAndAuthorizationDetails();
      qrCodeScanCubit.goBack();
      return;
    }
  }

  final dynamic encodedCredentialOrFutureToken = await oidc4vc
      .getDeferredCredential(
        credentialHeaders: credentialHeaders,
        deferredCredentialEndpoint:
            credentialModel.pendingInfo!.deferredCredentialEndpoint,
        body: body,
        dio: Dio(),
      );

  await addOIDC4VCCredential(
    encodedCredentialFromOIDC4VC: encodedCredentialOrFutureToken,
    credentialsCubit: credentialsCubit,
    issuer: issuer,
    credentialType: credentialModel.credentialPreview.type[0],
    format: credentialModel.pendingInfo!.format,
    credentialIdToBeDeleted: credentialModel.id,
    openIdConfiguration: null,
    jwtDecode: jwtDecode,
    qrCodeScanCubit: qrCodeScanCubit,
  );
}
