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
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WalletDialogCloseButton(),
          const SizedBox(height: 15),
          Text(
            l10n.walletAltme,
            style: Theme.of(context).textTheme.walletAltme,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            l10n.createTitle,
            style: Theme.of(context).textTheme.walletAltmeMessage,
            textAlign: TextAlign.center,
          ),
          Image.asset(
            ImageStrings.createWalletImage,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.shortestSide * 0.5,
          ),
          Text(
            l10n.createSubtitle,
            style: Theme.of(context).textTheme.walletAltmeMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          MyElevatedButton(
            text: l10n.create_wallet.toUpperCase(),
            verticalSpacing: 20,
            fontSize: 18,
            borderRadius: 20,
            onPressed: () {
              Navigator.of(context).push<void>(
                OnBoardingTosPage.route(routeType: WalletRouteType.create),
              );
            },
          ),
          TextButton(
            child: Text(
              l10n.import_wallet.toUpperCase(),
              style: Theme.of(context).textTheme.textButton,
            ),
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

class WalletDialogCloseButton extends StatelessWidget {
  const WalletDialogCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            l10n.close,
            style: Theme.of(context).textTheme.walletDialogClose,
          ),
          const SizedBox(width: 5),
          Image.asset(
            IconStrings.closeCircle,
            height: 22,
          )
        ],
      ),
    );
  }
}
