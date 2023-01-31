import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/nft/widgets/nft_item.dart';
import 'package:flutter/material.dart';

typedef OnScrollEnded = Future<void> Function();

class NftList extends StatefulWidget {
  const NftList({
    super.key,
    required this.nftList,
    required this.onRefresh,
    this.onScrollEnded,
    this.onItemClick,
  });

  final List<NftModel> nftList;
  final RefreshCallback onRefresh;
  final OnScrollEnded? onScrollEnded;
  final dynamic Function(NftModel)? onItemClick;

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
    return RefreshIndicator(
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
          final model = widget.nftList[index];
          return NftItem(
            assetUrl: model.displayUrl ?? (model.thumbnailUrl ?? ''),
            onClick: () {
              widget.onItemClick?.call(model);
            },
            assetValue: model.balance,
            description: model.name,
            id: model.tokenId,
          );
        },
        itemCount: widget.nftList.length,
      ),
    );
  }
}
