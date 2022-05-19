import 'package:altme/nft/view/widgets/index.dart';
import 'package:flutter/material.dart';

class NftListShimmer extends StatelessWidget {
  const NftListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerWidget.rectangular(
          height: 15,
          width: 70,
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 150 / 180,
            ),
            itemBuilder: (_, __) => const NftItemShimmer(),
            itemCount: 12,
          ),
        ),
      ],
    );
  }
}
