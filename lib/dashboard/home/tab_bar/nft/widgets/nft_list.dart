import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/nft/widgets/nft_item.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnScrollEnded = Future<void> Function();

class NftList extends StatefulWidget {
  const NftList({
    Key? key,
    required this.nftList,
    required this.onRefresh,
    this.onScrollEnded,
    this.onItemClick,
  }) : super(key: key);

  final List<NftModel> nftList;
  final RefreshCallback onRefresh;
  final OnScrollEnded? onScrollEnded;
  final Function(NftModel)? onItemClick;

  @override
  State<NftList> createState() => _NftListState();
}

class _NftListState extends State<NftList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollControllerListener);
    super.initState();
  }

  void _scrollControllerListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      widget.onScrollEnded?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.nftList.length} ${l10n.items}',
          style: Theme.of(context).textTheme.listSubtitle,
        ),
        const SizedBox(
          height: Sizes.space2XSmall,
        ),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push<void>(
                ReceivePage.route(
                  accountAddress: context
                      .read<WalletCubit>()
                      .state
                      .currentAccount
                      .walletAddress,
                  tokenSymbol: l10n.nft,
                  description: l10n.sendOnlyNftToThisAddressDescription,
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  IconStrings.addSquare,
                  width: Sizes.icon,
                  height: Sizes.icon,
                ),
                const SizedBox(
                  width: Sizes.spaceXSmall,
                ),
                Text(
                  l10n.receiveNft,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: Sizes.spaceNormal,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: GridView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                childAspectRatio: Sizes.nftItemRatio,
              ),
              itemBuilder: (_, index) {
                return NftItem(
                  assetUrl: widget.nftList[index].displayUrl,
                  onClick: () {
                    widget.onItemClick?.call(widget.nftList[index]);
                  },
                  assetValue: widget.nftList[index].balance,
                  description: widget.nftList[index].name,
                  id: widget.nftList[index].tokenId,
                );
              },
              itemCount: widget.nftList.length,
            ),
          ),
        ),
      ],
    );
  }
}
