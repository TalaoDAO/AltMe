import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SearchItemShimmer extends StatelessWidget {
  const SearchItemShimmer({super.key});

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
