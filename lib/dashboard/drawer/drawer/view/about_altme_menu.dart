import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAltmeMenu extends StatelessWidget {
  const AboutAltmeMenu({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AboutAltmeMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AboutAltmeView();
  }
}

class AboutAltmeView extends StatelessWidget {
  const AboutAltmeView({super.key});

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
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (_, snapShot) {
                    var appVersion = '...';
                    if (snapShot.connectionState == ConnectionState.done) {
                      appVersion = snapShot.data?.version ?? '0.1.0';
                    }
                    return DrawerItem(
                      title: '${l10n.yourAltmeAppVersion} : $appVersion',
                      trailing: const Center(),
                    );
                  },
                ),
                DrawerItem(
                  title: l10n.termsOfUse,
                  onTap: () =>
                      Navigator.of(context).push<void>(TermsPage.route()),
                ),
                DrawerItem(
                  title: l10n.licenses,
                  onTap: () =>
                      Navigator.of(context).push<void>(LicensesPage.route()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
