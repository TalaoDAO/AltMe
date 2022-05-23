import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class NftItem extends StatelessWidget {
  const NftItem({
    Key? key,
    required this.assetUrl,
    required this.description,
    required this.assetValue,
  }) : super(key: key);

  final String assetUrl;
  final String description;
  final String assetValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.nftItemWidth,
      height: Sizes.nftItemHeight,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Expanded(
              child: Image.network(assetUrl, fit: BoxFit.fill),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            assetValue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
