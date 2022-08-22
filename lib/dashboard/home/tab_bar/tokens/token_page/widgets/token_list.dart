import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

typedef OnScrollEnded = Future<void> Function();

class TokenList extends StatefulWidget {
  const TokenList({
    Key? key,
    required this.tokenList,
    required this.onRefresh,
    this.onScrollEnded,
    this.onItemTap,
    this.isSecure = false,
  }) : super(key: key);

  final List<TokenModel> tokenList;
  final RefreshCallback onRefresh;
  final OnScrollEnded? onScrollEnded;
  final Function(TokenModel)? onItemTap;
  final bool isSecure;

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
        itemBuilder: (_, index) => TransparentInkWell(
          onTap: () => widget.onItemTap?.call(widget.tokenList[index]),
          child: TokenItem(
            token: widget.tokenList[index],
            isSecure: widget.isSecure,
          ),
        ),
        itemCount: widget.tokenList.length,
      ),
    );
  }
}
