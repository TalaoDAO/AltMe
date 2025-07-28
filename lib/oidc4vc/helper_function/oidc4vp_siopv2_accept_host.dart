import 'package:altme/app/app.dart';
import 'package:altme/dashboard/json_viewer/view/json_viewer_page.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/dashboard/qr_code/widget/developer_mode_dialog.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/trusted_list/function/check_issuer_is_trusted.dart';
import 'package:altme/trusted_list/function/check_presentation_is_trusted.dart';
import 'package:altme/trusted_list/function/is_certificate_valid.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:altme/trusted_list/widget/trusted_entity_details.dart';
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
  var acceptHost = true;

  /// verification case
  final String? requestUri = uri.queryParameters['request_uri'];
  final String? request = uri.queryParameters['request'];
  late dynamic encodedData;

  if (requestUri != null || request != null) {
    if (request != null) {
      encodedData = request;
    } else if (requestUri != null) {
      encodedData = await fetchRequestUriPayload(
        url: requestUri,
        client: client,
      );
    }
  }

  if (isDeveloperMode) {
    late String formattedData;

    Map<String, dynamic>? response;
    late String url;

    if (requestUri != null || request != null) {
      response = decodePayload(
        jwtDecode: JWTDecode(),
        token: encodedData as String,
      );

      final clientId = getClientIdForPresentation(
        uri.queryParameters['client_id'],
      );

      url = getUpdatedUrlForSIOPV2OIC4VP(
        uri: uri,
        response: response,
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
    final bool moveAhead = await showDialog<bool>(
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
  if (trustedListEnabled) {
    try {
      if (trustedList == null) {
        throw Exception(
          'Missing trusted list.',
        );
      }

      // get new issuer open id configuration from signed metadata
      final trustedEntity = getEntityFromTrustedList(
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
        // check certificate is trusted

        LoadingView().hide();
        acceptHost = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: ConfirmDialog(
                    title: l10n.scanPromptHost,
                    content: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: SingleChildScrollView(
                        child:
                            TrustedEntityDetails(trustedEntity: trustedEntity),
                      ),
                    ),
                    yes: l10n.communicationHostAllow,
                    no: l10n.communicationHostDeny,
                  ),
                );
              },
            ) ??
            false;
      } else {
        LoadingView().hide();
        acceptHost = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialog(
                  title: l10n.scanPromptHost,
                  subtitle: l10n.notTrustedEntity,
                  yes: l10n.communicationHostAllow,
                  no: l10n.communicationHostDeny,
                  invertedCallToAction: true,
                );
              },
            ) ??
            false;
      }
    } catch (e) {
      context.read<QRCodeScanCubit>().emitError(
            error: e,
          );
      return;
    }
  }

  if (showPrompt && !trustedListEnabled) {
    final String title = l10n.scanPromptHost;

    String subtitle = (approvedIssuer.did.isEmpty)
        ? uri.host
        : '''${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}''';

    subtitle = await getHost(
      uri: uri,
      client: client,
    );

    LoadingView().hide();
    acceptHost = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              title: title,
              subtitle: subtitle,
              yes: l10n.communicationHostAllow,
              no: l10n.communicationHostDeny,
            );
          },
        ) ??
        false;
  }
  LoadingView().hide();
  if (acceptHost) {
    await context.read<QRCodeScanCubit>().startSIOPV2OIDC4VPProcess(uri);
  } else {
    context.read<QRCodeScanCubit>().emitError(
          error: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
          ),
        );
    return;
  }
}
