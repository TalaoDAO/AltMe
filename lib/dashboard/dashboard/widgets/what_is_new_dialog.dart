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
      builder: (_) => const WhatIsNewDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();
    final versionNumber = splashCubit.state.versionNumber;

    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceNormal,
        vertical: Sizes.spaceSmall,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogCloseButton(),
            const SizedBox(height: Sizes.spaceSmall),
            const AltMeLogo(),
            Text(
              l10n.whatsNew,
              style: Theme.of(context).textTheme.defaultDialogTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceNormal),
            Text(
              versionNumber,
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Integration of Matrix.org to give users access to a decentralized chat in Talao',
            ),
            const NewFeature(
              'Compliance with EBSI and support of new official ID documents (diplomas...)',
            ),
            Text(
              '1.8.13',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'New features : Help center',
            ),
            const NewFeature(
              'New wallet certificate credential',
            ),
            Text(
              '1.7.6',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Bug correction',
            ),
            Text(
              '1.7.5',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Credential manifest input descriptors update',
            ),
            Text(
              '1.7.1',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Improve compatibility with more wallets',
            ),
            const NewFeature(
              'Update Talao’s privacy, terms and conditions',
            ),
            const NewFeature(
              'New category for Professional credentials',
            ),
            Text(
              '1.6.5',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Bug correction',
            ),
            Text(
              '1.6.3',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
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
              '1.5.6',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Age range with Al as 551 issuer',
            ),
            const NewFeature('Al issuer optimization'),
            Text(
              '1.5.1',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Al verification to get Over13 and Over18 pass',
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
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature('Update design of credentials'),
            Text(
              '1.4.4',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Improvements of user experience',
            ),
            Text(
              '1.3.7',
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            const NewFeature(
              'Get multiple identity credentials after identity verification (OpenID for VC Issuance)',
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
              style: Theme.of(context).textTheme.defaultDialogSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceXSmall),
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
            MyElevatedButton(
              text: l10n.okGotIt,
              verticalSpacing: 12,
              fontSize: 18,
              borderRadius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
