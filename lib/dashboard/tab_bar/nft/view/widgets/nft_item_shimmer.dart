import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class NftItemShimmer extends StatelessWidget {
  const NftItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AspectRatio(
            aspectRatio: 1,
            child: ShimmerWidget.rectangular(height: 0),
          ),
          SizedBox(
            height: 8,
          ),
          ShimmerWidget.rectangular(
            height: 12,
          ),
        ],
      ),
    );
  }
}
