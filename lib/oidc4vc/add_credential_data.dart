import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

Future<void> addCredentialData({
  required List<dynamic> encodedCredentialOrFutureTokens,
  required String? deferredCredentialEndpoint,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required SecureStorageProvider secureStorageProvider,
  required CredentialsCubit credentialsCubit,
  required String scannedResponse,
  required dynamic credential,
  required String issuer,
  required bool isLastCall,
  required JWTDecode jwtDecode,
  required BlockchainType blockchainType,
}) async {
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
        format: format,
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
        blockchainType: blockchainType,
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
        blockchainType: blockchainType,
      );
    }
  }
}
