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
                            const AltMeLogo(
                              color: background,
                              size: Sizes.logoLarge * 1.05,
                            ),
                            Text(
                              l10n.whatsNew,
                              style: Theme.of(context)
                                  .textTheme
                                  .defaultDialogTitle
                                  .copyWith(
                                    color: background,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            NewContent(
                              version: versionNumber,
                              features: const [
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
                                'End to end encryption of decentralized chat in Talao',
                                'Specific design for EBSI diploma card',
                              ],
                            ),
                            const NewContent(
                              version: '1.9.4',
                              features: [
                                'Integration of Matrix.org to give users access to a decentralized chat in Talao',
                                'Compliance with EBSI and support of new official ID documents (diplomas...)',
                              ],
                            ),
                            const NewContent(
                              version: '1.8.13',
                              features: [
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
                                'Credential manifest input descriptors update',
                              ],
                            ),
                            const NewContent(
                              version: '1.7.1',
                              features: [
                                'Improve compatibility with more wallets',
                                'Update Talao’s privacy, terms and conditions',
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
                                'New Drawer',
                                'New Device Info credential',
                                'Bug fix',
                              ],
                            ),
                            const NewContent(
                              version: '1.5.6',
                              features: [
                                'Age range with Al as 551 issuer',
                                'Al issuer optimization'
                              ],
                            ),
                            const NewContent(
                              version: '1.5.1',
                              features: [
                                'Al verification to get Over13 and Over18 pass',
                                'Privacy and terms update',
                                'Enforced security',
                                'User experience improvements'
                              ],
                            ),
                            const NewContent(
                              version: '1.4.8',
                              features: ['Update design of credentials'],
                            ),
                            const NewContent(
                              version: '1.4.4',
                              features: [
                                'Improvements of user experience',
                              ],
                            ),
                            const NewContent(
                              version: '1.3.7',
                              features: [
                                'Get multiple identity credentials after identity verification (OpenID for VC Issuance)',
                                'Choose card categories to display',
                                'New cards design',
                                'Nationality card',
                                'Age range card',
                                'Liveness test',
                              ],
                            ),
                            const NewContent(
                              version: '1.1.0',
                              features: [
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
                  )
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
