import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:jose/jose.dart';

Future<void> addOIDC4VCCredential(
  dynamic encodedCredentialFromOIDC4VC,
  Uri uri,
  CredentialsCubit credentialsCubit,
  OIDC4VCType oidc4vcType,
  String issuer,
  String credentialTypeOrId,
) async {
  late Map<String, dynamic> credentialFromOIDC4VC;
  if (oidc4vcType.issuerVcType == 'jwt_vc') {
    //jwt_vc_json
    final jws = JsonWebSignature.fromCompactSerialization(
      encodedCredentialFromOIDC4VC['credential'] as String,
    );

    credentialFromOIDC4VC =
        jws.unverifiedPayload.jsonContent['vc'] as Map<String, dynamic>;
  } else if (oidc4vcType.issuerVcType == 'ldp_vc') {
    //ldp_vc

    credentialFromOIDC4VC =
        jsonDecode(encodedCredentialFromOIDC4VC['credential'].toString())
            as Map<String, dynamic>;
  } else {
    throw Exception();
  }

  final Map<String, dynamic> newCredential =
      Map<String, dynamic>.from(credentialFromOIDC4VC);

  if (oidc4vcType.issuerVcType == 'jwt_vc') {
    //jwt_vc_json
    newCredential['jwt'] = encodedCredentialFromOIDC4VC['credential'];
  }

  newCredential['credentialPreview'] = credentialFromOIDC4VC;

  /// added id as type to recognise the card
  newCredential['credentialPreview']['credentialSubject']['type'] =
      credentialFromOIDC4VC['credentialSchema']['id'];

  final CredentialManifest credentialManifest = await getCredentialManifest(
    Dio(),
    issuer,
    credentialTypeOrId,
    oidc4vcType.schemaForType,
  );

  if (credentialManifest.outputDescriptors!.isNotEmpty) {
    newCredential['credential_manifest'] = CredentialManifest(
      credentialManifest.id,
      credentialManifest.issuedBy,
      credentialManifest.outputDescriptors,
      credentialManifest.presentationDefinition,
    ).toJson();
  }

  final newCredentialModel = CredentialModel.fromJson(newCredential);

  final credentialModel = CredentialModel.copyWithData(
    oldCredentialModel: newCredentialModel,
    newData: credentialFromOIDC4VC,
    activities: [Activity(acquisitionAt: DateTime.now())],
  );

  // insert the credential in the wallet
  await credentialsCubit.insertCredential(credential: credentialModel);
}
