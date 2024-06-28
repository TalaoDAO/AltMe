import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const BackLeadingButton(
                  padding: EdgeInsets.zero,
                ),
                WalletLogo(
                  profileModel: context.read<ProfileCubit>().state.model,
                  height: 90,
                  width: MediaQuery.of(context).size.shortestSide * 0.5,
                  showPoweredBy: true,
                ),
                DrawerItem(
                  title: l10n.backupCredential,
                  onTap: () async {
                    await securityCheck(
                      context: context,
                      localAuthApi: LocalAuthApi(),
                      onSuccess: () {
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
                    );
                  },
                ),
                DrawerItem(
                  title: l10n.backupPolygonIdIdentity,
                  onTap: () async {
                    await securityCheck(
                      context: context,
                      localAuthApi: LocalAuthApi(),
                      onSuccess: () {
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
