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
        backgroundColor: Theme.of(context).colorScheme.popupBackground,
        contentPadding: const EdgeInsets.all(Sizes.spaceXSmall),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceSmall,
          vertical: Sizes.spaceSmall,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.normalRadius),
          ),
        ),
        content: Stack(
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: WhiteCloseButton(),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: Sizes.spaceSmall),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Sizes.spaceNormal,
                        right: Sizes.spaceXLarge,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AltMeLogo(
                            color: Colors.white,
                            size: Sizes.logoLarge * 1.05,
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
                          NewVersionText(versionNumber: versionNumber),
                          const NewFeature(
                            'Integration of Matrix.org to give users access to a decentralized chat in Altme', // ignore: lines_longer_than_80_chars
                          ),
                          const NewFeature(
                            'Compliance with EBSI and support of new official ID documents (diplomas...)', // ignore: lines_longer_than_80_chars
                          ),
                          const NewVersionText(versionNumber: '1.8.13'),
                          const NewFeature(
                            'Integration of an on-ramp solution to buy crypto',
                          ),
                          const NewFeature(
                            'New features : Help center',
                          ),
                          const NewFeature(
                            'New wallet certificate credential',
                          ),
                          const NewVersionText(versionNumber: '1.7.6'),
                          const NewFeature(
                            'Bug correction',
                          ),
                          const NewVersionText(versionNumber: '1.7.5'),
                          const NewFeature(
                            'New Chainborn gaming membership card',
                          ),
                          const NewFeature(
                            'Credential manifest input descriptors update',
                          ),
                          const NewFeature(
                            'Beacon pairing improvement',
                          ),
                          const NewVersionText(versionNumber: '1.7.1'),
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
                          const NewVersionText(versionNumber: '1.6.5'),
                          const NewFeature(
                            'Bug correction',
                          ),
                          const NewVersionText(versionNumber: '1.6.3'),
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
                          const NewVersionText(versionNumber: '1.5.7'),
                          const NewFeature(
                            'Upgrade Beacon behavior',
                          ),
                          const NewVersionText(versionNumber: '1.5.6'),
                          const NewFeature(
                            'Age range with Al as 551 issuer',
                          ),
                          const NewFeature('Al issuer optimization'),
                          const NewVersionText(versionNumber: '1.5.1'),
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
                          const NewVersionText(versionNumber: '1.4.8'),
                          const NewFeature(
                            'Add Tezotopia membership card in Discover',
                          ),
                          const NewFeature('Update design of credentials'),
                          const NewVersionText(versionNumber: '1.4.4'),
                          const NewFeature(
                            'Add the possibility to SEND an NFT to tezos blockchain address',
                          ),
                          const NewFeature(
                            'Improvements of user experience',
                          ),
                          const NewVersionText(versionNumber: '1.4.1'),
                          const NewFeature(
                            'New feature : NFT display in wallet',
                          ),
                          const NewVersionText(versionNumber: '1.3.7'),
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
                          const NewVersionText(versionNumber: '1.1.0'),
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
                  padding: const EdgeInsets.all(Sizes.spaceNormal),
                  child: MyGradientButton(
                    text: l10n.okGotIt,
                    verticalSpacing: 16,
                    fontSize: 18,
                    borderRadius: Sizes.normalRadius,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
