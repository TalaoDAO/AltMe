import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhatIsNewDialog extends StatelessWidget {
  const WhatIsNewDialog({
    super.key,
  });

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      useSafeArea: true,
      builder: (_) => const WhatIsNewDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();
    final versionNumber = splashCubit.state.versionNumber;

    final l10n = context.l10n;

    return SafeArea(
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.whatsNewPopupBackground,
        contentPadding: const EdgeInsets.all(Sizes.spaceXSmall),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceSmall,
          vertical: Sizes.spaceNormal,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.normalRadius),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: WhiteCloseButton(),
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.spaceSmall,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AltMeLogo(
                        color: Colors.white,
                      ),
                      Text(
                        l10n.whatsNew,
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogTitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      Text(
                        versionNumber,
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'End to end encryption of decentralized chat in Talao',
                      ),
                      const NewFeature(
                        'Specific design for EBSI diploma card', // ignore: lines_longer_than_80_chars
                      ),
                      Text(
                        '1.9.2',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Integration of Matrix.org to give users access to a decentralized chat in Talao', // ignore: lines_longer_than_80_chars
                      ),
                      const NewFeature(
                        'Compliance with EBSI and support of new official ID documents (diplomas...)', // ignore: lines_longer_than_80_chars
                      ),
                      Text(
                        '1.8.13',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Integration of an on-ramp solution to buy crypto',
                      ),
                      const NewFeature(
                        'New features : Help center',
                      ),
                      const NewFeature(
                        'New wallet certificate credential',
                      ),
                      Text(
                        '1.7.6',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Bug correction',
                      ),
                      Text(
                        '1.7.5',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'New Chainborn gaming membership card',
                      ),
                      const NewFeature(
                        'Credential manifest input descriptors update',
                      ),
                      const NewFeature(
                        'Beacon pairing improvement',
                      ),
                      Text(
                        '1.7.1',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Improve compatibility with more wallets',
                      ),
                      const NewFeature(
                        'Update Altme’s privacy, terms and conditions',
                      ),
                      const NewFeature(
                        'Update NFT detail screen information',
                      ),
                      const NewFeature(
                        'New category for Professional credentials',
                      ),
                      Text(
                        '1.6.5',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Bug correction',
                      ),
                      Text(
                        '1.6.3',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Support SBT (Soulbound Tokens)',
                      ),
                      const NewFeature(
                        'New Drawer',
                      ),
                      const NewFeature(
                        'New Device Info credential',
                      ),
                      const NewFeature(
                        'Bug fix',
                      ),
                      Text(
                        '1.5.7',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Upgrade Beacon behavior',
                      ),
                      Text(
                        '1.5.6',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Age range with Al as 551 issuer',
                      ),
                      const NewFeature('Al issuer optimization'),
                      Text(
                        '1.5.1',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Al verification to get Over13 and Over18 pass',
                      ),
                      const NewFeature(
                        'Ethereum support',
                      ),
                      const NewFeature(
                        'Privacy and terms update',
                      ),
                      const NewFeature(
                        'Enforced security',
                      ),
                      const NewFeature('User experience improvements'),
                      Text(
                        '1.4.8',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Add Tezotopia membership card in Discover',
                      ),
                      const NewFeature('Update design of credentials'),
                      Text(
                        '1.4.4',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'Add the possibility to SEND an NFT to tezos blockchain address',
                      ),
                      const NewFeature(
                        'Improvements of user experience',
                      ),
                      Text(
                        '1.4.1',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature('New feature : NFT display in wallet'),
                      Text(
                        '1.3.7',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'FA1.2 and FA2 token support',
                      ),
                      const NewFeature(
                        'Beacon integration to connect to Tezos dApps',
                      ),
                      const NewFeature(
                        'Get multiple identity credentials after identity verification (OpenID for VC Issuance)', // ignore: lines_longer_than_80_chars
                      ),
                      const NewFeature(
                        'Choose card categories to display',
                      ),
                      const NewFeature(
                        'New cards design',
                      ),
                      const NewFeature(
                        'Nationality card',
                      ),
                      const NewFeature(
                        'Age range card',
                      ),
                      const NewFeature(
                        'Liveness test',
                      ),
                      const NewFeature(
                        'Display card and token history',
                      ),
                      Text(
                        '1.1.0',
                        style: Theme.of(context)
                            .textTheme
                            .defaultDialogSubtitle
                            .copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      const NewFeature(
                        'USD value of tokens',
                      ),
                      const NewFeature(
                        'Multiple credentials presentation',
                      ),
                      const NewFeature(
                        'Wording',
                      ),
                      const NewFeature(
                        'Bug correction',
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.spaceLarge,
                vertical: Sizes.spaceXSmall,
              ),
              child: MyElevatedButton(
                text: l10n.okGotIt,
                verticalSpacing: 12,
                fontSize: 18,
                borderRadius: 20,
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
