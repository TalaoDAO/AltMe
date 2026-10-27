import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/oidc4vc/helper_function/flatten_claims_for_display.dart';
import 'package:altme/oidc4vc/helper_function/mdoc_credential_data.dart';
import 'package:altme/oidc4vc/model/credential_acceptance_data.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// Decodes and builds a [CredentialAcceptanceItem] from a fetched OIDC4VCI
/// credential response, without inserting it or showing any confirmation -
/// callers decide when/whether to record it.
Future<CredentialAcceptanceItem> buildCredentialAcceptanceItem({
  required dynamic encodedCredentialFromOIDC4VC,
  required CredentialsCubit credentialsCubit,
  required String credentialType,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required JWTDecode jwtDecode,
  String? keyId,
}) async {
  late Map<String, dynamic> credentialFromOIDC4VC;
  late VCFormatType vcFormatType;

  try {
    vcFormatType = getVcFormatType(format);
  } on Exception catch (_) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description': 'The format of vc is incorrect.',
      },
    );
  }

  switch (vcFormatType) {
    case VCFormatType.jwtVc:
    case VCFormatType.jwtVcJson:
    case VCFormatType.vcSdJWT:
    case VCFormatType.jwtVcJsonLd:
      //jwt_vc
      final data = encodedCredentialFromOIDC4VC['credential'] as String;
      credentialFromOIDC4VC = getCredentialDataFromJson(
        data: data,
        format: format,
        jwtDecode: jwtDecode,
        credentialType: credentialType,
      );

    case VCFormatType.ldpVc:
      //ldp_vc
      final data = encodedCredentialFromOIDC4VC['credential'];
      credentialFromOIDC4VC = data is Map<String, dynamic>
          ? data
          : jsonDecode(encodedCredentialFromOIDC4VC['credential'].toString())
                as Map<String, dynamic>;

    case VCFormatType.auto:
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': "The format 'auto' of vc is incorrect.",
        },
      );
    case VCFormatType.dcSdJWT:
      // Check if OIDC4VCI Draft 15 or above is used. If not then throw an error
      if (int.parse(
            credentialsCubit
                .profileCubit
                .state
                .model
                .profileSetting
                .selfSovereignIdentityOptions
                .customOidc4vcProfile
                .oidc4vciDraft
                .numbering,
          ) <
          15) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_format',
            'error_description':
                // ignore: lines_longer_than_80_chars
                'The format of vc is incorrect. OIDC4VCI Draft 15 or above is required.',
          },
        );
      }

      // get the array of credentials from ['credentials'] key
      final data = encodedCredentialFromOIDC4VC['credentials'] as List<dynamic>;
      if (data.isEmpty) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_format',
            'error_description': 'The format of vc is incorrect.',
          },
        );
      }
      credentialFromOIDC4VC = getCredentialDataFromJson(
        data: data.first['credential'] as String,
        format: format,
        jwtDecode: jwtDecode,
        credentialType: credentialType,
      );
    case VCFormatType.mdoc:
      // final / draft15+: `credentials: [{credential}]`; draft13: `credential`.
      final credentials = encodedCredentialFromOIDC4VC['credentials'];
      final issuerSigned = credentials is List && credentials.isNotEmpty
          ? credentials.first['credential']
          : encodedCredentialFromOIDC4VC['credential'];
      if (issuerSigned is! String) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_format',
            'error_description': 'The format of vc is incorrect.',
          },
        );
      }
      // The docType the issuer offered for this credential configuration.
      final configurations =
          openIdConfiguration?.credentialConfigurationsSupported;
      final configuration = configurations is Map<String, dynamic>
          ? configurations[credentialType]
          : null;
      credentialFromOIDC4VC = await getMdocCredentialData(
        issuerSigned: issuerSigned,
        credentialType: credentialType,
        keyId: keyId,
        expectedDocType: configuration is Map<String, dynamic>
            ? configuration['doctype'] as String?
            : null,
      );
  }
  final Map<String, dynamic> newCredential = Map<String, dynamic>.from(
    credentialFromOIDC4VC,
  );

  newCredential['format'] = format;
  newCredential['credentialPreview'] = credentialFromOIDC4VC;

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
  final languageCode =
      credentialsCubit.profileCubit.langCubit.state.locale.languageCode;

  if (openIdConfiguration != null) {
    final (Display? displayData, dynamic credentialSupported) = fetchDisplay(
      openIdConfiguration: openIdConfiguration,
      credentialType: credentialType,
      languageCode: languageCode,
    );
    display = displayData;
    newCredential['credentialSupported'] = credentialSupported;
  }

  final newCredentialModel = CredentialModel.fromJson(newCredential);

  final credentialModel = CredentialModel.copyWithData(
    oldCredentialModel: newCredentialModel,
    newData: credentialFromOIDC4VC,
    activities: [Activity(acquisitionAt: DateTime.now())],
    display: display,
    profileType: credentialsCubit.profileCubit.state.model.profileType,
  ).copyWith(keyId: keyId);

  final credentialAcceptanceItem = CredentialAcceptanceItem(
    credentialDisplayName: display?.name ?? credentialType,
    claims: buildTranslatedClaims(
      credentialModel: credentialModel,
      languageCode: languageCode,
    ),
    credentialModel: credentialModel,
  );
  return credentialAcceptanceItem;
}

/// Used by the deferred-credential path, where exactly one credential is
/// fetched at a time: builds it and triggers the same confirmation screen
/// (with a single item) as the main issuance flow.
Future<void> addOIDC4VCCredential({
  required dynamic encodedCredentialFromOIDC4VC,
  required CredentialsCubit credentialsCubit,
  required String credentialType,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required JWTDecode jwtDecode,
  required QRCodeScanCubit qrCodeScanCubit,
  String? credentialIdToBeDeleted,
  String? issuer,
}) async {
  // Rejects a credential the wallet cannot read.
  await buildCredentialAcceptanceItem(
    encodedCredentialFromOIDC4VC: encodedCredentialFromOIDC4VC,
    credentialsCubit: credentialsCubit,
    credentialType: credentialType,
    format: format,
    openIdConfiguration: openIdConfiguration,
    jwtDecode: jwtDecode,
  );

  if (credentialIdToBeDeleted != null) {
    ///delete pending dummy credential
    await credentialsCubit.deleteById(
      id: credentialIdToBeDeleted,
      showMessage: false,
    );
  }
  // TODO(hawkbee): Pick the old process for defered credential.
  // the pick page inserts the credential itself once the user accepts.
  // It needs the item built above, the issuer's display name
  // (resolveIssuerDisplay) and whether the trusted list names the issuer
  // (oidc4vc.findTrustedIssuer), as computed before commit 63509c0b7.
  // qrCodeScanCubit.navigateToOidc4vcCredentialPickPage(
  //   items: [item],
  //   issuerName: issuerName,
  //   isTrusted: isTrusted,
  //   uri: Uri.parse(issuer ?? ''),
  // );
}
