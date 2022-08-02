import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/list/widgets/credential_item_shimmer.dart';
import 'package:flutter/material.dart';

class CredentialListShimmer extends StatelessWidget {
  const CredentialListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        const ShimmerWidget.rectangular(
          height: 12,
          width: 100,
        ),
        const SizedBox(height: 15),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, __) => const CredentialItemShimmer(),
            itemCount: 12,
          ),
        ),
      ],
    );
  }
}
