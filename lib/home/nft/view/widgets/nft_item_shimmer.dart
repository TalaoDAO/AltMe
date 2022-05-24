import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class NftItemShimmer extends StatelessWidget {
  const NftItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.nftItemWidth,
      height: Sizes.nftItemHeight,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 5, spreadRadius: 0, color: Colors.grey[300]!),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
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
