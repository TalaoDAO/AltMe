import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DrawerView();
  }
}

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

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
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                const AppVersionDrawer(),
                const SizedBox(
                  height: Sizes.spaceLarge,
                ),
                // const DidKey(),
                DrawerCategoryItem(
                  title: l10n.walletSecurity,
                  subTitle: l10n.walletSecurityDescription,
                  onClick: () {
                    Navigator.of(context)
                        .push<void>(WalletSecurityMenu.route());
                  },
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                DrawerCategoryItem(
                  title: l10n.blockchainSettings,
                  subTitle: l10n.blockchainSettingsDescription,
                  onClick: () {
                    Navigator.of(context)
                        .push<void>(BlockchainSettingsMenu.route());
                  },
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                DrawerCategoryItem(
                  title: l10n.ssi,
                  subTitle: l10n.ssiDescription,
                  onClick: () {
                    Navigator.of(context).push<void>(SSIMenu.route());
                  },
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                DrawerCategoryItem(
                  title: l10n.helpCenter,
                  subTitle: l10n.helpCenterDescription,
                  onClick: () {
                    Navigator.of(context).push<void>(HelpCenterMenu.route());
                  },
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                DrawerCategoryItem(
                  title: l10n.aboutAltme,
                  subTitle: l10n.aboutAltmeDescription,
                  onClick: () {
                    Navigator.of(context).push<void>(AboutAltmeMenu.route());
                  },
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                DrawerCategoryItem(
                  title: l10n.resetWallet,
                  subTitle: l10n.resetWalletDescription,
                  onClick: () async {
                    final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => ConfirmDialog(
                            title: l10n.resetWalletConfirmationText,
                            yes: l10n.delete,
                            no: l10n.showDialogNo,
                            dialogColor: Theme.of(context).colorScheme.error,
                            // icon: IconStrings.trash,
                          ),
                        ) ??
                        false;
                    if (confirm) {
                      final pinCode =
                          await getSecureStorage.get(SecureStorageKeys.pinCode);
                      if (pinCode?.isEmpty ?? true) {
                        await context.read<WalletCubit>().resetWallet();
                      } else {
                        await Navigator.of(context).push<void>(
                          PinCodePage.route(
                            isValidCallback: () =>
                                context.read<WalletCubit>().resetWallet(),
                            restrictToBack: false,
                          ),
                        );
                      }
                    }
                  },
                  // onClick: () {
                  //   Navigator.of(context).push<void>(ResetWalletMenu.route());
                  // },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
