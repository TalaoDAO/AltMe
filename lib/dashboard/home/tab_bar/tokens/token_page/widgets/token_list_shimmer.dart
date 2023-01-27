import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TokenListShimmer extends StatelessWidget {
  const TokenListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //physics: const BouncingScrollPhysics(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, __) => const TokenItemShimmer(),
      itemCount: 10,
    );
  }
}
