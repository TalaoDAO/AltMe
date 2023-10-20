import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class AdvancedSettings2Menu extends StatelessWidget {
  const AdvancedSettings2Menu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/AdvancedSettings2Menu'),
      builder: (_) => const AdvancedSettings2Menu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AdvancedSettings2View();
  }
}

class AdvancedSettings2View extends StatelessWidget {
  const AdvancedSettings2View({super.key});

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
                const SizedBox(height: Sizes.spaceSmall),
                // DrawerItem(
                //   title: l10n.oidc4vcProfile,
                //   onTap: () async {
                //     await Navigator.of(context)
                //         .push<void>(OIDC4VCProfilePage.route());
                //   },
                // ),
                DrawerItem(
                  title: l10n.oidc4vc_settings,
                  onTap: () {
                    Navigator.of(context)
                        .push<void>(Oidc4vcSettingMenu.route());
                  },
                ),
                DrawerItem(
                  title: l10n.verifiableDataRegistry,
                  onTap: () async {
                    await Navigator.of(context)
                        .push<void>(VerifiableDataRegistryPage.route());
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
