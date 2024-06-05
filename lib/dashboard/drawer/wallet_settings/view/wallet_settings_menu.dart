import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackLeadingButton(
            padding: EdgeInsets.zero,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const DrawerLogo(),
          const LanguageSelectorWidget(),
        ],
      ),
    );
  }
}
