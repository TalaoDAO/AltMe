import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/oidc4vc/helper_function/flatten_claims_for_display.dart';
import 'package:altme/oidc4vc/helper_function/resolve_issuer_display.dart';
import 'package:altme/oidc4vc/model/credential_acceptance_data.dart';
import 'package:altme/trusted_list/function/is_issuer_trusted.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<void> addOIDC4VCCredential({
  required dynamic encodedCredentialFromOIDC4VC,
  required CredentialsCubit credentialsCubit,
  required String credentialType,
  required bool isLastCall,
  required String format,
  required OpenIdConfiguration? openIdConfiguration,
  required JWTDecode jwtDecode,
  required QRCodeScanCubit qrCodeScanCubit,
  String? credentialIdToBeDeleted,
  String? issuer,
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
      // TODO(hawkbee): Handle this case. mdoc
      throw UnimplementedError();
  }
  final Map<String, dynamic> newCredential = Map<String, dynamic>.from(
    credentialFromOIDC4VC,
  );

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

  if (openIdConfiguration != null) {
    final (Display? displayData, dynamic credentialSupported) = fetchDisplay(
      openIdConfiguration: openIdConfiguration,
      credentialType: credentialType,
      languageCode:
          credentialsCubit.profileCubit.langCubit.state.locale.languageCode,
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
    profileType: qrCodeScanCubit.profileCubit.state.model.profileType,
  );

  final profileModel = credentialsCubit.profileCubit.state.model;
  final languageCode =
      credentialsCubit.profileCubit.langCubit.state.locale.languageCode;
  final fallbackHost = Uri.tryParse(issuer ?? '')?.host ?? issuer ?? '';

  final issuerName = openIdConfiguration != null
      ? resolveIssuerDisplay(
          issuerOpenIdConfiguration: openIdConfiguration,
          locale: languageCode,
          fallbackHost: fallbackHost,
        ).name
      : fallbackHost;

  final isTrusted =
      openIdConfiguration != null &&
      isIssuerTrusted(
        issuerOpenIdConfiguration: openIdConfiguration,
        trustedList: profileModel.trustedList,
        trustedListEnabled:
            profileModel.profileSetting.walletSecurityOptions.trustedList,
      );

  if (credentialIdToBeDeleted != null) {
    ///delete pending dummy credential
    await credentialsCubit.deleteById(
      id: credentialIdToBeDeleted,
      showMessage: false,
    );
  }

  // the blocListener shows the consent screen and inserts the credential
  // itself once the user accepts
  qrCodeScanCubit.showCredentialAcceptance(
    data: CredentialAcceptanceData(
      credentialDisplayName: display?.name ?? credentialType,
      issuerName: issuerName,
      isTrusted: isTrusted,
      claims: flattenClaimsForDisplay(credentialFromOIDC4VC),
      credentialModel: credentialModel,
      showMessage: isLastCall,
      uri: Uri.parse(issuer ?? ''),
    ),
  );
}
