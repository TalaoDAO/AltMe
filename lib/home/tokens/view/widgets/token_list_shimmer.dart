import 'package:altme/home/tokens/view/widgets/token_item_shimmer.dart';
import 'package:flutter/material.dart';

class TokenListShimmer extends StatelessWidget {
  const TokenListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, __) => const TokenItemShimmer(),
      itemCount: 3,
    );
  }
}
