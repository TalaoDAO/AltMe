import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class BackupMenu extends StatelessWidget {
  const BackupMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/BackupMenu'),
      builder: (_) => const BackupMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const BackupView();
  }
}

class BackupView extends StatelessWidget {
  const BackupView({super.key});

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
                  title: l10n.backupCredential,
                  onTap: () async {
                    await Navigator.of(context).push<void>(
                      PinCodePage.route(
                        restrictToBack: false,
                        isValidCallback: () {
                          Navigator.of(context).push<void>(
                            BackupMnemonicPage.route(
                              title: l10n.backupCredential,
                              isValidCallback: () {
                                Navigator.of(context)
                                    .push<void>(BackupCredentialPage.route());
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                DrawerItem(
                  title: l10n.backupPolygonIdIdentity,
                  onTap: () async {
                    await Navigator.of(context).push<void>(
                      PinCodePage.route(
                        restrictToBack: false,
                        isValidCallback: () {
                          Navigator.of(context).push<void>(
                            BackupMnemonicPage.route(
                              title: l10n.backupPolygonIdIdentity,
                              isValidCallback: () {
                                Navigator.of(context).push<void>(
                                  BackupPolygonIdIdentityPage.route(),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
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
