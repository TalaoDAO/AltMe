import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerView();
  }
}

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.drawerBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: BackLeadingButton(
                    padding: EdgeInsets.zero,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const Center(child: AltMeLogo(size: 90)),
                const SizedBox(height: Sizes.spaceSmall),
                const AppVersionDrawer(),
                const SizedBox(height: Sizes.spaceLarge),
                // const DidKey(),
                DrawerCategoryItem(
                  title: l10n.walletSecurity,
                  subTitle: l10n.walletSecurityDescription,
                  onClick: () {
                    Navigator.of(context)
                        .push<void>(WalletSecurityMenu.route());
                  },
                ),
                if (Parameters.hasCryptoCallToAction)
                  Column(
                    children: [
                      const SizedBox(height: Sizes.spaceSmall),
                      DrawerCategoryItem(
                        title: l10n.blockchainSettings,
                        subTitle: l10n.blockchainSettingsDescription,
                        onClick: () {
                          Navigator.of(context)
                              .push<void>(BlockchainSettingsMenu.route());
                        },
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),
                const SizedBox(height: Sizes.spaceSmall),
                DrawerCategoryItem(
                  title: l10n.ssi,
                  subTitle: l10n.ssiDescription,
                  onClick: () {
                    Navigator.of(context).push<void>(SSIMenu.route());
                  },
                ),
                // const SizedBox(height: Sizes.spaceSmall),
                // DrawerCategoryItem(
                //   title: l10n.checkLinkedinProfile,
                //   subTitle: l10n.checkLinkedinProfile,
                //   onClick: () {
                //     Navigator.of(context)
                //         .push<void>(CheckForLinkedInProfile.route());
                //   },
                // ),
                const SizedBox(height: Sizes.spaceSmall),
                DrawerCategoryItem(
                  title: l10n.helpCenter,
                  subTitle: l10n.helpCenterDescription,
                  onClick: () {
                    Navigator.of(context).push<void>(HelpCenterMenu.route());
                  },
                ),
                const SizedBox(height: Sizes.spaceSmall),
                DrawerCategoryItem(
                  title: l10n.aboutAltme,
                  subTitle: l10n.aboutAltmeDescription,
                  onClick: () {
                    Navigator.of(context).push<void>(AboutAltmeMenu.route());
                  },
                ),
                const SizedBox(height: Sizes.spaceSmall),
                DrawerCategoryItem(
                  title: l10n.resetWallet,
                  subTitle: l10n.resetWalletDescription,
                  onClick: () {
                    Navigator.of(context).push<void>(ResetWalletMenu.route());
                  },
                ),
                const SizedBox(
                  height: Sizes.spaceNormal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
