import 'package:flutter/material.dart';

class BackgroundCard extends StatelessWidget {
  const BackgroundCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(15),
    this.margin = EdgeInsets.zero,
    this.color,
    this.height,
    this.width,
    this.borderRadius = 10,
  });

  final Widget? child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? color;
  final double? height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: child,
    );
  }
}
