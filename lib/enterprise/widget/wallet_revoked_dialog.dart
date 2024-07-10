import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletRevokedDialog extends StatelessWidget {
  const WalletRevokedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.onSurface;
    final textColor = Theme.of(context).colorScheme.surface;

    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          Text(
            l10n.theWalletIsSuspended,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          MyElevatedButton(
            text: l10n.deleteMyWallet,
            verticalSpacing: 14,
            borderRadius: Sizes.smallRadius,
            elevation: 0,
            onPressed: () async {
              Navigator.of(context).pop();
              await resetWallet(context);
            },
          ),
          TextButton(
            onPressed: () {
              if (isAndroid) {
                SystemNavigator.pop();
              } else {
                Future.delayed(const Duration(milliseconds: 500), () {
                  exit(0);
                });
              }
            },
            child: Text(
              l10n.close.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
