import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/ssi/manage_did/view/did_menu.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SSIMenu extends StatelessWidget {
  const SSIMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ssiMenu'),
      builder: (_) => const SSIMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SSIView();
  }
}

class SSIView extends StatelessWidget {
  const SSIView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final displayManageDecentralizedId = context
        .read<ProfileCubit>()
        .state
        .model
        .profileSetting
        .selfSovereignIdentityOptions
        .displayManageDecentralizedId;
    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const BackLeadingButton(
            padding: EdgeInsets.zero,
          ),
          const DrawerLogo(),
          if (displayManageDecentralizedId)
            DrawerItem(
              title: l10n.manageDecentralizedID,
              onTap: () {
                Navigator.of(context).push<void>(DidMenu.route());
              },
            ),
          DrawerItem(
            title: l10n.backup,
            onTap: () async {
              await Navigator.of(context).push<void>(BackupMenu.route());
            },
          ),
          DrawerItem(
            title: l10n.restore,
            onTap: () async {
              await Navigator.of(context).push<void>(RestoreMenu.route());
            },
          ),
          DrawerItem(
            title: l10n.searchCredentials,
            onTap: () {
              Navigator.of(context).push<void>(SearchPage.route());
            },
          ),
          if (context.read<ProfileCubit>().state.model.profileType ==
              ProfileType.custom) ...[
            DrawerItem(
              title: l10n.oidc4vc_settings,
              onTap: () {
                Navigator.of(context).push<void>(Oidc4vcSettingMenu.route());
              },
            ),
            DrawerItem(
              title: l10n.trustFramework,
              onTap: () async {
                await Navigator.of(context)
                    .push<void>(TrustFrameworkPage.route());
              },
            ),
          ],
        ],
      ),
    );
  }
}
