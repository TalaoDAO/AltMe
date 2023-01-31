import 'package:altme/app/shared/constants/icon_strings.dart';
import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:key_generator/key_generator.dart';

class CreateAccountStep1Page extends StatelessWidget {
  const CreateAccountStep1Page({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/createAccountStep1Page'),
      builder: (_) => const CreateAccountStep1Page(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CreateAccountStep1View();
  }
}

class CreateAccountStep1View extends StatelessWidget {
  const CreateAccountStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.createAccount,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
      titleLeading: const BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MStepper(totalStep: 2),
          const SizedBox(height: Sizes.spaceNormal),
          Text(
            l10n.chooseABlockchainForAccountCreation,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall3,
          ),
          const SizedBox(height: Sizes.spaceNormal),
          CustomListTileCard(
            title: l10n.tezosAccount,
            subTitle: l10n.tezosAccountDescription,
            imageAssetPath: IconStrings.tezos,
            onTap: () {
              Navigator.of(context).push<void>(
                CreateAccountStep2Page.route(accountType: AccountType.tezos),
              );
            },
          ),
          const SizedBox(height: Sizes.spaceNormal),
          CustomListTileCard(
            title: l10n.ethereumAccount,
            subTitle: l10n.ethereumAccountDescription,
            imageAssetPath: IconStrings.ethereum,
            onTap: () {
              Navigator.of(context).push<void>(
                CreateAccountStep2Page.route(accountType: AccountType.ethereum),
              );
            },
          ),
          const SizedBox(height: Sizes.spaceNormal),
          CustomListTileCard(
            title: l10n.fantomAccount,
            subTitle: l10n.fantomAccountDescription,
            imageAssetPath: IconStrings.fantom,
            onTap: () {
              Navigator.of(context).push<void>(
                CreateAccountStep2Page.route(accountType: AccountType.fantom),
              );
            },
          ),
          const SizedBox(height: Sizes.spaceNormal),
          CustomListTileCard(
            title: l10n.polygonAccount,
            subTitle: l10n.polygonAccountDescription,
            imageAssetPath: IconStrings.polygon,
            onTap: () {
              Navigator.of(context).push<void>(
                CreateAccountStep2Page.route(accountType: AccountType.polygon),
              );
            },
          ),
          const SizedBox(height: Sizes.spaceNormal),
          CustomListTileCard(
            title: l10n.binanceAccount,
            subTitle: l10n.binanceAccountDescription,
            imageAssetPath: IconStrings.binance,
            onTap: () {
              Navigator.of(context).push<void>(
                CreateAccountStep2Page.route(accountType: AccountType.binance),
              );
            },
          ),
        ],
      ),
    );
  }
}
