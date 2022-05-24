import 'package:altme/home/tokens/view/widgets/token_item_shimmer.dart';
import 'package:flutter/material.dart';

class TokenListShimmer extends StatelessWidget {
  const TokenListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, __) => const TokenItemShimmer(),
        itemCount: 10,
      ),
    );
  }
}
