import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DidMenu extends StatelessWidget {
  const DidMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ssiMenu/didMenu'),
      builder: (_) => const DidMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DidView();
  }
}

class DidView extends StatelessWidget {
  const DidView({super.key});

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
                  title: l10n.manageKeyDecentralizedId,
                  onTap: () {
                    Navigator.of(context).push<void>(ManageDIDPage.route());
                  },
                ),
                DrawerItem(
                  title: l10n.manageEbsiDecentralizedId,
                  onTap: () {
                    Navigator.of(context).push<void>(ManageDidEbsiPage.route());
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
