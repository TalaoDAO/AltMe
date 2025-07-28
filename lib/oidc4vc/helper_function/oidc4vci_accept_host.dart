import 'package:altme/app/app.dart';
import 'package:altme/dashboard/json_viewer/view/json_viewer_page.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/dashboard/qr_code/widget/developer_mode_dialog.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/trusted_list/function/check_issuer_is_trusted.dart';
import 'package:altme/trusted_list/function/get_issuer_open_id_configuration.dart';
import 'package:altme/trusted_list/function/is_certificate_valid.dart';
import 'package:altme/trusted_list/widget/trusted_entity_details.dart';
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
  final l10n = context.l10n;
  var acceptHost = true;

  if (isDeveloperMode) {
    /// issuance case
    final formattedData = getFormattedStringOIDC4VCI(
      url: oidc4vcParameters.initialUri.toString(),
      oidc4vcParameters: oidc4vcParameters,
    );

    LoadingView().hide();
    final bool moveAhead = await showDialog<bool>(
          context: context,
          builder: (_) {
            return DeveloperModeDialog(
              uri: oidc4vcParameters.initialUri,
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
    oidc4vcParameters: oidc4vcParameters,
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
      // issuer open id configuration from signed metadata is used instead of
      // unsigned open id configuration

      final signedMetadata =
          oidc4vcParameters.issuerOpenIdConfiguration.signedMetadata;

      oidc4vcParameters = oidc4vcParameters.copyWith(
        issuerOpenIdConfiguration: getIssuerOpenIdConfiguration(
          issuerOpenIdConfiguration:
              oidc4vcParameters.issuerOpenIdConfiguration,
        ),
      );

      // get new issuer open id configuration from signed metadata
      final trustedEntity = getIssuerFromTrustedList(
        issuerOpenIdConfiguration: oidc4vcParameters.issuerOpenIdConfiguration,
        trustedList: trustedList,
      );
      if (trustedEntity != null) {
        // check if each element of
        // oidc4vcParameters.credentialOffer['credential_configuration_ids'] are
        // in trustedEntity.vcTypes

        final credentialConfigurationIds =
            oidc4vcParameters.credentialOffer['credential_configuration_ids'];
        if (credentialConfigurationIds != null &&
            credentialConfigurationIds is List) {
          for (final credentialConfigurationId in credentialConfigurationIds) {
            if (!trustedEntity.vcTypes!.contains(
              oidc4vcParameters.issuerOpenIdConfiguration
                      .credentialConfigurationsSupported[
                  credentialConfigurationId]['vct'],
            )) {
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
        // check certificate is trusted

        LoadingView().hide();
        acceptHost = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialog(
                  title: l10n.scanPromptHost,
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: TrustedEntityDetails(trustedEntity: trustedEntity),
                    ),
                  ),
                  yes: l10n.communicationHostAllow,
                  no: l10n.communicationHostDeny,
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
          error: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
          ),
        );
    return;
  }
}
