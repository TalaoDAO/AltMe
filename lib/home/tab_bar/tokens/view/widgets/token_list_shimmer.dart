import 'package:altme/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TokenListShimmer extends StatelessWidget {
  const TokenListShimmer({Key? key, required this.onRefresh}) : super(key: key);

  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, __) => const TokenItemShimmer(),
        itemCount: 3,
      ),
    );
  }
}
