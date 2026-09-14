import 'package:altme/app/app.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/helper_function/resolve_verifier_display.dart';
import 'package:altme/oidc4vc/model/verifier_trust_info.dart';
import 'package:altme/oidc4vc/widget/verifier_connect_dialog.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
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
    this.jwtHeader,
    this.purpose,
  });

  final BuildContext context;
  final AppLocalizations l10n;
  final bool trustedListEnabled;
  final TrustedEntity? trustedEntity;
  final Uri uri;
  final DioClient client;
  final bool showPrompt;
  final Map<String, dynamic>? jwtHeader;
  final String? purpose;

  VerifierTrustInfo? _verifierTrustInfo;

  Future<void> show() async {
    LoadingView().hide();
    late bool promptResult;

    if (showPrompt || trustedListEnabled) {
      final fallbackHost = await getHost(uri: uri, client: client);
      final verifierDisplay = resolveVerifierDisplay(
        jwtHeader: jwtHeader,
        trustedEntity: trustedEntity,
        fallbackHost: fallbackHost,
      );

      final isTrusted = trustedListEnabled && trustedEntity != null;

      _verifierTrustInfo = VerifierTrustInfo(
        name: verifierDisplay.name,
        isTrusted: isTrusted,
        purpose: purpose,
      );

      promptResult = await VerifierConnectDialog.show(
        context: context,
        verifierName: verifierDisplay.name,
        isTrusted: isTrusted,
        purpose: purpose,
      );
    } else {
      promptResult = true;
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

  Future<void> launchProcess() async {
    final qrCodeScanCubit = context.read<QRCodeScanCubit>();
    await qrCodeScanCubit.startSIOPV2OIDC4VPProcess(
      uri,
      verifierTrustInfo: _verifierTrustInfo,
    );
  }
}
