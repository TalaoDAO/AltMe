import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/constants.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar/parallelogram_clipper.dart';

class StrangeParallelogram extends StatelessWidget {
  const StrangeParallelogram({
    Key? key,
    required this.topChild,
    required this.layerChild,
  }) : super(key: key);

  final Widget topChild;
  final Widget layerChild;

  @override
  Widget build(BuildContext context) {
    final stack = List.generate(
      tabBarLayersQuantity,
      (index) => Positioned(
        left: tabBarLayersOffset * (index + 1) - 20,
        top: tabBarLayersOffset * (index + 1),
        child: CustomTabBarPainter(
          child: layerChild,
        ),
      ),
    );
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        ...stack,
        Positioned(left: -20, child: CustomTabBarPainter(child: topChild)),
      ],
    );
  }
}

class CustomTabBarPainter extends StatelessWidget {
  const CustomTabBarPainter({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final clipper = ParallelogramClipper();
    return CustomPaint(
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}
