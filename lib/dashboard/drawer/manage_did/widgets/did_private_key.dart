import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DidPrivateKey extends StatelessWidget {
  const DidPrivateKey({
    super.key,
    required this.l10n,
    required this.route,
  });

  final AppLocalizations l10n;
  final Route<dynamic> route;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Sizes.space2XLarge,
        ),
        Text(
          l10n.didPrivateKey,
          style: Theme.of(context).textTheme.title,
        ),
        const SizedBox(
          height: Sizes.spaceNormal,
        ),
        Text(
          l10n.didPrivateKeyDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: Sizes.spaceXLarge,
        ),
        RevealButton(
          onTap: () async {
            final confirm = await showDialog<bool>(
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
              await Navigator.of(context).push<void>(
                PinCodePage.route(
                  restrictToBack: false,
                  isValidCallback: () {
                    Navigator.push<void>(
                      context,
                      route,
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
