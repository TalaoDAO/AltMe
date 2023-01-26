import 'package:altme/app/shared/constants/icon_strings.dart';
import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:key_generator/key_generator.dart';

class ImportAccountStep2Page extends StatelessWidget {
  const ImportAccountStep2Page({super.key, required this.accountType});
  final AccountType accountType;
  static Route<dynamic> route({required AccountType accountType}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/importAccountStep2Page'),
      builder: (_) => ImportAccountStep2Page(accountType: accountType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ImportAccountStep2View(accountType: accountType);
  }
}

class ImportAccountStep2View extends StatelessWidget {
  const ImportAccountStep2View({
    super.key,
    required this.accountType,
  });

  final AccountType accountType;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.importAccount,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MStepper(
            totalStep: 4,
            step: 2,
          ),
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
          Text(
            l10n.importEasilyFrom,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall3,
          ),
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
          if (accountType == AccountType.tezos) ...[
            AccountItem(
              title: l10n.templeWallet,
              iconPath: IconStrings.templeWallet,
              onTap: () {
                Navigator.of(context).push<void>(
                  ImportAccountStep3Page.route(accountType: accountType),
                );
              },
            ),
            AccountItem(
              title: l10n.kukaiWallet,
              iconPath: IconStrings.kukaiWallet,
              onTap: () {
                Navigator.of(context).push<void>(
                  ImportAccountStep3Page.route(accountType: accountType),
                );
              },
            ),
          ] else ...[
            AccountItem(
              title: l10n.guardaWallet,
              iconPath: IconStrings.guardaWallet,
              onTap: () {
                Navigator.of(context).push<void>(
                  ImportAccountStep3Page.route(accountType: accountType),
                );
              },
            ),
            AccountItem(
              title: l10n.exodusWallet,
              iconPath: IconStrings.exodusWallet,
              onTap: () {
                Navigator.of(context).push<void>(
                  ImportAccountStep3Page.route(accountType: accountType),
                );
              },
            ),
            AccountItem(
              title: l10n.trustWallet,
              iconPath: IconStrings.trustWallet,
              onTap: () {
                Navigator.of(context).push<void>(
                  ImportAccountStep3Page.route(accountType: accountType),
                );
              },
            ),
            AccountItem(
              title: l10n.myetherwallet,
              iconPath: IconStrings.myetherwallet,
              onTap: () {
                Navigator.of(context).push<void>(
                  ImportAccountStep3Page.route(accountType: accountType),
                );
              },
            ),
            AccountItem(
              title: l10n.metaMaskWallet,
              iconPath: IconStrings.metaMaskWallet,
              onTap: () {
                Navigator.of(context).push<void>(
                  ImportAccountStep3Page.route(accountType: accountType),
                );
              },
            ),
          ],
          AccountItem(
            title: l10n.other,
            iconPath: IconStrings.add,
            onTap: () {
              Navigator.of(context).push<void>(
                ImportAccountStep3Page.route(accountType: accountType),
              );
            },
          ),
        ],
      ),
    );
  }
}
