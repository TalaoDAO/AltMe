import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/protect_wallet/view/protect_wallet_page.dart';

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
              DrawerItem(
                title: l10n.protectYourWallet,
                subtitle: l10n.secureYourWalletWithPINCodeAndBiometrics,
                onTap: () async {
                  await securityCheck(
                    context: context,
                    localAuthApi: LocalAuthApi(),
                    onSuccess: () {
                      Navigator.of(context)
                          .push<void>(ProtectWalletPage.route());
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
              if (context.read<ProfileCubit>().state.model.profileType ==
                  ProfileType.custom)
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
        );
      },
    );
  }
}
