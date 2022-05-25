import 'package:altme/app/app.dart';
import 'package:altme/home/drawer/backup_credential/view/backup_credential_page.dart';
import 'package:altme/home/drawer/drawer/view/widget/drawer_item.dart';
import 'package:altme/home/drawer/global_information/view/global_information_page.dart';
import 'package:altme/home/drawer/privacy/view/privacy.dart';
import 'package:altme/home/drawer/profile/cubit/profile_cubit.dart';
import 'package:altme/home/drawer/profile/view/profile_page.dart';
import 'package:altme/home/drawer/recovery_credential/view/recovery_credential_page.dart';
import 'package:altme/home/drawer/recovery_key/view/recovery_key_page.dart';
import 'package:altme/home/drawer/terms/view/terms_page.dart';
import 'package:altme/issuer_websites_page/issuer_websites.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

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
                DrawerItem(
                  icon: Icons.person,
                  title: l10n.profileTitle,
                  onTap: () => Navigator.of(context).push<void>(
                    ProfilePage.route(
                      profileModel: state.model,
                      isFromOnBoarding: false,
                    ),
                  ),
                ),
                DrawerItem(
                  icon: Icons.important_devices,
                  title: l10n.getCredentialTitle,
                  onTap: () => Navigator.of(context).push<void>(
                    IssuerWebsitesPage.route(null),
                  ),
                ),
                DrawerItem(
                  icon: Icons.receipt_long,
                  title: l10n.globalInformationLabel,
                  onTap: () => Navigator.of(context)
                      .push<void>(GlobalInformationPage.route()),
                ),
                DrawerItem(
                  icon: Icons.shield,
                  title: l10n.privacyTitle,
                  onTap: () =>
                      Navigator.of(context).push<void>(PrivacyPage.route()),
                ),
                DrawerItem(
                  icon: Icons.article,
                  title: l10n.onBoardingTosTitle,
                  onTap: () =>
                      Navigator.of(context).push<void>(TermsPage.route()),
                ),
                if (isEnterprise)
                  const SizedBox.shrink()
                else
                  DrawerItem(
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
                DrawerItem(
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
                DrawerItem(
                  icon: Icons.backup,
                  title: l10n.backupCredential,
                  onTap: () {
                    Navigator.of(context)
                        .push<void>(BackupCredentialPage.route());
                  },
                ),
                DrawerItem(
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
              ],
            );
          },
        ),
      ),
    );
  }
}
