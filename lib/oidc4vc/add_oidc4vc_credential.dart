import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:jose/jose.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<void> addOIDC4VCCredential({
  required dynamic encodedCredentialFromOIDC4VC,
  required CredentialsCubit credentialsCubit,
  String? issuer,
  required String credentialType,
  required bool isLastCall,
  required String format,
  String? credentialIdToBeDeleted,
  required OpenIdConfiguration? openIdConfiguration,
}) async {
  late Map<String, dynamic> credentialFromOIDC4VC;

  if (format == 'jwt_vc' || format == 'jwt_vc_json') {
    //jwt_vc
    final jws = JsonWebSignature.fromCompactSerialization(
      encodedCredentialFromOIDC4VC['credential'] as String,
    );

    final jsonContent =
        jws.unverifiedPayload.jsonContent as Map<String, dynamic>;

    credentialFromOIDC4VC = jsonContent['vc'] as Map<String, dynamic>;

    /// id -> jti
    if (!credentialFromOIDC4VC.containsKey('id')) {
      if (jsonContent.containsKey('jti')) {
        credentialFromOIDC4VC['id'] = jsonContent['jti'];
      } else {
        throw ResponseMessage(
          data: {
            'error': 'unsupported_format',
            'error_description': 'Id is missing',
          },
        );
      }
    }

    /// issuer -> iss
    if (!credentialFromOIDC4VC.containsKey('issuer')) {
      if (jsonContent.containsKey('iss')) {
        credentialFromOIDC4VC['issuer'] = jsonContent['iss'];
      } else {
        throw ResponseMessage(
          data: {
            'error': 'unsupported_format',
            'error_description': 'Issuer is missing',
          },
        );
      }
    }

    /// issuanceDate -> iat
    if (!credentialFromOIDC4VC.containsKey('issuanceDate')) {
      if (jsonContent.containsKey('iat')) {
        credentialFromOIDC4VC['issuanceDate'] = jsonContent['iat'].toString();
      } else {
        throw ResponseMessage(
          data: {
            'error': 'unsupported_format',
            'error_description': 'Issuance date is missing',
          },
        );
      }
    }

    /// expirationDate -> exp
    if (!credentialFromOIDC4VC.containsKey('expirationDate')) {
      if (jsonContent.containsKey('exp')) {
        credentialFromOIDC4VC['expirationDate'] = jsonContent['exp'].toString();
      } else {
        throw ResponseMessage(
          data: {
            'error': 'unsupported_format',
            'error_description': 'Expiration date is missing',
          },
        );
      }
    }

    /// cred,tailSubject.id -> sub

    // if (newCredential['id'] == null) {
    //   newCredential['id'] = 'urn:uuid:${const Uuid().v4()}';
    // }

    // if (newCredential['credentialPreview']['id'] == null) {
    //   newCredential['credentialPreview']['id'] =
    //       'urn:uuid:${const Uuid().v4()}';
    // }

    credentialFromOIDC4VC['jwt'] = encodedCredentialFromOIDC4VC['credential'];
  } else if (format == 'ldp_vc') {
    //ldp_vc

    final data = encodedCredentialFromOIDC4VC['credential'];

    credentialFromOIDC4VC = data is Map<String, dynamic>
        ? data
        : jsonDecode(encodedCredentialFromOIDC4VC['credential'].toString())
            as Map<String, dynamic>;
  } else {
    throw Exception();
  }

  final Map<String, dynamic> newCredential =
      Map<String, dynamic>.from(credentialFromOIDC4VC);

  newCredential['format'] = format;
  newCredential['credentialPreview'] = credentialFromOIDC4VC;

  // if(newCredential['credentialPreview']['credentialSubject']['type']==null) {
  //   /// added id as type to recognise the card
  //   /// for ebsiv2 only
  //   newCredential['credentialPreview']['credentialSubject']['type'] =
  //       credentialFromOIDC4VC['credentialSchema']['id'];
  // }

  if (openIdConfiguration != null) {
    final CredentialManifest? credentialManifest = await getCredentialManifest(
      openidConfigurationJson: openIdConfiguration.toJson(),
      credentialType: credentialType,
    );

    if (credentialManifest?.outputDescriptors?.isNotEmpty ?? false) {
      newCredential['credential_manifest'] = CredentialManifest(
        credentialManifest!.id,
        credentialManifest.issuedBy,
        credentialManifest.outputDescriptors,
        credentialManifest.presentationDefinition,
      ).toJson();
    }
  }

  final newCredentialModel = CredentialModel.fromJson(newCredential);

  Display? display;

  if (newCredentialModel.credentialManifest == null &&
      openIdConfiguration?.credentialsSupported != null) {
    final credentialsSupported = openIdConfiguration!.credentialsSupported!;
    final CredentialsSupported? credSupported =
        credentialsSupported.firstWhereOrNull(
      (CredentialsSupported credentialsSupported) =>
          credentialsSupported.id != null &&
          credentialsSupported.id == credentialType,
    );

    if (credSupported != null) {
      final displayJson = jsonDecode(jsonEncode(credSupported.display));

      final name = JsonPath(r'$..name').read(displayJson).firstOrNull;

      final description =
          JsonPath(r'$..description').read(displayJson).firstOrNull;

      final bgColor =
          JsonPath(r'$..background_color').read(displayJson).firstOrNull;

      final textColor =
          JsonPath(r'$..text_color').read(displayJson).firstOrNull;

      display = Display(
        name?.value.toString() ?? '',
        description?.value.toString() ?? '',
        bgColor?.value.toString() ?? '',
        textColor?.value.toString() ?? '',
        '',
      );
    }
  }

  final credentialModel = CredentialModel.copyWithData(
    oldCredentialModel: newCredentialModel,
    newData: credentialFromOIDC4VC,
    activities: [Activity(acquisitionAt: DateTime.now())],
    display: display,
  );

  if (credentialIdToBeDeleted != null) {
    ///delete pending dummy credential
    await credentialsCubit.deleteById(
      id: credentialIdToBeDeleted,
      showMessage: false,
    );
  }

  // insert the credential in the wallet
  await credentialsCubit.insertCredential(
    credential: credentialModel,
    showStatus: false,
    showMessage: isLastCall,
  );
}
