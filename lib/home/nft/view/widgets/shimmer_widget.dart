import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.rectangular({
    this.width = double.infinity,
    required this.height,
    Key? key,
  })  : shapeBorder = const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        super(key: key);

  const ShimmerWidget.circular({
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const CircleBorder(),
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!.withOpacity(1),
        highlightColor: Colors.grey[100]!.withOpacity(0.2),
        period: const Duration(milliseconds: 1500),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: const Color(0xFFE0E0E0),
            shape: shapeBorder,
          ),
        ),
      );
}
