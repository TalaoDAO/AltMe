import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class Oidc4vcSettingMenu extends StatelessWidget {
  const Oidc4vcSettingMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/Oidc4vcSettingMenu'),
      builder: (_) => const Oidc4vcSettingMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Oidc4vcSettingMenuView();
  }
}

class Oidc4vcSettingMenuView extends StatelessWidget {
  const Oidc4vcSettingMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.oidc4vc_settings,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      titleLeading: const BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SecurityLevelWidget(),
          const DidKeyTypeWidget(),
          const DraftTypeWidget(),
          const CredentialManifestSupportWidget(),
          const CryptographicHolderBindingWidget(),
          const ScopeParameterWidget(),
          const ClientAuthenticationWidget(),
          const ClientTypeWidget(),
          const ClientCredentialsWidget(),
          const VCFormatWidget(),
          const ProofHeaderWidget(),
          DrawerItem(
            title: l10n.clientMetadata,
            onTap: () {
              final tokenEndpointAuthMethod = context
                  .read<ProfileCubit>()
                  .state
                  .model
                  .profileSetting
                  .selfSovereignIdentityOptions
                  .customOidc4vcProfile
                  .clientAuthentication
                  .value;
              const authorizationEndPoint = Parameters.authorizeEndPoint;
              final value = const JsonEncoder.withIndent('  ').convert(
                jsonDecode(
                  OIDC4VC().getWalletClientMetadata(
                    authorizationEndPoint,
                    tokenEndpointAuthMethod,
                  ),
                ),
              );
              Navigator.of(context).push<void>(
                JsonViewerPage.route(
                  title: l10n.clientMetadata,
                  data: value,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
