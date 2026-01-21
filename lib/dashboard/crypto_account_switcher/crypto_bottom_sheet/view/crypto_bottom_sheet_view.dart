import 'package:altme/app/app.dart';
import 'package:altme/dashboard/crypto_account_switcher/crypto_bottom_sheet/view/crypto_account_switcher.dart';

import 'package:flutter/material.dart';

class CryptoBottomSheetView extends StatelessWidget {
  const CryptoBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceDim,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.inversePrimary,
              blurRadius: 5,
              spreadRadius: -3,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(Sizes.largeRadius),
            topLeft: Radius.circular(Sizes.largeRadius),
          ),
        ),
        child: const CryptoAccountSwitcherProvider(),
      ),
    );
  }
}
