import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:uuid/uuid.dart';

Future<void> addOIDC4VCCredential({
  required dynamic encodedCredentialFromOIDC4VC,
  required CredentialsCubit credentialsCubit,
  required String credentialType,
  required bool isLastCall,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required JWTDecode jwtDecode,
  String? credentialIdToBeDeleted,
  String? issuer,
}) async {
  late Map<String, dynamic> credentialFromOIDC4VC;

  if (format == 'jwt_vc' || format == 'jwt_vc_json' || format == 'vc+sd-jwt') {
    //jwt_vc
    final data = encodedCredentialFromOIDC4VC['credential'] as String;

    final jsonContent = jwtDecode.parseJwt(data);

    if (format == 'vc+sd-jwt') {
      credentialFromOIDC4VC = jsonContent;
    } else {
      credentialFromOIDC4VC = jsonContent['vc'] as Map<String, dynamic>;
    }

    if (format == 'vc+sd-jwt') {
      /// type
      if (!credentialFromOIDC4VC.containsKey('type')) {
        credentialFromOIDC4VC['type'] = [credentialType];
      }

      ///credentialSubject
      if (!credentialFromOIDC4VC.containsKey('credentialSubject')) {
        credentialFromOIDC4VC['credentialSubject'] = {'type': credentialType};
      }
    }

    /// id -> jti
    if (!credentialFromOIDC4VC.containsKey('id')) {
      if (jsonContent.containsKey('jti')) {
        credentialFromOIDC4VC['id'] = jsonContent['jti'];
      } else {
        credentialFromOIDC4VC['id'] = 'urn:uuid:${const Uuid().v4()}';
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
      } else if (jsonContent.containsKey('issuanceDate')) {
        credentialFromOIDC4VC['issuanceDate'] =
            jsonContent['issuanceDate'].toString();
      }
    }

    /// expirationDate -> exp
    if (!credentialFromOIDC4VC.containsKey('expirationDate')) {
      if (jsonContent.containsKey('exp')) {
        credentialFromOIDC4VC['expirationDate'] = jsonContent['exp'].toString();
      } else if (jsonContent.containsKey('expirationDate')) {
        credentialFromOIDC4VC['expirationDate'] =
            jsonContent['expirationDate'].toString();
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

    credentialFromOIDC4VC['jwt'] = data;
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
    final openidConfigurationJson =
        jsonDecode(jsonEncode(openIdConfiguration)) as Map<String, dynamic>;
    final CredentialManifest? credentialManifest = await getCredentialManifest(
      openidConfigurationJson: openidConfigurationJson,
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

  Display? display;

  if (openIdConfiguration?.credentialsSupported != null) {
    final credentialsSupported = openIdConfiguration!.credentialsSupported!;
    final CredentialsSupported? credSupported =
        credentialsSupported.firstWhereOrNull(
      (CredentialsSupported credentialsSupported) =>
          credentialsSupported.id != null &&
          credentialsSupported.id == credentialType,
    );

    if (credSupported != null) {
      newCredential['credentialSupported'] = credSupported.toJson();

      if (credSupported.display != null) {
        display = credSupported.display!.firstWhereOrNull(
          (Display display) =>
              display.locale == 'en-US' || display.locale == 'en-GB',
        );
      }
    }
  } else if (openIdConfiguration?.credentialConfigurationsSupported != null) {
    final credentialsSupported =
        openIdConfiguration!.credentialConfigurationsSupported;

    if ((credentialsSupported is Map<String, dynamic>) &&
        credentialsSupported.containsKey(credentialType)) {
      final credSupported = credentialsSupported[credentialType];

      /// credentialSupported
      newCredential['credentialSupported'] = credSupported;

      if (credSupported is Map<String, dynamic>) {
        /// display
        if (credSupported.containsKey('display')) {
          final displayData = credSupported['display'];

          if (displayData is List<dynamic>) {
            final displays = displayData
                .map((ele) => Display.fromJson(ele as Map<String, dynamic>))
                .toList();

            display = displays.firstWhereOrNull(
              (Display display) =>
                  display.locale == 'en-US' || display.locale == 'en-GB',
            );
          }
        }
      }
    }
  }

  final newCredentialModel = CredentialModel.fromJson(newCredential);

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
