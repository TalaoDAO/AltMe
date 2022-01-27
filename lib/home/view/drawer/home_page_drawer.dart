import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/home/view/drawer/menu_item.dart';
import 'package:ssi_crypto_wallet/home/view/drawer/pages/privacy.dart';
import 'package:ssi_crypto_wallet/home/view/drawer/pages/terms.dart';
import 'package:ssi_crypto_wallet/l10n/l10n.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MenuItem(
              icon: Icons.person,
              title: l10n.personalTitle,
              onTap: () {
                //Navigator.of(context).push(PersonalPage.route(model))
              },
            ),
            MenuItem(
              icon: Icons.receipt_long,
              title: l10n.generalInformationLabel,
              onTap: () {
                // Navigator.of(context).push(GlobalInformationPage.route())
              },
            ),
            MenuItem(
              icon: Icons.shield,
              title: l10n.privacyTitle,
              onTap: () {
                Navigator.of(context).push<void>(PrivacyPage.route());
              },
            ),
            MenuItem(
              icon: Icons.article,
              title: l10n.termsAndConditionTitle,
              onTap: () {
                Navigator.of(context).push<void>(TermsPage.route());
              },
            ),
            MenuItem(
              icon: Icons.settings_backup_restore,
              title: l10n.resetWalletButton,
              onTap: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
