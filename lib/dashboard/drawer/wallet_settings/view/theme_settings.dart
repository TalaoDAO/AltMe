import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/wallet_settings/widget/theme_selector_widget.dart';
import 'package:flutter/material.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ThemeSettings'),
      builder: (_) => const ThemeSettings(),
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
    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackLeadingButton(
            padding: EdgeInsets.zero,
          ),
          DrawerLogo(),
          ThemeSelectorWidget(),
        ],
      ),
    );
  }
}
