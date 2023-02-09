import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:jose/jose.dart';

Future<void> addEbsiCredential(
  dynamic encodedCredentialFromEbsi,
  Uri uri,
  WalletCubit walletCubit,
) async {
  final jws = JsonWebSignature.fromCompactSerialization(
    encodedCredentialFromEbsi['credential'] as String,
  );

  final credentialFromEbsi =
      jws.unverifiedPayload.jsonContent['vc'] as Map<String, dynamic>;
  final Map<String, dynamic> newCredential =
      Map<String, dynamic>.from(credentialFromEbsi);
  newCredential['jwt'] = encodedCredentialFromEbsi['credential'];
  newCredential['credentialPreview'] = credentialFromEbsi;
  final String credentialSchema = uri.queryParameters['credential_type'] ?? '';
  final issuerAndCode = uri.queryParameters['issuer'];
  final issuerAndCodeUri = Uri.parse(issuerAndCode!);
  final issuer =
      '${issuerAndCodeUri.scheme}://${issuerAndCodeUri.authority}${issuerAndCodeUri.path}';

  final CredentialManifest credentialManifest = await getCredentialManifest(
    Dio(),
    issuer,
    credentialSchema,
  );
  if (credentialManifest.outputDescriptors!.isNotEmpty) {
    newCredential['credential_manifest'] = CredentialManifest(
      credentialManifest.id,
      credentialManifest.issuedBy,
      credentialManifest.outputDescriptors,
      credentialManifest.presentationDefinition,
    ).toJson();
  }

  final credentialModel = CredentialModel.copyWithData(
    oldCredentialModel: CredentialModel.fromJson(
      newCredential,
    ),
    newData: credentialFromEbsi,
    activities: [Activity(acquisitionAt: DateTime.now())],
  );
  // insert the credential in the wallet
  await walletCubit.insertCredential(credential: credentialModel);
}
