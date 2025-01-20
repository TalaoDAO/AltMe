import 'package:altme/app/app.dart';
import 'package:altme/dashboard/json_viewer/view/json_viewer_page.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/dashboard/qr_code/widget/developer_mode_dialog.dart';
import 'package:altme/l10n/l10n.dart';
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

  if (isDeveloperMode) {
    late String formattedData;
      /// verification case
      final String? requestUri =
          uri.queryParameters['request_uri'];
      final String? request =
          uri.queryParameters['request'];

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
          uri.queryParameters['client_id'],
        );

        url = getUpdatedUrlForSIOPV2OIC4VP(
          uri: uri,
          response: response,
          clientId: clientId.toString(),
        );
      }

      formattedData = await getFormattedStringOIDC4VPSIOPV2(
        url: url,
        client: client,
        response: response,
      );

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

  if (showPrompt) {

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
          ResponseMessage(
            message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
          ),
        );
    return;
  }
}
