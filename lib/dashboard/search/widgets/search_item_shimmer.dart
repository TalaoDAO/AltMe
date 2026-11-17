import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:wallet_ui/wallet_ui.dart';

class SearchItemShimmer extends StatelessWidget {
  const SearchItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: WalletSpacing.m),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.walletColors.backgroundDefault,
          borderRadius: BorderRadius.circular(WalletRadius.s),
        ),
        child: const Padding(
          padding: EdgeInsets.all(WalletSpacing.m),
          child: AspectRatio(
            aspectRatio: Sizes.credentialAspectRatio,
            child: ShimmerWidget.rectangular(height: 150),
          ),
        ),
      ),
    );
  }
}
