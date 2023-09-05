import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/add_oidc4vc_credential.dart';

import 'package:did_kit/did_kit.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

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

  if (credentials is List<dynamic>) {
    qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
      credentials: credentials,
      userPin: userPin,
    );
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
    );
    oidc4vc.resetNonceAndAccessToken();
    qrCodeScanCubit.goBack();
  }
}

Future<void> getAndAddCredential({
  required String scannedResponse,
  required OIDC4VC oidc4vc,
  required OIDC4VCType oidc4vcType,
  required DIDKitProvider didKitProvider,
  required CredentialsCubit credentialsCubit,
  required dynamic credential,
  required SecureStorageProvider secureStorageProvider,
  required bool isLastCall,
  required DioClient dioClient,
  required String? userPin,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  final (preAuthorizedCode, issuer) = await getIssuerAndPreAuthorizedCode(
    oidc4vcType: oidc4vcType,
    scannedResponse: scannedResponse,
    dioClient: dioClient,
  );

  final mnemonic =
      await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

  final privateKey = await oidc4vc.privateKeyFromMnemonic(
    mnemonic: mnemonic!,
    indexValue: oidc4vcType.indexValue,
  );

  final (did, kid) = await getDidAndKid(
    oidc4vcType: oidc4vcType,
    privateKey: privateKey,
    didKitProvider: didKitProvider,
  );

  if (preAuthorizedCode != null) {
    final (
      dynamic encodedCredentialOrFutureToken,
      String? deferredCredentialEndpoint,
      String format
    ) = await oidc4vc.getCredential(
      preAuthorizedCode: preAuthorizedCode,
      issuer: issuer,
      credential: credential,
      did: did,
      kid: kid,
      credentialRequestUri: uriFromScannedResponse,
      privateKey: privateKey,
      indexValue: oidc4vcType.indexValue,
      userPin: userPin,
    );
    final String credentialName = getCredentialData(credential);
    final acceptanceToken = encodedCredentialOrFutureToken['acceptance_token'];

    if (acceptanceToken != null && deferredCredentialEndpoint != null) {
      /// add deferred card
      final id = const Uuid().v4();

      final credentialModel = CredentialModel(
        id: id,
        credentialPreview: Credential(
          'dummy1',
          ['dummy2'],
          [credentialName],
          'dummy4',
          'dummy5',
          '',
          [Proof.dummy()],
          CredentialSubjectModel(
            id: 'dummy7',
            type: 'dummy8',
            issuedBy: const Author(''),
            credentialCategory: CredentialCategory.pendingCards,
            credentialSubjectType: CredentialSubjectType.defaultCredential,
          ),
          [Translation('en', '')],
          [Translation('en', '')],
          CredentialStatusField.emptyCredentialStatusField(),
          [Evidence.emptyEvidence()],
        ),
        data: const {},
        display: Display.emptyDisplay(),
        image: '',
        shareLink: '',
        pendingInfo: PendingInfo(
          acceptanceToken: acceptanceToken.toString(),
          deferredCredentialEndpoint: deferredCredentialEndpoint,
          format: format,
          url: scannedResponse,
        ),
      );
      // insert the credential in the wallet
      await credentialsCubit.insertCredential(
        credential: credentialModel,
        showStatus: false,
        showMessage: isLastCall,
        isPendingCredential: true,
      );
    } else {
      await addOIDC4VCCredential(
        encodedCredentialFromOIDC4VC: encodedCredentialOrFutureToken,
        credentialsCubit: credentialsCubit,
        oidc4vcType: oidc4vcType,
        issuer: issuer,
        credentialType: credentialName,
        isLastCall: isLastCall,
        format: format,
      );
    }
  } else {
    final Uri ebsiAuthenticationUri =
        await oidc4vc.getAuthorizationUriForIssuer(
      scannedResponse,
      Parameters.ebsiUniversalLink,
    );
    await LaunchUrl.launchUri(ebsiAuthenticationUri);
  }
}

Future<dynamic> getCredentialOfferJson({
  required String scannedResponse,
  required DioClient dioClient,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  final keys = <String>[];
  uriFromScannedResponse.queryParameters.forEach((key, value) => keys.add(key));

  dynamic credentialOfferJson;

  if (keys.contains('credential_offer')) {
    credentialOfferJson = jsonDecode(
      uriFromScannedResponse.queryParameters['credential_offer'].toString(),
    );
  } else if (keys.contains('credential_offer_uri')) {
    final url = uriFromScannedResponse.queryParameters['credential_offer_uri']
        .toString();
    final response = await dioClient.get(url);

    credentialOfferJson = response;
  }

  return credentialOfferJson;
}
