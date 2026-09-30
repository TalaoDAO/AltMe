import 'package:altme/app/app.dart';
import 'package:altme/dashboard/json_viewer/view/json_viewer_page.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
import 'package:altme/dashboard/profile/models/profile.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/dashboard/qr_code/widget/developer_mode_dialog.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/helper_function/resolve_issuer_display.dart';
import 'package:altme/oidc4vc/widget/issuer_connect_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:trusted_list/trusted_list.dart';

Future<void> oidc4vciAcceptHost({
  required Oidc4vcParameters oidc4vcParameters,
  required BuildContext context,
  required bool isDeveloperMode,
  required DioClient client,
  required bool showPrompt,
  required Issuer approvedIssuer,
}) async {
  var updatedOidc4vcParameters = oidc4vcParameters;
  final l10n = context.l10n;
  final oidc4vc = context.read<QRCodeScanCubit>().oidc4vc;
  var acceptHost = true;

  if (isDeveloperMode) {
    /// issuance case
    final formattedData = getFormattedStringOIDC4VCI(
      url: updatedOidc4vcParameters.initialUri.toString(),
      oidc4vcParameters: updatedOidc4vcParameters,
    );

    LoadingView().hide();
    final bool moveAhead =
        await showDialog<bool>(
          context: context,
          builder: (_) {
            return DeveloperModeDialog(
              uri: updatedOidc4vcParameters.initialUri,
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
  await handleErrorForOidc4Vci(
    oidc4vcParameters: updatedOidc4vcParameters,
    didKeyType: context
        .read<ProfileCubit>()
        .state
        .model
        .profileSetting
        .selfSovereignIdentityOptions
        .customOidc4vcProfile
        .defaultDid,
    clientType: context
        .read<ProfileCubit>()
        .state
        .model
        .profileSetting
        .selfSovereignIdentityOptions
        .customOidc4vcProfile
        .clientType,
  );
  ProfileModel profile = context.read<ProfileCubit>().state.model;
  final trustedListEnabled =
      profile.profileSetting.walletSecurityOptions.trustedList;
  final trustedListUrl =
      profile.profileSetting.walletSecurityOptions.trustedListUrl ??
      Parameters.trustedListUrl;
  TrustedList? trustedList = profile.trustedList;

  // issuer open id configuration from signed metadata is used instead of
  // unsigned open id configuration, when available
  final issuerOpenIdConfiguration =
      updatedOidc4vcParameters.issuerOpenIdConfiguration;

  var isTrusted = false;

  if (trustedListEnabled) {
    try {
      if (trustedList == null) {
        profile = await context.read<ProfileCubit>().addTrustedList(
          trustedListUrl,
          profile,
        );
        trustedList = profile.trustedList;
      }
      // Looked up before the metadata is replaced below: up to draft16 the
      // issuer's certificate chain travels in the header of its
      // `signed_metadata` JWT, which the payload replacing it drops.
      //
      // A null entry is the verdict "not trusted", not an error - the
      // issuer may be unlisted, registered for another role, unable to
      // prove its chain against a listed root, or not registered for the
      // credentials it is offering. The client generation knows which of
      // those it has to check.
      isTrusted =
          oidc4vc.findTrustedIssuer(
            trustedList: trustedList!,
            issuerOpenIdConfiguration: issuerOpenIdConfiguration,
            vcTypes: oidc4vc.offeredVcTypes(updatedOidc4vcParameters),
          ) !=
          null;

      updatedOidc4vcParameters = updatedOidc4vcParameters.copyWith(
        issuerOpenIdConfiguration: oidc4vc.resolveIssuerMetadata(
          issuerOpenIdConfiguration,
        ),
      );
    } catch (e) {
      context.read<QRCodeScanCubit>().emitError(error: e);
      return;
    }
  }

  // Cache the result: it's a cryptographic check against every trusted
  // -list entry, and later screens (e.g. the credential pick page) would
  // otherwise recompute it from scratch for the same issuer.
  updatedOidc4vcParameters = updatedOidc4vcParameters.copyWith(
    isIssuerTrusted: isTrusted,
  );

  if (showPrompt || trustedListEnabled) {
    final languageCode = context
        .read<ProfileCubit>()
        .langCubit
        .state
        .locale
        .languageCode;
    // the credential offer has already been fetched by getIssuanceData, don't
    // fetch it again just to get the issuer host.
    final issuerHost = Uri.tryParse(updatedOidc4vcParameters.issuer)?.host;
    final fallbackHost = (issuerHost != null && issuerHost.isNotEmpty)
        ? issuerHost
        : await getHost(
            uri: updatedOidc4vcParameters.initialUri,
            client: client,
            oidc4vc: oidc4vc,
          );

    final issuerDisplay = resolveIssuerDisplay(
      issuerOpenIdConfiguration: issuerOpenIdConfiguration,
      locale: languageCode,
      fallbackHost: fallbackHost,
    );

    final credentialDisplayName = resolveOfferedCredentialDisplayName(
      oidc4vcParameters: updatedOidc4vcParameters,
      languageCode: languageCode,
    );

    LoadingView().hide();
    acceptHost = await IssuerConnectDialog.show(
      context: context,
      issuerName: issuerDisplay.name,
      logoUri: issuerDisplay.logoUri,
      isTrusted: isTrusted,
      credentialDisplayName: credentialDisplayName,
    );
  }
  LoadingView().hide();
  if (acceptHost) {
    await context.read<QRCodeScanCubit>().acceptOidc4vci(
      approvedIssuer: approvedIssuer,
      oidc4vcParameters: updatedOidc4vcParameters,
      qrCodeScanCubit: context.read<QRCodeScanCubit>(),
    );
  } else {
    context.read<QRCodeScanCubit>().emitError(
      error: ResponseMessage(
        message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
      ),
    );
    return;
  }
}
