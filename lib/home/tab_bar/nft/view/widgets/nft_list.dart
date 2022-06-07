import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/widgets.dart';
import 'package:altme/home/tab_bar/tab_bar.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class NftList extends StatelessWidget {
  const NftList({Key? key, required this.nftList, required this.onRefresh})
      : super(key: key);

  final List<NftModel> nftList;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${nftList.length} ${l10n.items}',
          style: Theme.of(context).textTheme.listSubtitle,
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: Sizes.nftItemRatio,
              ),
              itemBuilder: (_, index) => NftItem(
                assetUrl: nftList[index]
                    .displayUri
                    .replaceAll('ipfs://', 'https://ipfs.io/ipfs/'),
                assetValue: '${nftList[index].balance} XTZ',
                description: nftList[index].name,
              ),
              itemCount: nftList.length,
            ),
          ),
        ),
      ],
    );
  }
}
