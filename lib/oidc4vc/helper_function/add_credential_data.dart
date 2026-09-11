import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/oidc4vc/model/credential_acceptance_data.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Builds a [CredentialAcceptanceItem] for every fetched, non-deferred token
/// in [encodedCredentialOrFutureTokens] - a token that fails to decode is
/// skipped rather than aborting the others. Deferred/pending tokens are
/// still inserted immediately as placeholder cards, since there's nothing
/// to review yet.
Future<List<CredentialAcceptanceItem>> addCredentialData({
  required List<dynamic> encodedCredentialOrFutureTokens,
  required String accessToken,
  required String? deferredCredentialEndpoint,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required SecureStorageProvider secureStorageProvider,
  required CredentialsCubit credentialsCubit,
  required String scannedResponse,
  required dynamic credential,
  required String issuer,
  required JWTDecode jwtDecode,
  required QRCodeScanCubit qrCodeScanCubit,
}) async {
  final profileModel = credentialsCubit.profileCubit.state.model;
  final items = <CredentialAcceptanceItem>[];

  for (int i = 0; i < encodedCredentialOrFutureTokens.length; i++) {
    final data = encodedCredentialOrFutureTokens[i];
    final String credentialName = getCredentialData(credential);

    final acceptanceToken = data['acceptance_token'];

    /// trasanction_id is NEW for draft 13. it was acceptance_token for draft 11
    final transactionId = data['transaction_id'];

    if ((acceptanceToken != null || transactionId != null) &&
        deferredCredentialEndpoint != null) {
      /// add deferred card
      final id = const Uuid().v4();

      if (data is! Map<String, dynamic>) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_format',
            'error_description': 'The format of credential data should be Map.',
          },
        );
      }

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
          encodedCredentialFromOIDC4VC: data,
          accessToken: accessToken,
          deferredCredentialEndpoint: deferredCredentialEndpoint,
          format: format,
          url: scannedResponse,
          issuer: issuer,
          requestedAt: DateTime.now(),
        ),
        profileLinkedId: profileModel.profileType.getVCId,
      );
      // insert the pending placeholder immediately - nothing to review yet
      await credentialsCubit.insertCredential(
        credential: credentialModel,
        showMessage: false,
        isPendingCredential: true,
        uri: Uri.parse(issuer),
      );
    } else {
      try {
        final item = await buildCredentialAcceptanceItem(
          encodedCredentialFromOIDC4VC: data,
          credentialsCubit: credentialsCubit,
          credentialType: credentialName,
          format: format,
          openIdConfiguration: openIdConfiguration,
          jwtDecode: jwtDecode,
        );
        items.add(item);
      } catch (_) {
        // skip credentials that fail to fetch/decode rather than blocking
        // the others
      }
    }
  }

  return items;
}
