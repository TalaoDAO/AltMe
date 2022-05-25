import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class TokenItemShimmer extends StatelessWidget {
  const TokenItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BackgroundCard(
      child: ListTile(
        leading: ShimmerWidget.circular(
          height: Sizes.tokenLogoSize,
          width: Sizes.tokenLogoSize,
        ),
        title: ShimmerWidget.rectangular(
          height: 20,
          width: 60,
        ),
        subtitle: ShimmerWidget.rectangular(
          height: 16,
          width: 40,
        ),
        trailing: ShimmerWidget.rectangular(
          height: 18,
          width: 50,
        ),
      ),
    );
  }
}
