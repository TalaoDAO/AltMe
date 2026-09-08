import 'package:altme/app/app.dart';
import 'package:altme/dashboard/json_viewer/view/json_viewer_page.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
import 'package:altme/dashboard/profile/models/profile.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/dashboard/qr_code/widget/developer_mode_dialog.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/helper_function/resolve_issuer_display.dart';
import 'package:altme/oidc4vc/widget/issuer_connect_dialog.dart';
import 'package:altme/trusted_list/function/check_issuer_is_trusted.dart';
import 'package:altme/trusted_list/function/get_issuer_open_id_configuration.dart';
import 'package:altme/trusted_list/function/is_certificate_valid.dart';
import 'package:altme/trusted_list/model/trusted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

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
  final signedMetadata = issuerOpenIdConfiguration.signedMetadata;

  if (signedMetadata != null) {
    updatedOidc4vcParameters = updatedOidc4vcParameters.copyWith(
      issuerOpenIdConfiguration: getIssuerOpenIdConfiguration(
        issuerOpenIdConfiguration: issuerOpenIdConfiguration,
      ),
    );
  }

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

      final trustedEntity = getIssuerFromTrustedList(
        issuerOpenIdConfiguration: issuerOpenIdConfiguration,
        trustedList: trustedList!,
      );
      if (trustedEntity != null) {
        // check if each element of
        // oidc4vcParameters.credentialOffer['credential_configuration_ids'] are
        // in trustedEntity.vcTypes

        final credentialConfigurationIds =
            updatedOidc4vcParameters
                .credentialOffer['credential_configuration_ids'];
        if (credentialConfigurationIds != null &&
            credentialConfigurationIds is List) {
          for (final credentialConfigurationId in credentialConfigurationIds) {
            final vct = issuerOpenIdConfiguration
                // ignore: lines_longer_than_80_chars
                .credentialConfigurationsSupported[credentialConfigurationId]['vct'];
            if (!trustedEntity.vcTypes!.contains(vct)) {
              throw Exception(
                // ignore: lines_longer_than_80_chars
                "$credentialConfigurationId is not in the trusted entity's vcTypes",
              );
            }
          }
        } else {
          throw Exception(
            'credential_configuration_ids from credential offer is not valid',
          );
        }

        isCertificateValid(
          trustedEntity: trustedEntity,
          signedMetadata: signedMetadata!,
        );
        isTrusted = true;
      }
    } catch (e) {
      context.read<QRCodeScanCubit>().emitError(error: e);
      return;
    }
  }

  if (showPrompt || trustedListEnabled) {
    final languageCode = context
        .read<ProfileCubit>()
        .langCubit
        .state
        .locale
        .languageCode;
    final fallbackHost = await getHost(
      uri: updatedOidc4vcParameters.initialUri,
      client: client,
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
