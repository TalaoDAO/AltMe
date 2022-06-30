import 'package:altme/home/tab_bar/tokens/models/models.dart';
import 'package:altme/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:flutter/material.dart';

typedef OnScrollEnded = Future<void> Function();

class TokenList extends StatefulWidget {
  const TokenList({
    Key? key,
    required this.tokenList,
    required this.onRefresh,
    this.onScrollEnded,
  }) : super(key: key);

  final List<TokenModel> tokenList;
  final RefreshCallback onRefresh;
  final OnScrollEnded? onScrollEnded;

  @override
  State<TokenList> createState() => _TokenListState();
}

class _TokenListState extends State<TokenList> {

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
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, index) => TokenItem(token: widget.tokenList[index]),
        itemCount: widget.tokenList.length,
      ),
    );
  }
}
