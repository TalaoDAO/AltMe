import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class HelpCenterMenu extends StatelessWidget {
  const HelpCenterMenu({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const HelpCenterMenu(),
      settings: const RouteSettings(name: '/HelpCenterMenu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const HelpCenterView();
  }
}

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

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
                  title: l10n.faqs,
                  onTap: () {
                    Navigator.of(context).push<void>(FAQsPage.route());
                  },
                ),
                DrawerItem(
                  title: '${l10n.contactUs} : ${AltMeStrings.appSupportMail}',
                  onTap: () {
                    Navigator.of(context).push<void>(ContactUsPage.route());
                  },
                ),
                DrawerItem(
                  onTap: () {
                    LaunchUrl.launch(
                      'https://${AltMeStrings.appContactWebsiteName}',
                    );
                  },
                  title: '${l10n.officialWebsite} :',
                  trailing: Expanded(
                    flex: 1,
                    child: Text(
                      AltMeStrings.appContactWebsiteName,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
