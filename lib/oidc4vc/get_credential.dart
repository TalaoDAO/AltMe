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
    )> getCredential({
  required OIDC4VC oidc4vc,
  required bool isEBSIV3,
  required DIDKitProvider didKitProvider,
  required dynamic credential,
  required ProfileCubit profileCubit,
  required String issuer,
  required bool cryptoHolderBinding,
  required OIDC4VCIDraftType oidc4vciDraftType,
  required DidKeyType didKeyType,
  required String? clientId,
  required String accessToken,
  required String nonce,
  required OpenIdConfiguration openIdConfiguration,
  required List<dynamic>? authorizationDetails,
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

  final (
    List<dynamic> encodedCredentialOrFutureTokens,
    String? deferredCredentialEndpoint,
    String format,
  ) = await oidc4vc.getCredential(
    issuer: issuer,
    credential: credential,
    did: did,
    kid: kid,
    clientId: clientId,
    privateKey: privateKey,
    cryptoHolderBinding: cryptoHolderBinding,
    oidc4vciDraftType: oidc4vciDraftType,
    clientType: customOidc4vcProfile.clientType,
    proofHeaderType: customOidc4vcProfile.proofHeader,
    clientAuthentication: customOidc4vcProfile.clientAuthentication,
    proofType: customOidc4vcProfile.proofType,
    accessToken: accessToken,
    cnonce: nonce,
    authorizationDetails: authorizationDetails,
    openIdConfiguration: openIdConfiguration,
  );

  return (
    encodedCredentialOrFutureTokens,
    deferredCredentialEndpoint,
    format,
  );
}
