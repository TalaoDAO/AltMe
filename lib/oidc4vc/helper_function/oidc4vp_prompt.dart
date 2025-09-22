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

  /// Builds the FutureBuilder for prompt content
  static Widget buildPromptContentFutureBuilder(Future<Widget> future) {
    return FutureBuilder<Widget>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return snapshot.data!;
        }
        return const SizedBox.shrink();
      },
    );
  }

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
                      child: Column(
                        children: [
                          TrustedEntityDetails(trustedEntity: trustedEntity!),
                          Oidc4VpPrompt.buildPromptContentFutureBuilder(
                            promptContent,
                          ),
                        ],
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
                  content: Oidc4VpPrompt.buildPromptContentFutureBuilder(
                    promptContent,
                  ),
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
                  content: Oidc4VpPrompt.buildPromptContentFutureBuilder(
                    promptContent,
                  ),
                );
              },
            ) ??
            false;
      }
    }
    final qrCodeScanCubit = context.read<QRCodeScanCubit>();
    if (promptResult) {
      await launchProcess();
    } else {
      qrCodeScanCubit.emitError(
        error: ResponseMessage(
          message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
        ),
      );
    }
  }

  Future<Widget> get promptContent async => const SizedBox.shrink();

  Future<void> launchProcess() async {
    final qrCodeScanCubit = context.read<QRCodeScanCubit>();
    await qrCodeScanCubit.startSIOPV2OIDC4VPProcess(uri);
  }
}
