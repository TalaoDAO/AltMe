import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/manage_did/view/did_menu.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SSIMenu extends StatelessWidget {
  const SSIMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ssiMenu'),
      builder: (_) => const SSIMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SSIView();
  }
}

class SSIView extends StatelessWidget {
  const SSIView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                  title: l10n.manageDecentralizedID,
                  onTap: () {
                    Navigator.of(context).push<void>(DidMenu.route());
                  },
                ),
                DrawerItem(
                  title: l10n.backupCredential,
                  onTap: () async {
                    await Navigator.of(context).push<void>(
                      PinCodePage.route(
                        restrictToBack: false,
                        isValidCallback: () {
                          Navigator.of(context)
                              .push<void>(BackupCredentialPage.route());
                        },
                      ),
                    );
                  },
                ),
                DrawerItem(
                  title: l10n.restoreCredential,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            title: l10n.warningDialogTitle,
                            subtitle:
                                l10n.restorationCredentialWarningDialogSubtitle,
                            yes: l10n.showDialogYes,
                            no: l10n.showDialogNo,
                          ),
                        ) ??
                        false;

                    if (confirm) {
                      await Navigator.of(context).push<void>(
                        PinCodePage.route(
                          restrictToBack: false,
                          isValidCallback: () {
                            Navigator.of(context)
                                .push<void>(RecoveryCredentialPage.route());
                          },
                        ),
                      );
                    }
                  },
                ),
                DrawerItem(
                  title: l10n.chooseIssuersRegistry,
                  onTap: () async {
                    await Navigator.of(context)
                        .push<void>(ManageIssuersRegistryPage.route());
                  },
                ),
                DrawerItem(
                  title: l10n.searchCredentials,
                  onTap: () {
                    Navigator.of(context).push<void>(SearchPage.route());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
