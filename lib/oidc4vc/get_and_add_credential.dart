import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

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
  required String? preAuthorizedCode,
  required String issuer,
  required String? codeForAuthorisedFlow,
  required String? codeVerifier,
}) async {
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

  if (preAuthorizedCode != null ||
      (codeForAuthorisedFlow != null && codeVerifier != null)) {
    /// codeForAuthorisedFlow != null
    /// this is second phase flow for authorization_code
    /// first phase is need for the authentication
    ///
    /// preAuthorizedCode != null
    /// this is full phase flow for preAuthorizedCode
    final (
      List<dynamic> encodedCredentialOrFutureTokens,
      String? deferredCredentialEndpoint,
      String format
    ) = await oidc4vc.getCredential(
      preAuthorizedCode: preAuthorizedCode,
      issuer: issuer,
      credential: credential,
      did: did,
      kid: kid,
      privateKey: privateKey,
      indexValue: oidc4vcType.indexValue,
      userPin: userPin,
      code: codeForAuthorisedFlow,
      codeVerifier: codeVerifier,
      isEBSIV2: oidc4vcType.isEBSIV2,
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
          showMessage:
              isLastCall && i + 1 == encodedCredentialOrFutureTokens.length,
          isPendingCredential: true,
        );
      } else {
        await addOIDC4VCCredential(
          encodedCredentialFromOIDC4VC: data,
          credentialsCubit: credentialsCubit,
          oidc4vcType: oidc4vcType,
          issuer: issuer,
          credentialType: credentialName,
          isLastCall:
              isLastCall && i + 1 == encodedCredentialOrFutureTokens.length,
          format: format,
        );
      }
    }
  } else {
    throw Exception();
  }
}
