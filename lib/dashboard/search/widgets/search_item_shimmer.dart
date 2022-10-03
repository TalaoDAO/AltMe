import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class SearchItemShimmer extends StatelessWidget {
  const SearchItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BackgroundCard(
        padding: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: const AspectRatio(
          aspectRatio: Sizes.credentialAspectRatio,
          child: ShimmerWidget.rectangular(
            height: 150,
          ),
        ),
      ),
    );
  }
}
