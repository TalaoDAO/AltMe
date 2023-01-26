import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ChooseAddAccountMethodPage extends StatelessWidget {
  const ChooseAddAccountMethodPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/chooseAddAccountMethodPage'),
      builder: (_) => const ChooseAddAccountMethodPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ChooseAddAccountMethodView();
  }
}

class ChooseAddAccountMethodView extends StatelessWidget {
  const ChooseAddAccountMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.cryptoAddAccount,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.selectAMethodToAddAccount,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall3,
          ),
          const SizedBox(height: Sizes.spaceXLarge),
          CustomListTileCard(
            title: l10n.createAccount,
            subTitle: l10n.createAccountDescription,
            imageAssetPath: ImageStrings.createAccountMethod,
            onTap: () {
              Navigator.of(context).push<void>(CreateAccountStep1Page.route());
            },
          ),
          const SizedBox(height: Sizes.spaceLarge),
          CustomListTileCard(
            title: l10n.importAccount,
            subTitle: l10n.importAccountDescription,
            imageAssetPath: ImageStrings.importAccountMethod,
            onTap: () {
              Navigator.of(context).push<void>(ImportAccountStep1Page.route());
            },
          ),
        ],
      ),
    );
  }
}
