import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/widgets.dart';
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
        const SizedBox(
          height: 8,
        ),
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
