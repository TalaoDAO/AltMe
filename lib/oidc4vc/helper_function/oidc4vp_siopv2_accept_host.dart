import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/json_viewer/view/json_viewer_page.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/dashboard/qr_code/widget/developer_mode_dialog.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/helper_function/get_payload.dart';
import 'package:altme/oidc4vc/helper_function/oidc4vp_prompt.dart';
import 'package:altme/oidc4vp_transaction/widget/accept_oidc4_vp_transaction_page.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/trusted_list/function/check_issuer_is_trusted.dart';
import 'package:altme/trusted_list/function/check_presentation_is_trusted.dart';
import 'package:altme/trusted_list/function/is_certificate_valid.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';

Future<void> oidc4vpSiopV2AcceptHost({
  required Uri uri,
  required BuildContext context,
  required bool isDeveloperMode,
  required DioClient client,
  required bool showPrompt,
  required Issuer approvedIssuer,
}) async {
  final l10n = context.l10n;

  /// verification case
  final String? requestUri = uri.queryParameters['request_uri'];
  final String? request = uri.queryParameters['request'];
  late dynamic encodedData;
  Map<String, dynamic>? response;

  if (requestUri != null || request != null) {
    encodedData = await getPayload(client, requestUri, request);
    response = decodePayload(
      jwtDecode: JWTDecode(),
      token: encodedData as String,
    );
  }

  if (isDeveloperMode) {
    late String formattedData;

    late String url;

    if (requestUri != null || request != null) {
      final clientId = getClientIdForPresentation(
        uri.queryParameters['client_id'],
      );

      url = getUpdatedUrlForSIOPV2OIC4VP(
        uri: uri,
        response: response!,
        clientId: clientId.toString(),
      );
      formattedData = await getFormattedStringOIDC4VPSIOPV2FromRequest(
        url: url,
        client: client,
        response: response,
      );
    } else if (uri.queryParameters['presentation_definition'] != null ||
        uri.queryParameters['presentation_definition_uri'] != null) {
      final Map<String, dynamic>? presentationDefinition =
          await getPresentationDefinition(uri: uri, client: client);
      final Map<String, dynamic>? clientMetaData = await getClientMetada(
        client: client,
        uri: uri,
      );
      formattedData = getFormattedStringOIDC4VPSIOPV2(
        '',
        uri.queryParameters,
        clientMetaData,
        presentationDefinition,
      );
    } else {
      throw Exception('Invalid Presentation Request');
    }

    LoadingView().hide();
    final bool moveAhead =
        await showDialog<bool>(
          context: context,
          builder: (_) {
            return DeveloperModeDialog(
              uri: uri,
              onDisplay: () async {
                final returnedValue = await Navigator.of(context).push<dynamic>(
                  JsonViewerPage.route(
                    title: l10n.display,
                    data: formattedData,
                  ),
                );

                if (returnedValue != null &&
                    returnedValue is bool &&
                    returnedValue) {
                  Navigator.of(context).pop(true);
                }
                return;
              },
              onSkip: () {
                Navigator.of(context).pop(true);
              },
            );
          },
        ) ??
        true;
    if (!moveAhead) return;
  }
  final profile = context.read<ProfileCubit>().state.model;
  final trustedListEnabled =
      profile.profileSetting.walletSecurityOptions.trustedList;
  final trustedList = profile.trustedList;
  late TrustedEntity? trustedEntity;
  if (trustedListEnabled) {
    try {
      if (trustedList == null) {
        throw Exception('Missing trusted list.');
      }

      // get new issuer open id configuration from signed metadata
      trustedEntity = getEntityFromTrustedList(
        trustedList,
        uri.queryParameters['client_id'],
        TrustedEntityType.verifier,
      );
      if (trustedEntity != null) {
        checkPresentationIsTrusted(
          trustedEntity: trustedEntity,
          encodedPresentation: encodedData as String,
        );
        isCertificateValid(
          trustedEntity: trustedEntity,
          signedMetadata: encodedData,
        );
        // issuer has passed the trusted list checks
      }
    } catch (e) {
      context.read<QRCodeScanCubit>().emitError(error: e);
      return;
    }
  } else {
    trustedEntity = null;
  }
  if (response!.containsKey('transaction_data')) {
    LoadingView().hide();
    unawaited(
      context.read<ScanCubit>().addTransactionData(
        response['transaction_data'] as List<dynamic>,
      ),
    );

    await Navigator.of(context).push<void>(
      AcceptOidc4VpTransactionPage.route(
        trustedListEnabled: trustedListEnabled,
        trustedEntity: trustedEntity,
        uri: uri,
        showPrompt: showPrompt,
        client: client,
      ),
    );
  } else {
    await Oidc4VpPrompt(
      context: context,
      l10n: l10n,
      trustedListEnabled: trustedListEnabled,
      trustedEntity: trustedEntity,
      uri: uri,
      client: client,
      showPrompt: showPrompt,
    ).show();
  }

  // Default action if there is no prompt

  LoadingView().hide();
}
