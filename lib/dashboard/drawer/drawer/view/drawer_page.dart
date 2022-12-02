import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawerCubit(),
      child: DrawerView(localAuthApi: LocalAuthApi()),
    );
  }
}

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key, required this.localAuthApi}) : super(key: key);

  final LocalAuthApi localAuthApi;

  //method for set new pin code
  Future<void> setNewPinCode(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    await Navigator.of(context).push<void>(
      EnterNewPinCodePage.route(
        isFromOnboarding: false,
        isValidCallback: () {
          Navigator.of(context).pop();
          AlertMessage.showStringMessage(
            context: context,
            message: l10n.yourPinCodeChangedSuccessfully,
            messageType: MessageType.success,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.drawerBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<DrawerCubit, DrawerState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BackLeadingButton(
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).colorScheme.onPrimary,
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

                        },
                      ),
                      const SizedBox(
                        height: Sizes.spaceSmall,
                      ),
                      DrawerCategoryItem(
                        title: l10n.blockchainSettings,
                        subTitle: l10n.blockchainSettingsDescription,
                      ),
                      const SizedBox(
                        height: Sizes.spaceSmall,
                      ),
                      DrawerCategoryItem(
                        title: l10n.ssi,
                        subTitle: l10n.ssiDescription,
                      ),
                      const SizedBox(
                        height: Sizes.spaceSmall,
                      ),
                      DrawerCategoryItem(
                        title: l10n.helpCenter,
                        subTitle: l10n.helpCenterDescription,
                      ),
                      const SizedBox(
                        height: Sizes.spaceSmall,
                      ),
                      DrawerCategoryItem(
                        title: l10n.aboutAltme,
                        subTitle: l10n.aboutAltmeDescription,
                      ),
                      const SizedBox(
                        height: Sizes.spaceSmall,
                      ),
                      DrawerCategoryItem(
                        title: l10n.resetWallet,
                        subTitle: l10n.resetWalletDescription,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
