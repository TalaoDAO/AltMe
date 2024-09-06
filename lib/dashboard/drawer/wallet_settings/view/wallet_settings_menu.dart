import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/wallet_settings/view/language_settings.dart';
import 'package:altme/dashboard/drawer/wallet_settings/view/theme_settings.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    final profileModel = context.read<ProfileCubit>().state.model;

    final helpCenterOptions = profileModel.profileSetting.helpCenterOptions;

    final isEnterprise = profileModel.walletType == WalletType.enterprise;

    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final helpCenterOptions =
              state.model.profileSetting.helpCenterOptions;

          final isEnterprise = state.model.walletType == WalletType.enterprise;
          return Column(
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
                  await Navigator.of(context)
                      .push<void>(LanguageSettings.route());
                },
              ),
              DrawerItem(
                title: l10n.themeSettings,
                subtitle: l10n.themeSettingsDescription,
                onTap: () async {
                  await Navigator.of(context).push<void>(ThemeSettings.route());
                },
              ),
              if (helpCenterOptions.customNotification != null &&
                  helpCenterOptions.customNotification! &&
                  helpCenterOptions.customNotificationRoom != null) ...[
                Padding(
                  padding: const EdgeInsets.all(Sizes.spaceSmall / 2),
                  child: DrawerCategoryItem(
                    title: l10n.notification,
                    subTitle: l10n.notificationSubtitle,
                    trailing: SizedBox(
                      height: 25,
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return Switch(
                            key: const Key('customNotificationRoom'),
                            onChanged: (value) async {
                              await context
                                  .read<ProfileCubit>()
                                  .updateProfileSetting(
                                    displayNotification: value,
                                  );
                            },
                            value: helpCenterOptions.displayNotification,
                            activeColor: Theme.of(context).colorScheme.primary,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceSmall),
              ],
            ],
          );
        },
      ),
    );
  }
}
