import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class SearchListShimmer extends StatelessWidget {
  const SearchListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //physics: const BouncingScrollPhysics(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, __) => const SearchItemShimmer(),
      itemCount: 4,
    );
  }
}
