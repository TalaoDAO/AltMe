import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/profile/view/pick_profile_menu.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerView();
  }
}

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profileModel = state.model;
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Drawer(
            backgroundColor: Theme.of(context).colorScheme.drawerBackground,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: BackLeadingButton(
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),

                    const DrawerLogo(),
                    const AppVersionDrawer(),
                    const SizedBox(height: Sizes.spaceLarge),
                    if (profileModel.profileType == ProfileType.enterprise) ...[
                      DrawerCategoryItem(
                        title: l10n.updateYourWalletConfigNow,
                        padding: const EdgeInsets.all(16),
                        onClick: () async {
                          Navigator.of(context).pop();
                          await context
                              .read<EnterpriseCubit>()
                              .updateTheConfiguration();
                        },
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                    ],

                    if (profileModel
                        .profileSetting.settingsMenu.displayProfile) ...[
                      DrawerCategoryItem(
                        title: l10n.walletProfiles,
                        subTitle: l10n.walletProfilesDescription,
                        onClick: () {
                          Navigator.of(context)
                              .push<void>(PickProfileMenu.route());
                        },
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                    ],
                    DrawerCategoryItem(
                      title: l10n.walletSecurity,
                      subTitle: l10n.walletSecurityDescription,
                      onClick: () {
                        Navigator.of(context)
                            .push<void>(WalletSecurityMenu.route());
                      },
                    ),
                    const SizedBox(height: Sizes.spaceSmall),
                    DrawerCategoryItem(
                      title: l10n.walletSettings,
                      subTitle: l10n.walletSettingsDescription,
                      onClick: () {
                        Navigator.of(context)
                            .push<void>(WalletSettingsMenu.route());
                      },
                    ),
                    if (Parameters.walletHandlesCrypto)
                      Column(
                        children: [
                          const SizedBox(height: Sizes.spaceSmall),
                          DrawerCategoryItem(
                            title: l10n.blockchainSettings,
                            subTitle: l10n.blockchainSettingsDescription,
                            onClick: () {
                              Navigator.of(context)
                                  .push<void>(BlockchainSettingsMenu.route());
                            },
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    const SizedBox(height: Sizes.spaceSmall),

                    if (profileModel.profileSetting.settingsMenu
                        .displaySelfSovereignIdentity) ...[
                      DrawerCategoryItem(
                        title: l10n.ssi,
                        subTitle: l10n.ssiDescription,
                        onClick: () {
                          Navigator.of(context).push<void>(SSIMenu.route());
                        },
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                    ],

                    if (profileModel
                            .profileSetting.settingsMenu.displayDeveloperMode &&
                        profileModel.profileType != ProfileType.defaultOne) ...[
                      DrawerCategoryItem(
                        title: l10n.developerMode,
                        subTitle: l10n.developerModeSubtitle,
                        trailing: SizedBox(
                          height: 25,
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              return Switch(
                                onChanged: (value) async {
                                  await context
                                      .read<ProfileCubit>()
                                      .setDeveloperModeStatus(enabled: value);
                                },
                                value: state.model.isDeveloperMode,
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                    ],

                    // DrawerCategoryItem(
                    //   title: l10n.checkLinkedinProfile,
                    //   subTitle: l10n.checkLinkedinProfile,
                    //   onClick: () {
                    //     Navigator.of(context)
                    //         .push<void>(CheckForLinkedInProfile.route());
                    //   },
                    // ),
                    //const SizedBox(height: Sizes.spaceSmall),

                    if (profileModel
                            .profileSetting.settingsMenu.displayHelpCenter &&
                        profileModel.profileType != ProfileType.defaultOne) ...[
                      DrawerCategoryItem(
                        title: l10n.helpCenter,
                        subTitle: l10n.helpCenterDescription,
                        onClick: () {
                          Navigator.of(context)
                              .push<void>(HelpCenterMenu.route());
                        },
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                    ],

                    DrawerCategoryItem(
                      title: l10n.about,
                      subTitle: l10n.aboutDescription,
                      onClick: () {
                        Navigator.of(context)
                            .push<void>(AboutAltmeMenu.route());
                      },
                    ),
                    const SizedBox(height: Sizes.spaceSmall),
                    DrawerCategoryItem(
                      title: l10n.resetWallet,
                      subTitle: l10n.resetWalletDescription,
                      onClick: () {
                        Navigator.of(context)
                            .push<void>(ResetWalletMenu.route());
                      },
                    ),
                    const SizedBox(
                      height: Sizes.spaceNormal,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
