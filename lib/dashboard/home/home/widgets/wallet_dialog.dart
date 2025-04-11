import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';

import 'package:flutter/material.dart';

class WalletDialog extends StatelessWidget {
  const WalletDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.shortestSide * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DialogCloseButton(showText: false),
              const SizedBox(height: 15),
              Image.asset(
                IconStrings.cardSend,
                width: 50,
                height: 50,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(height: 30),
              Text(
                l10n.createTitle,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                l10n.createSubtitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: MyElevatedButton(
                      text: l10n.create.toUpperCase(),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      verticalSpacing: 12,
                      fontSize: 13,
                      borderRadius: 8,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          ProtectWalletPage.route(
                            routeType: WalletRouteType.create,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyOutlinedButton(
                      text: l10n.import.toUpperCase(),
                      verticalSpacing: 12,
                      fontSize: 13,
                      borderRadius: 8,
                      textColor: Theme.of(context).colorScheme.secondary,
                      borderColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.2),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          ProtectWalletPage.route(
                            routeType: WalletRouteType.import,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
