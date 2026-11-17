import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The Settings root, opened from the dashboard header. One row per entry of
/// the former drawer; the sub-pages keep their own PIN checks.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = '/SettingsPage';

  static Route<dynamic> route() => MaterialPageRoute<void>(
    builder: (_) => const SettingsPage(),
    settings: const RouteSettings(name: routeName),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // The flags can change live, when the profile is switched.
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profileModel = state.model;
        final profileSetting = profileModel.profileSetting;
        final settingsMenu = profileSetting.settingsMenu;
        final navigator = Navigator.of(context);

        return BasePage(
          title: l10n.settings,
          titleLeading: const BackLeadingButton(),
          scrollView: true,
          body: Column(
            children: [
              if (profileModel.profileType == ProfileType.enterprise)
                const UpdateConfigRow(),
              SettingsRow(
                icon: WalletIconStrings.verifiedUser,
                title: l10n.walletSecurityAndBackup,
                subtitle: l10n.walletSecurityDescription,
                onTap: () => navigator.push<void>(WalletSecurityMenu.route()),
              ),
              SettingsRow(
                icon: WalletIconStrings.language,
                title: l10n.appearanceAndLanguage,
                subtitle: l10n.walletSettingsDescription,
                onTap: () => navigator.push<void>(WalletSettingsMenu.route()),
              ),
              if (settingsMenu.displayActivityLog)
                SettingsRow(
                  icon: WalletIconStrings.schedule,
                  title: l10n.activityLog,
                  subtitle: l10n.activityLogDescription,
                  onTap: () => navigator.push<void>(ActivityLogPage.route()),
                ),
              if (settingsMenu.displayHelpCenter)
                SettingsRow(
                  icon: WalletIconStrings.help,
                  title: l10n.helpCenter,
                  subtitle: l10n.helpCenterDescription,
                  trailing: profileSetting.helpCenterOptions.displayChatSupport
                      ? const _ChatUnreadBadge()
                      : null,
                  onTap: () => navigator.push<void>(HelpCenterMenu.route()),
                ),
              SettingsRow(
                icon: WalletIconStrings.info,
                title: l10n.legal,
                subtitle: l10n.aboutDescription,
                onTap: () => navigator.push<void>(AboutAltmeMenu.route()),
              ),
              if (settingsMenu.displayDeveloperMode)
                SettingsRow(
                  icon: WalletIconStrings.codeXml,
                  title: l10n.developerMode,
                  subtitle: l10n.developerModeSubtitle,
                  onTap: () => navigator.push<void>(DeveloperModeMenu.route()),
                ),
              if (AdvancedSettingsMenu.hasEntries(settingsMenu))
                SettingsRow(
                  icon: WalletIconStrings.tune,
                  title: l10n.advancedSettings,
                  onTap: () =>
                      navigator.push<void>(AdvancedSettingsMenu.route()),
                ),
              SettingsRow(
                icon: WalletIconStrings.warning,
                title: l10n.resetWallet,
                subtitle: l10n.resetWalletDescription,
                onTap: () => navigator.push<void>(ResetWalletMenu.route()),
              ),
              SettingsFooter(profileModel: profileModel),
            ],
          ),
        );
      },
    );
  }
}

/// The number of unread support chat messages, in place of the chevron.
class _ChatUnreadBadge extends StatelessWidget {
  const _ChatUnreadBadge();

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<AltmeChatSupportCubit>();
    return StreamBuilder<int>(
      initialData: chatCubit.unreadMessageCount,
      stream: chatCubit.unreadMessageCountStream,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (count > 0) Badge.count(count: count),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        );
      },
    );
  }
}
