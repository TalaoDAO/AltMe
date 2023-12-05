import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class RestoreMenu extends StatelessWidget {
  const RestoreMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/RestoreMenu'),
      builder: (_) => const RestoreMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const RestoreView();
  }
}

class RestoreView extends StatelessWidget {
  const RestoreView({super.key});

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
                      await securityCheck(
                        context: context,
                        localAuthApi: LocalAuthApi(),
                        onSuccess: () {
                          Navigator.of(context).push<void>(
                            RestoreCredentialMnemonicPage.route(
                              title: l10n.restoreCredential,
                              isValidCallback: () {
                                Navigator.of(context).push<void>(
                                  RestoreCredentialPage.route(),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                DrawerItem(
                  title: l10n.restorePolygonIdCredentials,
                  onTap: () {
                    securityCheck(
                      context: context,
                      localAuthApi: LocalAuthApi(),
                      onSuccess: () {
                        Navigator.of(context).push<void>(
                          RestoreCredentialMnemonicPage.route(
                            title: l10n.restorePolygonIdCredentials,
                            isValidCallback: () {
                              Navigator.of(context).push<void>(
                                RestorePolygonIdCredentialPage.route(),
                              );
                            },
                          ),
                        );
                      },
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
