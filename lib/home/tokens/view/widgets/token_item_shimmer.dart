import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class TokenItemShimmer extends StatelessWidget {
  const TokenItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 5, spreadRadius: 0, color: Colors.grey[300]!),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: const ListTile(
        leading: ShimmerWidget.circular(height: Sizes.tokenLogoSize),
        title: ShimmerWidget.rectangular(
          height: 20,
          width: 70,
        ),
        subtitle: ShimmerWidget.rectangular(
          height: 16,
          width: 50,
        ),
        trailing: ShimmerWidget.rectangular(
          height: 18,
          width: 60,
        ),
      ),
    );
  }
}
