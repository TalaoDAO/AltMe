import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class CredentialItemShimmer extends StatelessWidget {
  const CredentialItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.07),
      padding: EdgeInsets.zero,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: ShimmerWidget.rectangular(height: 0),
          ),
          SizedBox(
            height: 8,
          ),
          ShimmerWidget.rectangular(
            height: 15,
          ),
        ],
      ),
    );
  }
}
