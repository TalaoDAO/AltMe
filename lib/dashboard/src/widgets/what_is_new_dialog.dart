// ignore_for_file: lines_longer_than_80_chars

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
        surfaceTintColor: Colors.transparent,
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
        content: SizedBox(
          width: double.maxFinite,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
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
                          children: [
                            WalletLogo(
                              profileModel:
                                  context.read<ProfileCubit>().state.model,
                              height: Sizes.logoLarge * 1.05,
                              width: MediaQuery.of(context).size.shortestSide *
                                  0.5,
                              showPoweredBy: true,
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
                            NewContent(
                              version: versionNumber,
                              features: const [
                                'Improve Enterprise Wallet',
                                'User experience improvement',
                                'Bug fixes',
                              ],
                            ),
                            NewContent(
                              version: '2.0.8',
                              features: const [
                                'New Enterprise Wallet mode',
                                'Upload Enterprise Wallet profiles',
                                'Suspension/Revocation of wallet instances',
                                'Support of Decentralized Identity Interop Profile (DIIP OIDC4VC profile)',
                                'Attestation based client authentication (RFC7521)',
                                '2FA (biometric + PIN code)',
                                'Bug fixes',
                              ],
                            ),
                            const NewContent(
                              version: '1.25.2',
                              features: [
                                'Developer mode improvement',
                                'OIDC4VCI improvement',
                                'Update code licenses',
                                'Bug correction',
                              ],
                            ),
                            const NewContent(
                              version: '1.23.0',
                              features: [
                                'Developer mode improvement',
                                'Bug correction',
                              ],
                            ),
                            const NewContent(
                              version: '1.21.8',
                              features: [
                                'Developper mode',
                                'New splash screen',
                                'extended OIDC4VC options',
                              ],
                            ),
                            const NewContent(
                              version: '1.20.18',
                              features: [
                                'Wallet connect V2 integration',
                                'Bug fixes',
                              ],
                            ),
                            const NewContent(
                              version: '1.16.2',
                              features: [
                                'PolygonID mainnet integration',
                                'PolygonID Twitter Attestations through Clique.Social',
                                'DeFi compliance SBT for BNB Chain',
                                'Bug fixes',
                              ],
                            ),
                            const NewContent(
                              version: '1.15.0',
                              features: [
                                'New cards designs',
                                'Robust KYC solution (ID360) by Docaposte',
                                'PolygonID integration for ZKP credentials',
                                'New DeFi compliance credential',
                                'New feature to add an identity layer to any crypto wallet',
                                'New discover coins section in Altme',
                                'Bug fixes',
                              ],
                            ),
                            const NewContent(
                              version: '1.13.24',
                              features: [
                                'Improved user experience',
                                'New questions in FAQ',
                                'New age card Over15',
                                'End to end encryption of chat',
                                'Check verifiable data registry for EBSI protocol',
                              ],
                            ),
                            const NewContent(
                              version: '1.12.4',
                              features: [
                                'Resolved wallet certificate generation issue.',
                              ],
                            ),
                            const NewContent(
                              version: '1.12.3',
                              features: [
                                'Resolved KYC stability issues.',
                                'Integrated live chat support for partners with loyalty cards',
                                'Expanded "Discover" section with the addition of Bloometa card',
                                'Enhanced credential backup reliability on some devices',
                                'Optimized help center layout and user experience',
                              ],
                            ),
                            const NewContent(
                              version: '1.11.4',
                              features: [
                                'Improve onboarding experience',
                                'Add confirmation of recovery phrase',
                                'Improve popup design',
                                'Update SIOPV2 flow',
                                'Add deeplink for EBSI credentials',
                              ],
                            ),
                            const NewContent(
                              version: '1.10.5',
                              features: [
                                'End to end encryption of decentralized chat in Altme',
                                'Specific design for EBSI diploma card',
                              ],
                            ),
                            const NewContent(
                              version: '1.9.9',
                              features: [
                                'Integration of Matrix.org to give users access to a decentralized chat in Altme',
                                'Compliance with EBSI and support of new official ID documents (diplomas...)',
                              ],
                            ),
                            const NewContent(
                              version: '1.8.13',
                              features: [
                                'Integration of an on-ramp solution to buy crypto',
                                'New features : Help center',
                                'New wallet certificate credential',
                              ],
                            ),
                            const NewContent(
                              version: '1.7.6',
                              features: [
                                'Bug correction',
                              ],
                            ),
                            const NewContent(
                              version: '1.7.5',
                              features: [
                                'New Chainborn gaming membership card',
                                'Credential manifest input descriptors update',
                                'Beacon pairing improvement',
                              ],
                            ),
                            const NewContent(
                              version: '1.7.1',
                              features: [
                                'Improve compatibility with more wallets',
                                'Update Altme’s privacy, terms and conditions',
                                'Update NFT detail screen information',
                                'New category for Professional credentials',
                              ],
                            ),
                            const NewContent(
                              version: '1.6.5',
                              features: [
                                'Bug correction',
                              ],
                            ),
                            const NewContent(
                              version: '1.6.3',
                              features: [
                                'Support SBT (Soulbound Tokens)',
                                'New Drawer',
                                'New Device Info credential',
                                'Bug fix',
                              ],
                            ),
                            const NewContent(
                              version: '1.5.7',
                              features: ['Upgrade Beacon behavior'],
                            ),
                            const NewContent(
                              version: '1.5.6',
                              features: [
                                'Age range with Al as 551 issuer',
                                'Al issuer optimization',
                              ],
                            ),
                            const NewContent(
                              version: '1.5.1',
                              features: [
                                'Al verification to get Over13 and Over18 pass',
                                'Ethereum support',
                                'Privacy and terms update',
                                'Enforced security',
                                'User experience improvements',
                              ],
                            ),
                            const NewContent(
                              version: '1.4.8',
                              features: [
                                'Add Tezotopia membership card in Discover',
                                'Update design of credentials',
                              ],
                            ),
                            const NewContent(
                              version: '1.4.4',
                              features: [
                                'Add the possibility to SEND an NFT to tezos blockchain address',
                                'Improvements of user experience',
                              ],
                            ),
                            const NewContent(
                              version: '1.4.1',
                              features: ['New feature : NFT display in wallet'],
                            ),
                            const NewContent(
                              version: '1.3.7',
                              features: [
                                'FA1.2 and FA2 token support',
                                'Beacon integration to connect to Tezos dApps',
                                'Get multiple identity credentials after identity verification (OpenID for VC Issuance)',
                                'Choose card categories to display',
                                'New cards design',
                                'Nationality card',
                                'Age range card',
                                'Liveness test',
                                'Display card and token history',
                              ],
                            ),
                            const NewContent(
                              version: '1.1.0',
                              features: [
                                'USD value of tokens',
                                'Multiple credentials presentation',
                                'Wording',
                                'Bug correction',
                              ],
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
                  ),
                ],
              ),
              const Align(
                alignment: Alignment.topRight,
                child: WhiteCloseButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
