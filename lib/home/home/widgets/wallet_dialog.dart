import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class WalletDialog extends StatelessWidget {
  const WalletDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      contentPadding: const EdgeInsets.only(
        top: 24,
        bottom: 16,
        left: 24,
        right: 24,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ImageIcon(
            AssetImage(IconStrings.emptyWalletAdd),
            size: 80,
          ),
          const SizedBox(height: 15),
          Text(
            l10n.create_wallet_message,
            style: Theme.of(context).textTheme.dialogTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          MyElevatedButton(
            text: l10n.create_wallet.toUpperCase(),
            verticalSpacing: 8,
            fontSize: 13,
            onPressed: () {
              Navigator.of(context).push<void>(
                OnBoardingTosPage.route(routeType: WalletRouteType.create),
              );
            },
          ),
          MyElevatedButton(
            text: l10n.restore_wallet.toUpperCase(),
            verticalSpacing: 8,
            fontSize: 13,
            onPressed: () {
              Navigator.of(context).push<void>(
                OnBoardingTosPage.route(routeType: WalletRouteType.recover),
              );
            },
          ),
        ],
      ),
    );
  }
}
