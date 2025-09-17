import 'package:altme/app/app.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/widget/host_prompt_handler.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:altme/trusted_list/widget/trusted_entity_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Oidc4VpPrompt {
  Oidc4VpPrompt({
    required this.context,
    required this.l10n,
    required this.trustedListEnabled,
    required this.trustedEntity,
    required this.uri,
    required this.client,
    required this.showPrompt,
  });
  final BuildContext context;
  final AppLocalizations l10n;
  final bool trustedListEnabled;
  final TrustedEntity? trustedEntity;
  final Uri uri;
  final DioClient client;
  final bool showPrompt;

  Future<void> show() async {
    LoadingView().hide();
    late bool promptResult;
    if (trustedListEnabled) {
      if (trustedEntity != null) {
        promptResult =
            await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return HostPromptHandler(
                  title: l10n.scanPromptHost,
                  content: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: SingleChildScrollView(
                      child: TrustedEntityDetails(
                        trustedEntity: trustedEntity!,
                      ),
                    ),
                  ),
                  yesLabel: l10n.communicationHostAllow,
                  noLabel: l10n.communicationHostDeny,
                );
              },
            ) ??
            false;
      } else {
        promptResult =
            await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return HostPromptHandler(
                  title: l10n.scanPromptHost,
                  subtitle: l10n.notTrustedEntity,
                  yesLabel: l10n.communicationHostAllow,
                  noLabel: l10n.communicationHostDeny,
                  invertedCallToAction: true,
                );
              },
            ) ??
            false;
      }
    } else {
      if (showPrompt) {
        final String title = l10n.scanPromptHost;
        final String subtitle = await getHost(uri: uri, client: client);
        promptResult =
            await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return HostPromptHandler(
                  title: title,
                  subtitle: subtitle,
                  yesLabel: l10n.communicationHostAllow,
                  noLabel: l10n.communicationHostDeny,
                );
              },
            ) ??
            false;
      }
    }
    final qrCodeScanCubit = context.read<QRCodeScanCubit>();
    if(promptResult){
    await qrCodeScanCubit.startSIOPV2OIDC4VPProcess(uri);
    Navigator.of(context).pop(true);
    } else {
          qrCodeScanCubit.emitError(
      error: ResponseMessage(
        message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
      ),
    );
    Navigator.of(context).pop(false);

    }
  }

}
