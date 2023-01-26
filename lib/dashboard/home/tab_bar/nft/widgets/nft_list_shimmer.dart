import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/nft/widgets/nft_item_shimmer.dart';
import 'package:flutter/material.dart';

class NftListShimmer extends StatelessWidget {
  const NftListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: Sizes.nftItemRatio,
            ),
            itemBuilder: (_, __) => const NftItemShimmer(),
            itemCount: 12,
          ),
        ),
      ],
    );
  }
}
