import 'package:altme/app/app.dart';
import 'package:altme/drawer/backup_credential/view/backup_credential_page.dart';
import 'package:altme/drawer/global_information/view/global_information_page.dart';
import 'package:altme/drawer/privacy/view/privacy.dart';
import 'package:altme/drawer/profile/cubit/profile_cubit.dart';
import 'package:altme/drawer/profile/view/widget/menu_item.dart';
import 'package:altme/drawer/recovery_credential/view/recovery_credential_page.dart';
import 'package:altme/drawer/recovery_key/view/recovery_key_page.dart';
import 'package:altme/drawer/terms/view/terms_page.dart';
import 'package:altme/issuer_websites_page/issuer_websites.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/personal/personal.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezster_dart/tezster_dart.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Drawer(
      child: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.message != null) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: state.message!,
              );
            }
          },
          builder: (context, state) {
            final firstName = state.model.firstName;
            final lastName = state.model.lastName;
            final isEnterprise = state.model.isEnterprise;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (firstName.isNotEmpty || lastName.isNotEmpty)
                  Center(
                    child: Text(
                      '$firstName $lastName',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                const SizedBox(height: 32),
                MenuItem(
                  icon: Icons.person,
                  title: l10n.personalTitle,
                  onTap: () => Navigator.of(context).push<void>(
                    PersonalPage.route(
                      profileModel: state.model,
                      isFromOnBoarding: false,
                    ),
                  ),
                ),
                MenuItem(
                  icon: Icons.important_devices,
                  title: l10n.getCredentialTitle,
                  onTap: () => Navigator.of(context).push<void>(
                    IssuerWebsitesPage.route(null),
                  ),
                ),
                MenuItem(
                  icon: Icons.receipt_long,
                  title: l10n.globalInformationLabel,
                  onTap: () => Navigator.of(context)
                      .push<void>(GlobalInformationPage.route()),
                ),
                MenuItem(
                  icon: Icons.shield,
                  title: l10n.privacyTitle,
                  onTap: () =>
                      Navigator.of(context).push<void>(PrivacyPage.route()),
                ),
                MenuItem(
                  icon: Icons.article,
                  title: l10n.onBoardingTosTitle,
                  onTap: () =>
                      Navigator.of(context).push<void>(TermsPage.route()),
                ),
                if (isEnterprise)
                  const SizedBox.shrink()
                else
                  MenuItem(
                    icon: Icons.vpn_key,
                    title: l10n.recoveryKeyTitle,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              title: l10n.recoveryWarningDialogTitle,
                              subtitle: l10n.recoveryWarningDialogSubtitle,
                              yes: l10n.showDialogYes,
                              no: l10n.showDialogNo,
                            ),
                          ) ??
                          false;

                      if (confirm) {
                        await Navigator.of(context)
                            .push<void>(RecoveryKeyPage.route());
                      }
                    },
                  ),
                MenuItem(
                  icon: Icons.settings_backup_restore,
                  title: l10n.resetWalletButton,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            title: l10n.resetWalletButton,
                            subtitle: l10n.resetWalletConfirmationText,
                            yes: l10n.showDialogYes,
                            no: l10n.showDialogNo,
                          ),
                        ) ??
                        false;
                    if (confirm) {
                      await context.read<WalletCubit>().resetWallet();
                    }
                  },
                ),
                MenuItem(
                  icon: Icons.backup,
                  title: l10n.backupCredential,
                  onTap: () {
                    Navigator.of(context)
                        .push<void>(BackupCredentialPage.route());
                  },
                ),
                MenuItem(
                  icon: Icons.restore_page,
                  title: l10n.recoveryCredential,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            title: l10n.recoveryWarningDialogTitle,
                            subtitle:
                                l10n.recoveryCredentialWarningDialogSubtitle,
                            yes: l10n.showDialogYes,
                            no: l10n.showDialogNo,
                          ),
                        ) ??
                        false;

                    if (confirm) {
                      await Navigator.of(context)
                          .push<void>(RecoveryCredentialPage.route());
                    }
                  },
                ),
                MenuItem(
                  key: const Key('theme_update'),
                  icon: Icons.light_mode,
                  title: l10n.selectThemeText,
                  onTap: () => Navigator.of(context)
                      .push<void>(ThemePage.route(context.read<ThemeCubit>())),
                ),
                // TODO(taleb): remove this temp button after testing
                TextButton(
                  onPressed: () async {
                    /// main public RPC endpoints can be accessed at:
                    /// https://rpc.tzstats.com
                    /// https://rpc.edo.tzstats.com
                    /// https://rpc.florence.tzstats.com

                    const tezosWalletAddress =
                        'tz1b9CCt6ukjXC47hys7pUTXPDMNVbdo8hZc';
                    const rpc = 'https://rpc.tzstats.com';
                    final balance = await TezsterDart.getBalance(
                      tezosWalletAddress,
                      rpc,
                    );
                    print('balance: $balance');
                  },
                  child: const Text('GetBalance'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
