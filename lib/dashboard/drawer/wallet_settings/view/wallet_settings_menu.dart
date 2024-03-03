import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/wallet_settings/widget/language_selector_widget.dart';
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
      title: l10n.languageSelectorTitle,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      titleLeading: const BackLeadingButton(),
      body: const LanguageSelectorWidget(),
    );
  }
}
