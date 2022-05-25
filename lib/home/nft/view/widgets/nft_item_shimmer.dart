import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class NftItemShimmer extends StatelessWidget {
  const NftItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AspectRatio(
            aspectRatio: 1,
            child: Expanded(
              child: ShimmerWidget.rectangular(height: 0),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ShimmerWidget.rectangular(
            height: 12,
          ),
          SizedBox(
            height: 6,
          ),
          ShimmerWidget.rectangular(
            height: 10,
            width: 60,
          )
        ],
      ),
    );
  }
}
