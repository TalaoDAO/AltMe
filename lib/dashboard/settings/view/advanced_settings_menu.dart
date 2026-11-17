import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/profile/view/pick_profile_menu.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The less common settings: wallet profiles, self-sovereign identity and,
/// when the wallet handles crypto, blockchain settings.
class AdvancedSettingsMenu extends StatelessWidget {
  const AdvancedSettingsMenu({super.key});

  static const routeName = '/AdvancedSettingsMenu';

  static Route<dynamic> route() => MaterialPageRoute<void>(
    builder: (_) => const AdvancedSettingsMenu(),
    settings: const RouteSettings(name: routeName),
  );

  /// Whether the menu has at least one row to show for [settingsMenu].
  static bool hasEntries(SettingsMenu settingsMenu) =>
      settingsMenu.displayProfile ||
      settingsMenu.displaySelfSovereignIdentity ||
      Parameters.walletHandlesCrypto;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final settingsMenu = state.model.profileSetting.settingsMenu;
        final navigator = Navigator.of(context);

        return BasePage(
          title: l10n.advancedSettings,
          titleLeading: const BackLeadingButton(),
          scrollView: true,
          body: Column(
            children: [
              if (settingsMenu.displayProfile)
                SettingsRow(
                  icon: WalletIconStrings.person,
                  title: l10n.walletProfiles,
                  subtitle: l10n.walletProfilesDescription,
                  onTap: () => navigator.push<void>(PickProfileMenu.route()),
                ),
              if (settingsMenu.displaySelfSovereignIdentity)
                SettingsRow(
                  icon: WalletIconStrings.verifiedUser,
                  title: l10n.ssi,
                  subtitle: l10n.ssiDescription,
                  onTap: () => navigator.push<void>(SSIMenu.route()),
                ),
              if (Parameters.walletHandlesCrypto)
                SettingsRow(
                  icon: WalletIconStrings.dashboardCustomize,
                  title: l10n.blockchainSettings,
                  subtitle: l10n.blockchainSettingsDescription,
                  onTap: () =>
                      navigator.push<void>(BlockchainSettingsMenu.route()),
                ),
            ],
          ),
        );
      },
    );
  }
}
