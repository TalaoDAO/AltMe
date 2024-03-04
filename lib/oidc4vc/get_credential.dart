import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:did_kit/did_kit.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

/// Retreive credential_type from url
/// credentialResponseData, deferredCredentialEndpoint, format,
/// openIdConfiguration, tokenResponse
Future<
    (
      List<dynamic>,
      String?,
      String,
      OpenIdConfiguration?,
      Map<String, dynamic>?
    )> getCredential({
  required OIDC4VC oidc4vc,
  required bool isEBSIV3,
  required DIDKitProvider didKitProvider,
  required dynamic credential,
  required ProfileCubit profileCubit,
  required String? userPin,
  required String? preAuthorizedCode,
  required String issuer,
  required String? codeForAuthorisedFlow,
  required String? codeVerifier,
  required bool cryptoHolderBinding,
  required String? authorization,
  required OIDC4VCIDraftType oidc4vciDraftType,
  required DidKeyType didKeyType,
  required String? clientId,
  required String? clientSecret,
}) async {
  final privateKey = await fetchPrivateKey(
    isEBSIV3: isEBSIV3,
    oidc4vc: oidc4vc,
    secureStorage: getSecureStorage,
    didKeyType: didKeyType,
  );

  final (did, kid) = await fetchDidAndKid(
    isEBSIV3: isEBSIV3,
    privateKey: privateKey,
    didKitProvider: didKitProvider,
    secureStorage: getSecureStorage,
    didKeyType: didKeyType,
  );

  final customOidc4vcProfile = profileCubit.state.model.profileSetting
      .selfSovereignIdentityOptions.customOidc4vcProfile;

  final index = getIndexValue(isEBSIV3: isEBSIV3, didKeyType: didKeyType);

  var iss = '';

  switch (customOidc4vcProfile.clientType) {
    case ClientType.jwkThumbprint:
      final tokenParameters = TokenParameters(
        privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
        did: '', // just added as it is required field
        mediaType: MediaType.basic, // just added as it is required field
        clientType:
            ClientType.jwkThumbprint, // just added as it is required field
        proofHeaderType: customOidc4vcProfile.proofHeader,
        clientId: '',
      );
      iss = tokenParameters.thumbprint;
    case ClientType.did:
      iss = did;
    case ClientType.confidential:
      iss = customOidc4vcProfile.clientId ?? '';
  }

  final (
    List<dynamic> encodedCredentialOrFutureTokens,
    String? deferredCredentialEndpoint,
    String format,
    OpenIdConfiguration? openIdConfiguration,
    Map<String, dynamic>? tokenResponse,
  ) = await oidc4vc.getCredential(
    preAuthorizedCode: preAuthorizedCode,
    issuer: issuer,
    credential: credential,
    did: did,
    kid: kid,
    clientId: clientId,
    clientSecret: clientSecret,
    privateKey: privateKey,
    indexValue: index,
    userPin: userPin,
    code: codeForAuthorisedFlow,
    codeVerifier: codeVerifier,
    cryptoHolderBinding: cryptoHolderBinding,
    authorization: authorization,
    oidc4vciDraftType: oidc4vciDraftType,
    clientType: customOidc4vcProfile.clientType,
    proofHeaderType: customOidc4vcProfile.proofHeader,
    clientAuthentication: customOidc4vcProfile.clientAuthentication,
    redirectUri: Parameters.oidc4vcUniversalLink,
    proofType: customOidc4vcProfile.proofType,
    iss: iss,
  );

  return (
    encodedCredentialOrFutureTokens,
    deferredCredentialEndpoint,
    format,
    openIdConfiguration,
    tokenResponse,
  );
}
