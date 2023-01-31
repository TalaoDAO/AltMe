import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TokenItemShimmer extends StatelessWidget {
  const TokenItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BackgroundCard(
        color: Theme.of(context).colorScheme.surfaceContainer,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const ListTile(
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.zero,
          leading: ShimmerWidget.circular(
            height: Sizes.tokenLogoSize,
            width: Sizes.tokenLogoSize,
          ),
          title: ShimmerWidget.rectangular(
            height: 20,
            width: 60,
          ),
          subtitle: ShimmerWidget.rectangular(
            height: 16,
            width: 40,
          ),
          trailing: ShimmerWidget.rectangular(
            height: 18,
            width: 50,
          ),
        ),
      ),
    );
  }
}
