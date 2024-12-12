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
  required OIDC4VC oidc4vc,
  required JWTDecode jwtDecode,
  required OIDC4VCIDraftType oidc4vciDraftType,
  required BlockchainType blockchainType,
  required String? issuer,
  required QRCodeScanCubit qrCodeScanCubit,
  required ProfileCubit profileCubit,
}) async {
  late Map<String, dynamic> credentialHeaders;
  late Map<String, dynamic> body;

  final pendingInfo = credentialModel.pendingInfo!;

  switch (oidc4vciDraftType) {
    case OIDC4VCIDraftType.draft11:
      final acceptanceToken = pendingInfo
          .encodedCredentialFromOIDC4VC['acceptance_token']
          .toString();

      credentialHeaders = <String, dynamic>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $acceptanceToken',
      };
    case OIDC4VCIDraftType.draft13:
    case OIDC4VCIDraftType.draft14:

      /// trasanction_id is NEW for draft 13. it was
      /// acceptance_token for draft 11
      final accessToken = pendingInfo.accessToken;

      credentialHeaders = <String, dynamic>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final transactionId =
          pendingInfo.encodedCredentialFromOIDC4VC['transaction_id'].toString();

      body = {'transaction_id': transactionId};
  }

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

  final dynamic encodedCredentialOrFutureToken =
      await oidc4vc.getDeferredCredential(
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
    isLastCall: true,
    format: credentialModel.pendingInfo!.format,
    credentialIdToBeDeleted: credentialModel.id,
    openIdConfiguration: null,
    jwtDecode: jwtDecode,
    blockchainType: blockchainType,
    qrCodeScanCubit: qrCodeScanCubit,
  );
}
