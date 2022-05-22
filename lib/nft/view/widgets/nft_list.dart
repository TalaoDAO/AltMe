import 'package:altme/app/app.dart';
import 'package:altme/nft/models/index.dart';
import 'package:altme/nft/view/widgets/index.dart';
import 'package:flutter/material.dart';

class NftList extends StatelessWidget {
  const NftList({Key? key, required this.nftList}) : super(key: key);

  final List<NftModel> nftList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${nftList.length} items'),
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
            itemBuilder: (_, index) => NftItem(
              assetUrl: nftList[index].assetUrl,
              assetValue: nftList[index].assetValue,
              description: nftList[index].description,
            ),
            itemCount: nftList.length,
          ),
        ),
      ],
    );
  }
}
