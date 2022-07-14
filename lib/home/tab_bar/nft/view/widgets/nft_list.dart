import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/widgets.dart';
import 'package:altme/home/tab_bar/tab_bar.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

typedef OnScrollEnded = Future<void> Function();

class NftList extends StatefulWidget {
  const NftList({
    Key? key,
    required this.nftList,
    required this.onRefresh,
    this.onScrollEnded,
  }) : super(key: key);

  final List<NftModel> nftList;
  final RefreshCallback onRefresh;
  final OnScrollEnded? onScrollEnded;

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
          height: 8,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: GridView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: Sizes.nftItemRatio,
              ),
              itemBuilder: (_, index) => NftItem(
                assetUrl: widget.nftList[index].displayUri.replaceAll(
                  'ipfs://',
                  Urls.talaoIpfsGateway,
                ),
                assetValue: widget.nftList[index].balance,
                description: widget.nftList[index].name,
              ),
              itemCount: widget.nftList.length,
            ),
          ),
        ),
      ],
    );
  }
}
