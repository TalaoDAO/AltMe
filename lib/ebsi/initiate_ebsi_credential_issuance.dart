import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/ebsi/add_ebsi_credential.dart';
import 'package:crypto/crypto.dart';
import 'package:did_kit/did_kit.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

Future<void> initiateEbsiCredentialIssuance(
  String scannedResponse,
  CredentialsCubit credentialsCubit,
  OIDC4VCType oidc4vcType,
  SecureStorageProvider secureStorage,
  DIDKitProvider didKitProvider,
) async {
  final OIDC4VC oidc4vc = oidc4vcType.getOIDC4VC;

  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  String? preAuthorizedCode;
  late String issuer;
  late String credentialTypeOrId;
  late String did;
  late String kid;

  final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);

  final privateKey = await oidc4vc.privateKeyFromMnemonic(
    mnemonic: mnemonic!,
    index: oidc4vcType.index,
  );

  switch (oidc4vcType) {
    case OIDC4VCType.DEFAULT:
      final credentialOfferJson = jsonDecode(
        uriFromScannedResponse.queryParameters['credential_offer'].toString(),
      );
      preAuthorizedCode = credentialOfferJson['grants']
                  ['urn:ietf:params:oauth:grant-type:pre-authorized_code']
              ['pre-authorized_code']
          .toString();
      issuer = credentialOfferJson['credential_issuer'].toString();
      credentialTypeOrId = credentialOfferJson['credentials'][0].toString();

      const didMethod = AltMeStrings.defaultDIDMethod;
      did = didKitProvider.keyToDID(didMethod, privateKey);
      kid = await didKitProvider.keyToVerificationMethod(didMethod, privateKey);

      break;
    case OIDC4VCType.EBSIV2:
      preAuthorizedCode =
          uriFromScannedResponse.queryParameters['pre-authorized_code'];
      issuer = uriFromScannedResponse.queryParameters['issuer'].toString();
      credentialTypeOrId =
          uriFromScannedResponse.queryParameters['credential_type'].toString();

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
      preAuthorizedCode,
      issuer,
      credentialTypeOrId,
      did,
      kid,
      uriFromScannedResponse,
      null,
      privateKey,
    );

    await addOIDC4VCCredential(
      encodedCredentialFromOIDC4VC,
      uriFromScannedResponse,
      credentialsCubit,
      oidc4vcType,
      issuer,
      credentialTypeOrId,
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
