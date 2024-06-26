import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/wallet_settings/view/language_settings.dart';
import 'package:altme/dashboard/drawer/wallet_settings/view/theme_settings.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class WalletSettingsMenu extends StatelessWidget {
  const WalletSettingsMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/WalletSettingsMenu'),
      builder: (_) => const WalletSettingsMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const WalletSettingsMenuView();
  }
}

class WalletSettingsMenuView extends StatelessWidget {
  const WalletSettingsMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BackLeadingButton(
            padding: EdgeInsets.zero,
          ),
          const DrawerLogo(),
          DrawerItem(
            title: l10n.languageSettings,
            subtitle: l10n.languageSettingsDescription,
            onTap: () async {
              await Navigator.of(context).push<void>(LanguageSettings.route());
            },
          ),
          DrawerItem(
            title: l10n.themeSettings,
            subtitle: l10n.themeSettingsDescription,
            onTap: () async {
              await Navigator.of(context).push<void>(ThemeSettings.route());
            },
          ),
        ],
      ),
    );
  }
}
