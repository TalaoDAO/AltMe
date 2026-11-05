import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// Asks the issuer for the deferred credential of [credentialModel], a
/// pending card, and stores it in place of the card once issued.
///
/// Returns how long the issuer asks to wait before asking again while the
/// credential is not ready, or null when there is nothing more to ask: it is
/// stored, or the user cancelled. [confirm]: in developer mode, show the
/// request before sending it, as after a tap on "Get it now"; polling sends
/// it without asking.
Future<Duration?> getAndAddDefferedCredential({
  required CredentialModel credentialModel,
  required CredentialsCubit credentialsCubit,
  required OIDC4VCIClient oidc4vc,
  required JWTDecode jwtDecode,
  required BlockchainType? blockchainType,
  required String? issuer,
  required QRCodeScanCubit qrCodeScanCubit,
  required ProfileCubit profileCubit,
  bool confirm = true,
}) async {
  final pendingInfo = credentialModel.pendingInfo!;
  final acceptanceToken = pendingInfo
      .encodedCredentialFromOIDC4VC['acceptance_token']
      ?.toString();
  final transactionId = pendingInfo
      .encodedCredentialFromOIDC4VC['transaction_id']
      ?.toString();

  if (confirm && profileCubit.state.model.isDeveloperMode) {
    final value = await qrCodeScanCubit.showDataBeforeSending(
      title: 'DEFERRED CREDENTIAL REQUEST',
      data: oidc4vc
          .buildDeferredCredentialRequest(
            acceptanceToken: acceptanceToken,
            pendingAccessToken: pendingInfo.accessToken,
            transactionId: transactionId,
          )
          .body,
    );

    if (value) {
      qrCodeScanCubit.completer = null;
    } else {
      qrCodeScanCubit.completer = null;
      qrCodeScanCubit.resetNonceAndAccessTokenAndAuthorizationDetails();
      qrCodeScanCubit.goBack();
      return null;
    }
  }

  final response = await oidc4vc.requestDeferredCredential(
    deferredCredentialEndpoint: pendingInfo.deferredCredentialEndpoint,
    accessToken: pendingInfo.accessToken,
    transactionId: transactionId,
    acceptanceToken: acceptanceToken,
    dpopKey: pendingInfo.dpopKey,
    dio: Dio()..interceptors.addAll([if (kDebugMode) Logging()]),
  );

  switch (response) {
    case DeferredCredentialPending(:final interval):
      return interval;
    case DeferredCredentialReady(:final credentialResponse):
      await addOIDC4VCCredential(
        encodedCredentialFromOIDC4VC: credentialResponse,
        credentialsCubit: credentialsCubit,
        issuer: issuer,
        credentialType: credentialModel.credentialPreview.type[0],
        format: pendingInfo.format,
        credentialIdToBeDeleted: credentialModel.id,
        openIdConfiguration: await _issuerMetadata(
          oidc4vc: oidc4vc,
          issuer: issuer ?? pendingInfo.issuer,
          dio: qrCodeScanCubit.client.dio,
        ),
        jwtDecode: jwtDecode,
        qrCodeScanCubit: qrCodeScanCubit,
      );
      return null;
  }
}

/// The metadata of [issuer], which gives the credential its display (name,
/// background image), or null when it cannot be read: the credential is
/// stored anyway.
Future<OpenIdConfiguration?> _issuerMetadata({
  required OIDC4VCIClient oidc4vc,
  required String? issuer,
  required Dio dio,
}) async {
  if (issuer == null) return null;
  try {
    return await oidc4vc.getIssuerMetaData(baseUrl: issuer, dio: dio);
  } catch (e, s) {
    getLogger(
      'getAndAddDefferedCredential',
    ).e('no issuer metadata at $issuer: $e', error: e, stackTrace: s);
    return null;
  }
}
