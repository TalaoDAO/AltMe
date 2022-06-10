import 'package:altme/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TokenListShimmer extends StatelessWidget {
  const TokenListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //physics: const BouncingScrollPhysics(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, __) => const TokenItemShimmer(),
      itemCount: 3,
    );
  }
}
