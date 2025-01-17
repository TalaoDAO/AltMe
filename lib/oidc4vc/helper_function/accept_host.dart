import 'package:altme/app/app.dart';
import 'package:altme/dashboard/json_viewer/view/json_viewer_page.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/dashboard/qr_code/widget/developer_mode_dialog.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<void> oidc4vciAcceptHost({
  required Oidc4vcParameters oidc4vcParameters,
  required BuildContext context,
  required bool isDeveloperMode,
  required DioClient client,
  required bool showPrompt,
  required Issuer approvedIssuer,
}) async {
  final l10n = context.l10n;
  var acceptHost = true;

  if (isDeveloperMode) {
    late String formattedData;
    if (oidc4vcParameters.oidc4vcType != null) {
      /// issuance case
      formattedData = getFormattedStringOIDC4VCI(
        url: oidc4vcParameters.initialUri.toString(),
        oidc4vcParameters: oidc4vcParameters,
      );
    } else {
      /// verification case
      final String? requestUri =
          oidc4vcParameters.initialUri.queryParameters['request_uri'];
      final String? request =
          oidc4vcParameters.initialUri.queryParameters['request'];

      Map<String, dynamic>? response;
      late String url;

      if (requestUri != null || request != null) {
        late dynamic encodedData;

        if (request != null) {
          encodedData = request;
        } else if (requestUri != null) {
          encodedData = await fetchRequestUriPayload(
            url: requestUri,
            client: client,
          );
        }

        response = decodePayload(
          jwtDecode: JWTDecode(),
          token: encodedData as String,
        );

        final clientId = getClientIdForPresentation(
          oidc4vcParameters.initialUri.queryParameters['client_id'],
        );

        url = getUpdatedUrlForSIOPV2OIC4VP(
          uri: oidc4vcParameters.initialUri,
          response: response,
          clientId: clientId.toString(),
        );
      }

      formattedData = await getFormattedStringOIDC4VPSIOPV2(
        url: url,
        client: client,
        response: response,
      );
    }

    LoadingView().hide();
    final bool moveAhead = await showDialog<bool>(
          context: context,
          builder: (_) {
            return DeveloperModeDialog(
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

  /// if dev mode is ON show some dialog to show data

  await handleErrorForOID4VCI(
    oidc4vcParameters: oidc4vcParameters,
  );

  if (showPrompt) {
    /// OIDC4VCI Case

    final String title = l10n.scanPromptHost;

    String subtitle = (approvedIssuer.did.isEmpty)
        ? oidc4vcParameters.initialUri.host
        : '''${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}''';

    subtitle = await getHost(
      uri: oidc4vcParameters.initialUri,
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
              //lock: state.uri!.scheme == 'http',
            );
          },
        ) ??
        false;
  }
  LoadingView().hide();
  if (acceptHost) {
    await context.read<QRCodeScanCubit>().acceptOidc4vci(
          approvedIssuer: approvedIssuer,
          oidc4vcParameters: oidc4vcParameters,
          qrCodeScanCubit: context.read<QRCodeScanCubit>(),
        );
  } else {
    context.read<QRCodeScanCubit>().emitError(
          ResponseMessage(
            message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
          ),
        );
    return;
  }
}
