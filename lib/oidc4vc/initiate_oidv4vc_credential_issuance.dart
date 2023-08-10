import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/add_oidc4vc_credential.dart';
import 'package:crypto/crypto.dart';
import 'package:did_kit/did_kit.dart';
import 'package:fast_base58/fast_base58.dart';
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
  required JWTDecode jwtDecode,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  late dynamic credentialTypeOrId;

  switch (oidc4vcType) {
    case OIDC4VCType.DEFAULT:
    case OIDC4VCType.HEDERA:
      final credentialOfferJson = jsonDecode(
        uriFromScannedResponse.queryParameters['credential_offer'].toString(),
      );
      credentialTypeOrId = credentialOfferJson['credentials'];
      break;
    case OIDC4VCType.GAIAX:
    case OIDC4VCType.EBSIV2:
      credentialTypeOrId =
          uriFromScannedResponse.queryParameters['credential_type'];

      break;
    case OIDC4VCType.EBSIV3:
    case OIDC4VCType.JWTVC:
      break;
  }

  if (credentialTypeOrId is List<dynamic>) {
    qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(credentialTypeOrId);
  } else {
    final OIDC4VC oidc4vc = oidc4vcType.getOIDC4VC;
    await getAndAddCredential(
      scannedResponse: scannedResponse,
      oidc4vcType: oidc4vcType,
      oidc4vc: oidc4vc,
      didKitProvider: didKitProvider,
      credentialsCubit: credentialsCubit,
      credentialTypeOrId: credentialTypeOrId.toString(),
      secureStorageProvider: secureStorageProvider,
      isLastCall: true,
      jwtDecode: jwtDecode,
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
  required String credentialTypeOrId,
  required SecureStorageProvider secureStorageProvider,
  required bool isLastCall,
  required JWTDecode jwtDecode,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  String? preAuthorizedCode;
  late String issuer;

  switch (oidc4vcType) {
    case OIDC4VCType.DEFAULT:
    case OIDC4VCType.HEDERA:
      final credentialOfferJson = jsonDecode(
        uriFromScannedResponse.queryParameters['credential_offer'].toString(),
      );
      preAuthorizedCode = credentialOfferJson['grants']
                  ['urn:ietf:params:oauth:grant-type:pre-authorized_code']
              ['pre-authorized_code']
          .toString();
      issuer = credentialOfferJson['credential_issuer'].toString();
      break;
    case OIDC4VCType.GAIAX:
    case OIDC4VCType.EBSIV2:
      issuer = uriFromScannedResponse.queryParameters['issuer'].toString();
      preAuthorizedCode =
          uriFromScannedResponse.queryParameters['pre-authorized_code'];

      break;
    case OIDC4VCType.EBSIV3:
    case OIDC4VCType.JWTVC:
      break;
  }

  /// if preAuthorizedCode is jwt then parse it
  if (preAuthorizedCode != null) {
    final isJwt = jwtDecode.isJWT(preAuthorizedCode);
    if (isJwt) {
      final data = jwtDecode.parseJwt(preAuthorizedCode);
      preAuthorizedCode = data['sub'].toString();
    }
  }

  late String did;
  late String kid;

  final mnemonic =
      await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

  final privateKey = await oidc4vc.privateKeyFromMnemonic(
    mnemonic: mnemonic!,
    index: oidc4vcType.index,
  );

  switch (oidc4vcType) {
    case OIDC4VCType.DEFAULT:
    case OIDC4VCType.HEDERA:
    case OIDC4VCType.GAIAX:
      const didMethod = AltMeStrings.defaultDIDMethod;
      did = didKitProvider.keyToDID(didMethod, privateKey);
      kid = await didKitProvider.keyToVerificationMethod(didMethod, privateKey);

      break;

    case OIDC4VCType.EBSIV2:
      final private = await oidc4vc.getPrivateKey(mnemonic, privateKey);

      final thumbprint = getThumbprint(private);
      final encodedAddress = Base58Encode([2, ...thumbprint]);
      did = 'did:ebsi:z$encodedAddress';
      final lastPart = Base58Encode(thumbprint);
      kid = '$did#$lastPart';
      break;
    case OIDC4VCType.EBSIV3:
    case OIDC4VCType.JWTVC:
      break;
  }

  if (preAuthorizedCode != null) {
    final dynamic encodedCredentialFromOIDC4VC = await oidc4vc.getCredential(
      preAuthorizedCode: preAuthorizedCode,
      issuer: issuer,
      credentialTypeOrId: credentialTypeOrId,
      did: did,
      kid: kid,
      credentialRequestUri: uriFromScannedResponse,
      privateKey: privateKey,
      credentialSupportedTypes: oidc4vcType.credentialSupported,
    );

    await addOIDC4VCCredential(
      encodedCredentialFromOIDC4VC: encodedCredentialFromOIDC4VC,
      uri: uriFromScannedResponse,
      credentialsCubit: credentialsCubit,
      oidc4vcType: oidc4vcType,
      issuer: issuer,
      credentialTypeOrId: credentialTypeOrId,
      isLastCall: isLastCall,
    );
  } else {
    final Uri ebsiAuthenticationUri =
        await oidc4vc.getAuthorizationUriForIssuer(
      scannedResponse,
      Parameters.ebsiUniversalLink,
    );
    await LaunchUrl.launchUri(ebsiAuthenticationUri);
  }
}

List<int> getThumbprint(Map<String, dynamic> privateKey) {
  final publicJWK = Map.of(privateKey)..removeWhere((key, value) => key == 'd');

  /// we use crv P-256K in the rest of the package to ensure compatibility
  /// with jose dart package. In fact our crv is secp256k1 wich change the
  /// fingerprint

  final sortedJwk = Map.fromEntries(
    publicJWK.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
  )
    ..removeWhere((key, value) => key == 'use')
    ..removeWhere((key, value) => key == 'alg');

  /// this test is to be crv agnostic and respect https://www.rfc-editor.org/rfc/rfc7638
  if (sortedJwk['crv'] == 'P-256K') {
    sortedJwk['crv'] = 'secp256k1';
  }

  final jsonString = jsonEncode(sortedJwk);
  final bytesToHash = utf8.encode(jsonString);
  final sha256Digest = sha256.convert(bytesToHash);

  return sha256Digest.bytes;
}
