import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// Retreive credential_type from url
// encodedCredentialOrFutureTokens,deferredCredentialEndpoint,
// format
Future<
    (
      List<dynamic>,
      String?,
      String,
    )> getCredential({
  required bool isEBSIV3,
  required dynamic credential,
  required ProfileCubit profileCubit,
  required String issuer,
  required bool cryptoHolderBinding,
  required OIDC4VCIDraftType oidc4vciDraftType,
  required DidKeyType didKeyType,
  required String? clientId,
  required String accessToken,
  required String? nonce,
  required OpenIdConfiguration openIdConfiguration,
  required List<dynamic>? authorizationDetails,
}) async {
  final privateKey = await fetchPrivateKey(
    isEBSIV3: isEBSIV3,
    didKeyType: didKeyType,
    profileCubit: profileCubit,
  );

  final (did, kid) = await fetchDidAndKid(
    isEBSIV3: isEBSIV3,
    privateKey: privateKey,
    didKeyType: didKeyType,
    profileCubit: profileCubit,
  );

  final customOidc4vcProfile = profileCubit.state.model.profileSetting
      .selfSovereignIdentityOptions.customOidc4vcProfile;

  final (
    List<dynamic> encodedCredentialOrFutureTokens,
    String? deferredCredentialEndpoint,
    String format,
  ) = await profileCubit.oidc4vc.getCredential(
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
