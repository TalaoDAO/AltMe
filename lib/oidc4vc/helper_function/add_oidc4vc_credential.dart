import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/oidc4vc/helper_function/credential_key_alias.dart';
import 'package:altme/oidc4vc/helper_function/flatten_claims_for_display.dart';
import 'package:altme/oidc4vc/helper_function/mdoc_credential_data.dart';
import 'package:altme/oidc4vc/model/credential_acceptance_data.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';
import 'package:uuid/uuid.dart';

/// Decodes and builds a [CredentialAcceptanceItem] from a fetched OIDC4VCI
/// credential response, without inserting it or showing any confirmation -
/// callers decide when/whether to record it.
///
/// [keyIds] are the keys the request's proofs carried. When they are platform
/// keys, every credential of the response is a copy bound to one of them: the
/// item holds one [CredentialModel] per copy, each with the
/// [CredentialModel.keyId] of its key, and copies of one response share a
/// [CredentialModel.batchId]. A key no credential is bound to is deleted.
/// Otherwise the response holds one credential, bound to the first of
/// [keyIds] if any.
Future<CredentialAcceptanceItem> buildCredentialAcceptanceItem({
  required dynamic encodedCredentialFromOIDC4VC,
  required CredentialsCubit credentialsCubit,
  required String credentialType,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required JWTDecode jwtDecode,
  List<String> keyIds = const [],
  PlatformP256Keys platformKeys = const PlatformP256Keys(),
}) async {
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

  final copies = encodedCredentialFromOIDC4VC is Map
      ? encodedCredentialFromOIDC4VC['credentials']
      : null;
  if (keyIds.isNotEmpty &&
      keyIds.every(isPlatformKeyAlias) &&
      (vcFormatType == VCFormatType.dcSdJWT ||
          vcFormatType == VCFormatType.mdoc) &&
      copies is List) {
    final unusedKeys = [...keyIds];
    final credentialModels = <CredentialModel>[];
    (Object, StackTrace)? firstError;
    for (final copy in copies) {
      final credential = copy is Map ? copy['credential'] : null;
      if (credential is! String) continue;
      final keyId = await boundKeyAlias(
        credential: credential,
        format: format,
        aliases: unusedKeys,
        platformKeys: platformKeys,
      );
      if (keyId == null) continue;
      try {
        final credentialData = await _credentialData(
          encodedCredentialFromOIDC4VC: {
            'credentials': [
              {'credential': credential},
            ],
          },
          vcFormatType: vcFormatType,
          credentialsCubit: credentialsCubit,
          credentialType: credentialType,
          format: format,
          openIdConfiguration: openIdConfiguration,
          jwtDecode: jwtDecode,
          keyId: keyId,
          platformKeys: platformKeys,
        );
        unusedKeys.remove(keyId);
        credentialModels.add(
          await _credentialModel(
            credentialFromOIDC4VC: credentialData,
            credentialsCubit: credentialsCubit,
            credentialType: credentialType,
            format: format,
            openIdConfiguration: openIdConfiguration,
            keyId: keyId,
          ),
        );
      } catch (e, s) {
        firstError ??= (e, s);
      }
    }

    // No credential will ever be bound to these keys.
    for (final keyId in unusedKeys) {
      await platformKeys.delete(keyId);
    }

    if (credentialModels.isEmpty) {
      if (firstError case (final error, final stackTrace)) {
        Error.throwWithStackTrace(error, stackTrace);
      }
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description':
              'No credential is bound to a key sent in the proofs.',
        },
      );
    }

    final batchId = credentialModels.length > 1 ? const Uuid().v4() : null;
    final batch = [
      for (final credentialModel in credentialModels)
        credentialModel.copyWith(batchId: batchId),
    ];
    return CredentialAcceptanceItem(
      credentialDisplayName: batch.first.display?.name ?? credentialType,
      claims: buildTranslatedClaims(
        credentialModel: batch.first,
        languageCode: _languageCode(credentialsCubit),
      ),
      credentialModel: batch.first,
      batchCopies: batch.sublist(1),
    );
  }

  final keyId = keyIds.firstOrNull;
  final credentialData = await _credentialData(
    encodedCredentialFromOIDC4VC: encodedCredentialFromOIDC4VC,
    vcFormatType: vcFormatType,
    credentialsCubit: credentialsCubit,
    credentialType: credentialType,
    format: format,
    openIdConfiguration: openIdConfiguration,
    jwtDecode: jwtDecode,
    keyId: keyId,
    platformKeys: platformKeys,
  );
  final credentialModel = await _credentialModel(
    credentialFromOIDC4VC: credentialData,
    credentialsCubit: credentialsCubit,
    credentialType: credentialType,
    format: format,
    openIdConfiguration: openIdConfiguration,
    keyId: keyId,
  );

  final credentialAcceptanceItem = CredentialAcceptanceItem(
    credentialDisplayName: credentialModel.display?.name ?? credentialType,
    claims: buildTranslatedClaims(
      credentialModel: credentialModel,
      languageCode: _languageCode(credentialsCubit),
    ),
    credentialModel: credentialModel,
  );
  return credentialAcceptanceItem;
}

String _languageCode(CredentialsCubit credentialsCubit) =>
    credentialsCubit.profileCubit.langCubit.state.locale.languageCode;

/// The credential data of the (first) credential of
/// [encodedCredentialFromOIDC4VC], decoded for [vcFormatType].
Future<Map<String, dynamic>> _credentialData({
  required dynamic encodedCredentialFromOIDC4VC,
  required VCFormatType vcFormatType,
  required CredentialsCubit credentialsCubit,
  required String credentialType,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required JWTDecode jwtDecode,
  required String? keyId,
  required PlatformP256Keys platformKeys,
}) async {
  late Map<String, dynamic> credentialFromOIDC4VC;

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
        platformKeys: platformKeys,
        expectedDocType: configuration is Map<String, dynamic>
            ? configuration['doctype'] as String?
            : null,
      );
  }
  return credentialFromOIDC4VC;
}

/// The [CredentialModel] of [credentialFromOIDC4VC], with its display, its
/// credential manifest and the [keyId] of the key it is bound to.
Future<CredentialModel> _credentialModel({
  required Map<String, dynamic> credentialFromOIDC4VC,
  required CredentialsCubit credentialsCubit,
  required String credentialType,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required String? keyId,
}) async {
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
  final languageCode = _languageCode(credentialsCubit);

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

  return credentialModel;
}

/// Used by the deferred-credential path, where exactly one credential is
/// fetched at a time: stores it in place of the pending card
/// [credentialIdToBeDeleted], with the "credential added" message. The user
/// accepted when the offer was scanned, and the credential may arrive while
/// they are on any screen, so no confirmation screen opens.
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
  final item = await buildCredentialAcceptanceItem(
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
      logActivity: false,
    );
  }

  final copies = item.credentialModels;
  for (final credential in copies) {
    await credentialsCubit.insertCredential(
      credential: credential,
      showMessage: credential == copies.last,
      uri: Uri.parse(issuer ?? ''),
    );
  }
}
