import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class DidPrivateKey extends StatelessWidget {
  const DidPrivateKey({super.key, required this.route});

  final Route<dynamic> route;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: Sizes.space2XLarge),
        Text(
          l10n.didPrivateKey,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: Sizes.spaceNormal),
        Text(
          l10n.didPrivateKeyDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Sizes.spaceXLarge),
        RevealButton(
          onTap: () async {
            final confirm =
                await showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: l10n.warningDialogTitle,
                    subtitle: l10n.didPrivateKeyDescriptionAlert,
                    yes: l10n.showDialogYes,
                    no: l10n.showDialogNo,
                  ),
                ) ??
                false;

            if (confirm) {
              await securityCheck(
                context: context,
                title: l10n.typeYourPINCodeToAuthenticate,
                localAuthApi: LocalAuthApi(),
                onSuccess: () {
                  Navigator.push<void>(context, route);
                },
              );
            }
          },
        ),
      ],
    );
  }
}
