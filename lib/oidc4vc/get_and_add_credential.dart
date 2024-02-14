import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

Future<void> getAndAddCredential({
  required String scannedResponse,
  required OIDC4VC oidc4vc,
  required bool isEBSIV3,
  required DIDKitProvider didKitProvider,
  required CredentialsCubit credentialsCubit,
  required dynamic credential,
  required SecureStorageProvider secureStorageProvider,
  required ProfileCubit profileCubit,
  required bool isLastCall,
  required DioClient dioClient,
  required String? userPin,
  required String? preAuthorizedCode,
  required String issuer,
  required String? codeForAuthorisedFlow,
  required String? codeVerifier,
  required bool cryptoHolderBinding,
  required String? authorization,
  required OIDC4VCIDraftType oidc4vciDraftType,
  required DidKeyType didKeyType,
  required String clientId,
  required String? clientSecret,
  required JWTDecode jwtDecode,
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

  if (preAuthorizedCode != null ||
      (codeForAuthorisedFlow != null && codeVerifier != null)) {
    /// codeForAuthorisedFlow != null
    /// this is second phase flow for authorization_code
    /// first phase is need for the authentication
    ///
    /// preAuthorizedCode != null
    /// this is full phase flow for preAuthorizedCode

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    final index = getIndexValue(isEBSIV3: isEBSIV3, didKeyType: didKeyType);

    final (
      List<dynamic> encodedCredentialOrFutureTokens,
      String? deferredCredentialEndpoint,
      String format,
      OpenIdConfiguration? openIdConfiguration,
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
    );

    for (int i = 0; i < encodedCredentialOrFutureTokens.length; i++) {
      final data = encodedCredentialOrFutureTokens[i];
      final String credentialName = getCredentialData(credential);
      final acceptanceToken = data['acceptance_token'];

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
          jwt: null,
          format: 'jwt_vc',
          image: '',
          shareLink: '',
          pendingInfo: PendingInfo(
            acceptanceToken: acceptanceToken.toString(),
            deferredCredentialEndpoint: deferredCredentialEndpoint,
            format: format,
            url: scannedResponse,
            issuer: issuer,
            requestedAt: DateTime.now(),
          ),
        );
        // insert the credential in the wallet
        await credentialsCubit.insertCredential(
          credential: credentialModel,
          showStatus: false,
          showMessage:
              isLastCall && i + 1 == encodedCredentialOrFutureTokens.length,
          isPendingCredential: true,
        );
      } else {
        await addOIDC4VCCredential(
          encodedCredentialFromOIDC4VC: data,
          credentialsCubit: credentialsCubit,
          issuer: issuer,
          credentialType: credentialName,
          isLastCall:
              isLastCall && i + 1 == encodedCredentialOrFutureTokens.length,
          format: format,
          openIdConfiguration: openIdConfiguration,
          jwtDecode: jwtDecode,
        );
      }
    }
  } else {
    throw Exception();
  }
}
