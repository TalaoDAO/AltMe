import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/protect_wallet/view/protect_wallet_page.dart';

import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletSecurityMenu extends StatelessWidget {
  const WalletSecurityMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const WalletSecurityMenu(),
      settings: const RouteSettings(name: '/WalletSecurityMenu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const WalletSecurityView();
  }
}

class WalletSecurityView extends StatelessWidget {
  const WalletSecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.drawerBackground,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BackLeadingButton(
                      padding: EdgeInsets.zero,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const Center(
                      child: AltMeLogo(size: 90),
                    ),
                    const SizedBox(
                      height: Sizes.spaceSmall,
                    ),
                    DrawerItem(
                      title: l10n.protectYourWallet,
                      subtitle: l10n.secureYourWalletWithPINCodeAndBiometrics,
                      onTap: () async {
                        await securityCheck(
                          context: context,
                          localAuthApi: LocalAuthApi(),
                          onSuccess: () {
                            Navigator.of(context).push<void>(
                              ProtectWalletPage.route(isFromOnboarding: false),
                            );
                          },
                        );
                      },
                    ),
                    DrawerItem(
                      title: l10n.showWalletRecoveryPhrase,
                      subtitle: l10n.showWalletRecoveryPhraseSubtitle,
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                title: l10n.warningDialogTitle,
                                subtitle: l10n.warningDialogSubtitle,
                                yes: l10n.showDialogYes,
                                no: l10n.showDialogNo,
                              ),
                            ) ??
                            false;

                        if (confirm) {
                          await securityCheck(
                            context: context,
                            localAuthApi: LocalAuthApi(),
                            onSuccess: () {
                              Navigator.of(context)
                                  .push<void>(RecoveryKeyPage.route());
                            },
                          );
                        }
                      },
                    ),
                    DrawerItem(
                      title: l10n.advancedSecuritySettings,
                      onTap: () {
                        Navigator.of(context).push<void>(
                          AdvancedSecuritySettingsMenu.route(),
                        );
                      },
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
